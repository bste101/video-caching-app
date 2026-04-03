package usecase

import (
	"encoding/json"
	"errors"
	"net/http"
	"time"

	"github.com/bste101/video-caching-backend/internal/model"
	"github.com/bste101/video-caching-backend/internal/repository"
	"github.com/bste101/video-caching-backend/pkg/jwt"
)

type AuthUsecase struct {
	userRepo    *repository.UserRepository
	refreshRepo *repository.RefreshTokenRepository
}

func NewAuthUsecase(userRepo *repository.UserRepository, refreshRepo *repository.RefreshTokenRepository) *AuthUsecase {
	return &AuthUsecase{userRepo, refreshRepo}
}

type SocialUser struct {
	ID      string
	Email   string
	Name    string
	Picture string
}

// 🎯 main entry
func (u *AuthUsecase) Login(provider string, token string) (string, *model.User, error) {
	var socialUser *SocialUser
	var err error

	switch provider {
	case "google":
		socialUser, err = u.verifyGoogle(token)
	case "apple":
		socialUser, err = u.verifyApple(token)
	case "line":
		socialUser, err = u.verifyLine(token)
	default:
		return "", nil, errors.New("unsupported provider")
	}

	if err != nil {
		return "", nil, err
	}

	// 🔍 หา user จาก provider
	user, err := u.userRepo.FindByProvider(provider, socialUser.ID)

	if err != nil {

		user, err = u.userRepo.FindByEmail(socialUser.Email)
		if err == nil {
			// 🔗 link account
			u.userRepo.LinkProvider(user.ID, provider, socialUser.ID)
		} else {
			// 🆕 create ใหม่
			user = &model.User{
				Email: socialUser.Email,
				Name:  socialUser.Name,
			}
			u.userRepo.CreateWithProvider(user, provider, socialUser.ID)
		}
	}

	// 🔑 JWT
	tokenStr, err := jwt.GenerateJWT(user.ID)
	if err != nil {
		return "", nil, err
	}

	return tokenStr, user, nil
}

func (u *AuthUsecase) verifyGoogle(idToken string) (*SocialUser, error) {
	resp, err := http.Get(
		"https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken,
	)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var data struct {
		Sub     string `json:"sub"`
		Email   string `json:"email"`
		Name    string `json:"name"`
		Picture string `json:"picture"`
	}

	json.NewDecoder(resp.Body).Decode(&data)

	return &SocialUser{
		ID:      data.Sub,
		Email:   data.Email,
		Name:    data.Name,
		Picture: data.Picture,
	}, nil
}

func (u *AuthUsecase) verifyApple(identityToken string) (*SocialUser, error) {
	return &SocialUser{
		ID:    "apple_user_id",
		Email: "apple@email.com",
		Name:  "Apple User",
	}, nil
}

func (u *AuthUsecase) verifyLine(accessToken string) (*SocialUser, error) {
	req, _ := http.NewRequest("GET", "https://api.line.me/v2/profile", nil)
	req.Header.Set("Authorization", "Bearer "+accessToken)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var data struct {
		UserID      string `json:"userId"`
		DisplayName string `json:"displayName"`
		PictureURL  string `json:"pictureUrl"`
	}

	json.NewDecoder(resp.Body).Decode(&data)

	return &SocialUser{
		ID:      data.UserID,
		Name:    data.DisplayName,
		Picture: data.PictureURL,
	}, nil
}

func (u *AuthUsecase) issueTokens(userID string) (string, string, error) {
	accessToken, err := jwt.GenerateJWT(userID)
	if err != nil {
		return "", "", err
	}

	rt, err := u.refreshRepo.Create(userID)
	if err != nil {
		return "", "", err
	}

	return accessToken, rt.Token, nil
}

func (u *AuthUsecase) Refresh(oldToken string) (string, string, error) {

	rt, err := u.refreshRepo.Find(oldToken)
	if err != nil {
		return "", "", err
	}

	// ❌ หมดอายุ
	if time.Now().After(rt.ExpiresAt) {
		return "", "", errors.New("expired refresh token")
	}

	// 🔥 rotation (สำคัญมาก)
	_ = u.refreshRepo.Delete(oldToken)

	newRT, err := u.refreshRepo.Create(rt.UserID)
	if err != nil {
		return "", "", err
	}

	newAccess, err := jwt.GenerateJWT(rt.UserID)
	if err != nil {
		return "", "", err
	}

	return newAccess, newRT.Token, nil
}

func (u *AuthUsecase) Logout(refreshToken string) error {
	return u.refreshRepo.Delete(refreshToken)
}