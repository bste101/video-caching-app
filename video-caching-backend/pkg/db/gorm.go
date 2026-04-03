package db

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/bste101/video-caching-backend/internal/model"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

func InitDB() *gorm.DB {
	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=5432 sslmode=disable",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
	)

	var db *gorm.DB
	var err error

	for i := 0; i < 10; i++ {
		db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
			Logger: logger.Default.LogMode(logger.Info),
		})

		if err == nil {
			break
		}

		fmt.Println("Waiting for DB...")
		time.Sleep(2 * time.Second)
	}

	if err != nil {
		panic("Failed to connect DB: " + err.Error())
	}

	sqlDB, err := db.DB()
	if err != nil {
		panic(err)
	}

	sqlDB.SetMaxIdleConns(10)
	sqlDB.SetMaxOpenConns(100)
	sqlDB.SetConnMaxLifetime(time.Hour)

	fmt.Println("Connected to DB")

	// Auto-migrate models
	err = db.AutoMigrate(
		&model.User{},
		&model.AuthProvider{},
		&model.Video{},
		&model.Like{},
		&model.RefreshToken{},
	)
	if err != nil {
		panic("Failed to auto-migrate: " + err.Error())
	}
	log.Println("Database migrated successfully")
	return db
}
