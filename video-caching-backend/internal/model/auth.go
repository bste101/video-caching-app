package model

import (
	"time"
)

type AuthProvider struct {
	ID     string `gorm:"type:uuid;primaryKey" json:"id"`
	UserID string `gorm:"index" json:"userId"`

	Provider       string `gorm:"index" json:"provider"`
	ProviderUserID string `gorm:"index;uniqueIndex:idx_provider_user" json:"providerUserId"`

	CreatedAt time.Time `gorm:"autoCreateTime" json:"createdAt"`
}
