package usecase

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/bste101/video-caching-backend/pkg/cache"
	"github.com/google/uuid"
	"github.com/minio/minio-go/v7"
	"github.com/redis/go-redis/v9"

	"github.com/bste101/video-caching-backend/internal/model"
	"github.com/bste101/video-caching-backend/internal/repository"
	"gorm.io/gorm"
)

type VideoUsecase struct {
	videoRepo *repository.VideoRepository
	db        *gorm.DB
	redis     *cache.RedisClient
	minio     *minio.Client
}

func NewVideoUsecase(repo *repository.VideoRepository, db *gorm.DB, redis *cache.RedisClient, minio *minio.Client) *VideoUsecase {
	return &VideoUsecase{
		videoRepo: repo,
		db:        db,
		redis:     redis,
		minio:     minio,
	}
}

func (u *VideoUsecase) GetFeed(cursorStr string, userID string) ([]model.Video, string, error) {

	cacheKey := "feed:" + cursorStr

	// 🔥 1. try cache
	var videos []model.Video
	var nextCursor string

	val, err := u.redis.Client.Get(cache.Ctx, cacheKey).Result()
	if err == nil {
		var cached struct {
			Videos     []model.Video
			NextCursor string
		}
		if err := json.Unmarshal([]byte(val), &cached); err == nil {
			videos = cached.Videos
			nextCursor = cached.NextCursor
		}
	}

	if videos == nil {
		// ❌ cache miss → query DB
		videos, nextCursor, err = u.getFeedFromDB(cursorStr)
		if err != nil {
			return nil, "", err
		}

		// 🔥 2. save cache
		data, _ := json.Marshal(map[string]interface{}{
			"videos":     videos,
			"nextCursor": nextCursor,
		})

		u.redis.Client.Set(cache.Ctx, cacheKey, data, 30*time.Second)
	}

	// 🔥 3. If userID is provided, check like status for each video
	if userID != "" && len(videos) > 0 {
		userLikesKey := fmt.Sprintf("user:%s:likes", userID)
		populatedKey := userLikesKey + ":populated"

		// Check if Redis is populated for this user
		isPopulated, _ := u.redis.Client.Exists(cache.Ctx, populatedKey).Result()

		if isPopulated == 0 {
			// ❌ Not populated → fetch ALL liked video IDs from DB for this user
			var allLikedVideoIDs []string
			if err := u.db.Table("likes").
				Where("user_id = ?", userID).
				Pluck("video_id", &allLikedVideoIDs).Error; err == nil {

				// Populate Redis
				if len(allLikedVideoIDs) > 0 {
					// Convert []string to []interface{} for SAdd
					interfaceIDs := make([]interface{}, len(allLikedVideoIDs))
					for i, id := range allLikedVideoIDs {
						interfaceIDs[i] = id
					}
					u.redis.Client.SAdd(cache.Ctx, userLikesKey, interfaceIDs...)
				}
				// Set populated flag with TTL
				u.redis.Client.Set(cache.Ctx, populatedKey, "1", 24*time.Hour)
			}
		}

		// Now check like status for each video in the feed using Redis Pipeline
		pipe := u.redis.Client.Pipeline()
		cmds := make([]*redis.BoolCmd, len(videos))
		for i := range videos {
			cmds[i] = pipe.SIsMember(cache.Ctx, userLikesKey, videos[i].ID)
		}
		_, _ = pipe.Exec(cache.Ctx)

		for i := range videos {
			liked, _ := cmds[i].Result()
			videos[i].IsLiked = liked
		}
	}

	return videos, nextCursor, nil
}

func (u *VideoUsecase) getFeedFromDB(cursorStr string) ([]model.Video, string, error) {

	var cursor *time.Time

	if cursorStr != "" {
		t, err := time.Parse(time.RFC3339, cursorStr)
		if err == nil {
			cursor = &t
		}
	}

	videos, err := u.videoRepo.GetFeed(cursor, 10)
	if err != nil {
		return nil, "", err
	}

	var nextCursor string
	if len(videos) > 0 {
		nextCursor = videos[len(videos)-1].CreatedAt.Format(time.RFC3339)
	}

	return videos, nextCursor, nil
}

func (u *VideoUsecase) AddView(videoID string) {
	go u.videoRepo.IncrementView(videoID)
}

func (u *VideoUsecase) ToggleLike(userID, videoID string) (bool, error) {
	userLikesKey := fmt.Sprintf("user:%s:likes", userID)
	populatedKey := userLikesKey + ":populated"

	// 1. Check Redis first
	isLiked, err := u.redis.Client.SIsMember(cache.Ctx, userLikesKey, videoID).Result()
	
	// If Redis returns false, check if it's actually populated
	if err == nil && !isLiked {
		isPopulated, _ := u.redis.Client.Exists(cache.Ctx, populatedKey).Result()
		if isPopulated == 0 {
			// Not populated in Redis, force DB check
			err = fmt.Errorf("redis not populated")
		}
	}

	var liked bool
	err = u.db.Transaction(func(tx *gorm.DB) error {
		likeRepo := repository.NewLikeRepository(tx)
		videoRepo := repository.NewVideoRepository(tx)

		// If Redis didn't have the info (error or not populated), check DB
		if err != nil {
			exists, err := likeRepo.Exists(userID, videoID)
			if err != nil {
				return err
			}
			isLiked = exists
		}

		if isLiked {
			// ❌ unlike
			if err := likeRepo.Delete(userID, videoID); err != nil {
				return err
			}
			if err := videoRepo.DecrementLike(videoID); err != nil {
				return err
			}
			liked = false
			// Update Redis
			u.redis.Client.SRem(cache.Ctx, userLikesKey, videoID)
		} else {
			// ❤️ like
			if err := likeRepo.Create(userID, videoID); err != nil {
				return err
			}
			if err := videoRepo.IncrementLike(videoID); err != nil {
				return err
			}
			liked = true
			// Update Redis
			u.redis.Client.SAdd(cache.Ctx, userLikesKey, videoID)
		}

		return nil
	})

	return liked, err
}

func (u *VideoUsecase) UploadVideo(userID string, fileData []byte, filename string) (*model.Video, error) {
	fmt.Printf("Uploading video for user %s: %s (%d bytes)\n", userID, filename, len(fileData))
	// 1. upload to MinIO
	objectName := filename

	_, err := u.minio.PutObject(
		cache.Ctx,
		"videos",
		objectName,
		bytes.NewReader(fileData),
		int64(len(fileData)),
		minio.PutObjectOptions{
			ContentType: "video/mp4",
		},
	)
	if err != nil {
		return nil, err
	}

	baseURL := os.Getenv("VIDEO_BASE_URL")
	if baseURL == "" {
		baseURL = "http://localhost:9000"
	}

	video := model.Video{
		ID:        uuid.New().String(),
		UserID:    userID,
		VideoURL:  baseURL + "/videos/" + filename,
		LikeCount: 0,
		ViewCount: 0,
	}
	err = u.db.Create(&video).Error
	return &video, err
}
