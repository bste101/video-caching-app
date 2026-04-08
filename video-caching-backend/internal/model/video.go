package model

import (
	"time"
)

type Video struct {
	ID     string `gorm:"type:uuid;primaryKey" json:"id"`
	UserID string `json:"user_id"`

	VideoURL     string `json:"videoUrl"`
	ThumbnailURL string `json:"thumbnailUrl"`
	Caption      string `json:"caption"`

	LikeCount int `gorm:"default:0" json:"likeCount"`
	ViewCount int `gorm:"default:0" json:"viewCount"`

	IsLiked bool `json:"isLiked" gorm:"-"`

	CreatedAt time.Time `gorm:"autoCreateTime" json:"createdAt"`
}
