package delivery

import (
	"io"
	"log"
	"strings"

	"github.com/bste101/video-caching-backend/internal/usecase"
	"github.com/bste101/video-caching-backend/pkg/jwt"
	"github.com/gofiber/fiber/v3"
)

type VideoHandler struct {
	videoUsecase *usecase.VideoUsecase
}

func NewVideoHandler(u *usecase.VideoUsecase) *VideoHandler {
	return &VideoHandler{u}
}

func (h *VideoHandler) GetFeed(c fiber.Ctx) error {

	cursor := c.Query("cursor")

	// Extract userID from token if provided (optional for public feed)
	var userID string
	authHeader := c.Get("Authorization")
	if authHeader != "" {
		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")
		claims, err := jwt.ParseJWT(tokenStr)
		if err == nil {
			userID = claims.UserID
		}
	}

	videos, nextCursor, err := h.videoUsecase.GetFeed(cursor, userID)
	if err != nil {
		return c.SendStatus(500)
	}

	return c.JSON(fiber.Map{
		"videos":     videos,
		"nextCursor": nextCursor,
	})
}

func (h *VideoHandler) ToggleLike(c fiber.Ctx) error {

	userID := c.Locals("user_id").(string)
	videoID := c.Params("id")

	liked, err := h.videoUsecase.ToggleLike(userID, videoID)
	if err != nil {
		return c.SendStatus(500)
	}

	return c.JSON(fiber.Map{
		"liked": liked,
	})
}

func (h *VideoHandler) AddView(c fiber.Ctx) error {

	videoID := c.Params("id")

	h.videoUsecase.AddView(videoID)

	return c.SendStatus(200)
}

func (h *VideoHandler) UploadVideo(c fiber.Ctx) error {
	userIDRaw := c.Locals("user_id")
	if userIDRaw == nil {
		return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"error": "Unauthorized: User ID not found in token",
		})
	}

	userID, ok := userIDRaw.(string)
	if !ok {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Server Error: User ID format invalid",
		})
	}

	fileHeader, err := c.FormFile("video")
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "video file is required",
		})
	}

	file, err := fileHeader.Open()
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "failed to open video file",
		})
	}
	defer file.Close()

	fileBytes, err := io.ReadAll(file)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to read video file",
		})
	}

	video, err := h.videoUsecase.UploadVideo(userID, fileBytes, fileHeader.Filename)
	if err != nil {
		log.Printf("Upload Error: %v", err) // ปริ้นท์ error ดูใน Console จะได้แก้ง่ายๆ
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "failed to upload video",
		})
	}

	// 7. สำเร็จ! ส่งข้อมูลวิดีโอกลับไป
	return c.JSON(video)
}
