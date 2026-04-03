package repository

import (
	"github.com/bste101/video-caching-backend/internal/model"
	"github.com/google/uuid"
	"gorm.io/gorm"
)

type UserRepository struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{db}
}

func (r *UserRepository) FindByEmail(email string) (*model.User, error) {
	var user model.User
	err := r.db.Where("email = ?", email).First(&user).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) Create(user *model.User) error {
	user.ID = uuid.New().String()
	return r.db.Create(user).Error
}

func (r *UserRepository) FindByProvider(provider, providerUserID string) (*model.User, error) {
	var auth model.AuthProvider

	err := r.db.Where("provider = ? AND provider_user_id = ?", provider, providerUserID).
		First(&auth).Error

	if err != nil {
		return nil, err
	}

	var user model.User
	err = r.db.First(&user, "id = ?", auth.UserID).Error

	return &user, err
}

func (r *UserRepository) CreateWithProvider(user *model.User, provider, providerUserID string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		user.ID = uuid.New().String()

		if err := tx.Create(user).Error; err != nil {
			return err
		}

		auth := model.AuthProvider{
			ID:             uuid.New().String(),
			UserID:         user.ID,
			Provider:       provider,
			ProviderUserID: providerUserID,
		}

		return tx.Create(&auth).Error
	})
}

func (r *UserRepository) LinkProvider(userID, provider, providerUserID string) error {
	auth := model.AuthProvider{
		ID:             uuid.New().String(),
		UserID:         userID,
		Provider:       provider,
		ProviderUserID: providerUserID,
	}
	return r.db.Create(&auth).Error
}
