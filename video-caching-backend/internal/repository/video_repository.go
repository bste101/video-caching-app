package repository

import (
	"time"

	"github.com/bste101/video-caching-backend/internal/model"
	"gorm.io/gorm"
)

type VideoRepository struct {
	db *gorm.DB
}

func NewVideoRepository(db *gorm.DB) *VideoRepository {
	return &VideoRepository{db}
}

func (r *VideoRepository) GetFeed(cursor *time.Time, limit int) ([]model.Video, error) {
	var videos []model.Video

	query := r.db.
		Order("created_at DESC").
		Limit(limit)

	if cursor != nil {
		query = query.Where("created_at < ?", *cursor)
	}

	err := query.Find(&videos).Error
	return videos, err
}

func (r *VideoRepository) IncrementLike(videoID string) error {
	return r.db.Model(&model.Video{}).
		Where("id = ?", videoID).
		UpdateColumn("like_count", gorm.Expr("like_count + ?", 1)).Error
}

func (r *VideoRepository) DecrementLike(videoID string) error {
	return r.db.Model(&model.Video{}).
		Where("id = ?", videoID).
		UpdateColumn("like_count", gorm.Expr("like_count - ?", 1)).Error
}

func (r *VideoRepository) IncrementView(videoID string) error {
	return r.db.Model(&model.Video{}).
		Where("id = ?", videoID).
		UpdateColumn("view_count", gorm.Expr("view_count + ?", 1)).Error
}
