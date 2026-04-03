package delivery

import (
	"io"

	"github.com/bste101/video-caching-backend/internal/usecase"
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

	videos, nextCursor, err := h.videoUsecase.GetFeed(cursor)
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
	userID := c.Locals("user_id").(string)
	// userID := "de479ba7-52ef-49cf-a976-144a015130b9" // TODO: remove after auth is implemented

	fileHeader, err := c.FormFile("video")
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "video file is required"})
	}
	file, err := fileHeader.Open()
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "failed to open video file"})
	}
	defer file.Close()

	fileBytes, err := io.ReadAll(file)
	if err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "failed to read video file"})
	}

	video, err := h.videoUsecase.UploadVideo(userID, fileBytes, fileHeader.Filename)
	if err != nil {
		return c.Status(500).JSON(fiber.Map{"error": "failed to upload video"})
	}
	return c.JSON(video)
}
