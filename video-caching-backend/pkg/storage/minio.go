package storage

import (
	"context"
	"net/url"
	"os"
	"strconv"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

type MinioClient struct {
	Client *minio.Client
	Bucket string
}

func NewMinio() (*MinioClient, error) {
	endpoint := os.Getenv("MINIO_ENDPOINT")
	accessKey := os.Getenv("MINIO_ACCESS_KEY")
	secretKey := os.Getenv("MINIO_SECRET_KEY")

	secure, err := strconv.ParseBool(os.Getenv("MINIO_SECURE"))
	if err != nil {
		secure = false
	}

	client, err := minio.New(endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(accessKey, secretKey, ""),
		Secure: secure,
	})
	if err != nil {
		return nil, err
	}

	return &MinioClient{
		Client: client,
		Bucket: "videos",
	}, nil
}

func (m *MinioClient) UploadVideo(objectName string, filePath string) (string, error) {
	_, err := m.Client.FPutObject(
		context.Background(),
		m.Bucket,
		objectName,
		filePath,
		minio.PutObjectOptions{ContentType: "video/mp4"},
	)
	if err != nil {
		return "", err
	}

	objectURL := url.URL{
		Scheme: "http",
		Host:   m.Client.EndpointURL().Host,
		Path:   objectName,
	}

	return objectURL.String(), nil
}
