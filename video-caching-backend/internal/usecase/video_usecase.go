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
		videoIDs := make([]string, len(videos))
		for i, v := range videos {
			videoIDs[i] = v.ID
		}

		var likedVideoIDs []string
		if err := u.db.Table("likes").
			Where("user_id = ? AND video_id IN ?", userID, videoIDs).
			Pluck("video_id", &likedVideoIDs).Error; err != nil {
			return nil, "", err
		}

		likedMap := make(map[string]bool)
		for _, id := range likedVideoIDs {
			likedMap[id] = true
		}

		// We need to make sure we are not modifying the original slice if it's cached,
		// but since we unmarshaled it from JSON, it's a new slice.
		for i := range videos {
			videos[i].IsLiked = likedMap[videos[i].ID]
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

	var liked bool

	err := u.db.Transaction(func(tx *gorm.DB) error {

		likeRepo := repository.NewLikeRepository(tx)
		videoRepo := repository.NewVideoRepository(tx)

		exists, err := likeRepo.Exists(userID, videoID)
		if err != nil {
			return err
		}

		if exists {
			// ❌ unlike
			if err := likeRepo.Delete(userID, videoID); err != nil {
				return err
			}
			if err := videoRepo.DecrementLike(videoID); err != nil {
				return err
			}
			liked = false
		} else {
			// ❤️ like
			if err := likeRepo.Create(userID, videoID); err != nil {
				return err
			}
			if err := videoRepo.IncrementLike(videoID); err != nil {
				return err
			}
			liked = true
		}

		return nil
	})

	return liked, err
}

func (u *VideoUsecase) UploadVideo(userID string, fileData []byte, filename string) (*model.Video, error) {
	fmt.Printf("Uploading video for user %s: %s (%d bytes)\n", userID, filename, len(fileData))
	// 1. upload to MinIO
	objectName := "videos/" + filename
	_, err := u.minio.PutObject(cache.Ctx, "videos", objectName,
		bytes.NewReader(fileData), int64(len(fileData)), minio.PutObjectOptions{
			ContentType: "video/mp4",
		})
	if err != nil {
		return nil, err
	}
	fmt.Printf("Video uploaded to MinIO: %s\n", objectName)

	baseURL := os.Getenv("VIDEO_BASE_URL")
	if baseURL == "" {
		baseURL = "http://localhost:9000/videos/"
	}

	// 2. save video record to DB
	video := model.Video{
		ID:        uuid.New().String(),
		UserID:    userID,
		VideoURL:  baseURL + filename,
		LikeCount: 0,
		ViewCount: 0,
	}
	err = u.db.Create(&video).Error
	return &video, err
}
