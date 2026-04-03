package main

import (
	"log"
	"os"
	"time"

	"github.com/bste101/video-caching-backend/pkg/cache"
	"github.com/bste101/video-caching-backend/pkg/db"
	"github.com/bste101/video-caching-backend/pkg/middleware"
	"github.com/bste101/video-caching-backend/pkg/storage"
	"github.com/gofiber/fiber/v3"
	"github.com/gofiber/fiber/v3/middleware/cors"
	"github.com/gofiber/fiber/v3/middleware/limiter"
	"github.com/gofiber/fiber/v3/middleware/logger"

	"github.com/bste101/video-caching-backend/internal/delivery"
	"github.com/bste101/video-caching-backend/internal/repository"
	"github.com/bste101/video-caching-backend/internal/usecase"
)

func main() {

	gormDB := db.InitDB()

	sqlDB, err := gormDB.DB()
	if err != nil {
		log.Fatal("DB instance error:", err)
	}

	if err := sqlDB.Ping(); err != nil {
		log.Fatal("DB ping failed:", err)
	}

	log.Println("Database connected")

	minIO, err := storage.NewMinio()
	if err != nil {
		log.Fatal("MinIO connection failed:", err)
	}

	app := fiber.New(fiber.Config{
		CaseSensitive: true,
		StrictRouting: true,
		ServerHeader:  "Fiber",
		AppName:       "Video Caching Service",
		BodyLimit:     100* 1024 * 1024, // 1000MB
	})

	app.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowMethods: []string{"GET", "POST", "PUT", "DELETE"},
	}))

	app.Use(logger.New())
	app.Use(limiter.New(limiter.Config{
		Max:        100,
		Expiration: 1 * time.Minute,
	}))

	api := app.Group("/api")

	// public routes
	api.Get("/health", func(c fiber.Ctx) error {
		return c.JSON(fiber.Map{"status": "ok"})
	})

	redisClient := cache.NewRedis()

	userRepo := repository.NewUserRepository(gormDB)
	refreshRepo := repository.NewRefreshTokenRepository(gormDB)
	authUsecase := usecase.NewAuthUsecase(userRepo, refreshRepo)
	authHandler := delivery.NewAuthHandler(authUsecase)
	videoRepo := repository.NewVideoRepository(gormDB)
	videoUsecase := usecase.NewVideoUsecase(videoRepo, gormDB, redisClient, minIO.Client)
	videoHandler := delivery.NewVideoHandler(videoUsecase)

	// Auth routes (public)
	auth := api.Group("/auth")
	auth.Post("/login", authHandler.SocialLogin)
	auth.Post("/refresh", authHandler.Refresh)
	auth.Post("/logout", authHandler.Logout)

	// Video routes
	videos := api.Group("/videos")
	videos.Get("/feed", videoHandler.GetFeed)
	videos.Post("/:id/views", videoHandler.AddView)

	// Protected routes
	protected := api.Group("/", middleware.AuthMiddleware())
	protected.Post("/videos/:id/like", videoHandler.ToggleLike)
	protected.Post("/videos/upload", videoHandler.UploadVideo)

	// health check at root
	app.Get("/", func(c fiber.Ctx) error {
		return c.SendString("Server is running!!! ")
	})

	// port
	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	log.Println("🚀 Server running on port:", port)

	log.Fatal(app.Listen(":" + port))
}
