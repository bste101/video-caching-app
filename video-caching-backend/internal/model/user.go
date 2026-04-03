package model

import (
	"time"
)

type User struct {
	ID        string `gorm:"type:uuid;primaryKey" json:"id"`
	Email     string `json:"email"`
	Name      string `json:"name"`
	AvatarURL string `json:"avatarUrl"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"createdAt"`
}

type UserRepository interface {
	CreateUser(user *User) error
	GetUserByID(id string) (*User, error)
	GetUserByEmail(email string) (*User, error)
}

type UserUseCase interface {
	RegisterUser(email, name, avatarURL string) (*User, error)
	GetUserProfile(id string) (*User, error)
}
