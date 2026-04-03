package model

import (
	"time"
)

type Like struct {
	UserID    string `gorm:"primaryKey" json:"userId"`
	VideoID   string `gorm:"primaryKey" json:"videoId"`
	CreatedAt time.Time `gorm:"autoCreateTime" json:"createdAt"`
}
