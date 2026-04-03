package delivery

import (
	"github.com/bste101/video-caching-backend/internal/usecase"
	"github.com/gofiber/fiber/v3"
)

type AuthHandler struct {
	authUsecase *usecase.AuthUsecase
}

func NewAuthHandler(authUsecase *usecase.AuthUsecase) *AuthHandler {
	return &AuthHandler{authUsecase}
}

func (h *AuthHandler) SocialLogin(c fiber.Ctx) error {
	var body struct {
		Provider string `json:"provider"`
		Token    string `json:"token"`
	}

	if err := c.Bind().Body(&body); err != nil {
		return c.Status(400).JSON(fiber.Map{"error": "invalid request"})
	}

	token, user, err := h.authUsecase.Login(body.Provider, body.Token)
	if err != nil {
		return c.Status(401).JSON(fiber.Map{"error": err.Error()})
	}

	return c.JSON(fiber.Map{
		"token": token,
		"user":  user,
	})
}

func (h *AuthHandler) Refresh(c fiber.Ctx) error {
	var body struct {
		RefreshToken string `json:"refreshToken"`
	}

	if err := c.Bind().Body(&body); err != nil {
		return c.SendStatus(400)
	}

	access, refresh, err := h.authUsecase.Refresh(body.RefreshToken)
	if err != nil {
		return c.SendStatus(401)
	}

	return c.JSON(fiber.Map{
		"accessToken":  access,
		"refreshToken": refresh,
	})
}

func (h *AuthHandler) Logout(c fiber.Ctx) error {
	var body struct {
		RefreshToken string `json:"refreshToken"`
	}

	c.Bind().Body(&body)

	h.authUsecase.Logout(body.RefreshToken)

	return c.SendStatus(200)
}
