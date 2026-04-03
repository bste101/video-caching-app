package repository

import (
	"github.com/bste101/video-caching-backend/internal/model"
	"gorm.io/gorm"
)

type LikeRepository struct {
	db *gorm.DB
}

func NewLikeRepository(db *gorm.DB) *LikeRepository {
	return &LikeRepository{db}
}

func (r *LikeRepository) Exists(userID, videoID string) (bool, error) {
	var count int64
	err := r.db.Model(&model.Like{}).
		Where("user_id = ? AND video_id = ?", userID, videoID).
		Count(&count).Error

	return count > 0, err
}

func (r *LikeRepository) Create(userID, videoID string) error {
	return r.db.Create(&model.Like{
		UserID:  userID,
		VideoID: videoID,
	}).Error
}

func (r *LikeRepository) Delete(userID, videoID string) error {
	return r.db.Delete(&model.Like{}, "user_id = ? AND video_id = ?", userID, videoID).Error
}
