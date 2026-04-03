package middleware

import (
	"strings"

	"github.com/bste101/video-caching-backend/pkg/jwt"
	"github.com/gofiber/fiber/v3"
)

func AuthMiddleware() fiber.Handler {
	return func(c fiber.Ctx) error {

		authHeader := c.Get("Authorization")

		if authHeader == "" {
			return c.SendStatus(401)
		}

		tokenStr := strings.TrimPrefix(authHeader, "Bearer ")

		claims, err := jwt.ParseJWT(tokenStr)
		if err != nil {
			return c.SendStatus(401)
		}

		// 🔥 set user id
		c.Locals("user_id", claims.UserID)

		return c.Next()
	}
}
