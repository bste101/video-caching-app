package repository

import (
	"time"

	"github.com/bste101/video-caching-backend/internal/model"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type RefreshTokenRepository struct {
	db *gorm.DB
}

func NewRefreshTokenRepository(db *gorm.DB) *RefreshTokenRepository {
	return &RefreshTokenRepository{db}
}

func (r *RefreshTokenRepository) Create(userID string) (*model.RefreshToken, error) {
	token := &model.RefreshToken{
		ID:        uuid.New().String(),
		UserID:    userID,
		Token:     uuid.New().String(),
		ExpiresAt: time.Now().Add(7 * 24 * time.Hour),
	}

	return token, r.db.Create(token).Error
}

func (r *RefreshTokenRepository) Find(token string) (*model.RefreshToken, error) {
	var rt model.RefreshToken
	err := r.db.Where("token = ?", token).First(&rt).Error
	return &rt, err
}

func (r *RefreshTokenRepository) Delete(token string) error {
	return r.db.Where("token = ?", token).Delete(&model.RefreshToken{}).Error
}
