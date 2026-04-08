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

	bucketName := "videos"
	ctx := context.Background()
	exists, err := client.BucketExists(ctx, bucketName)
	if err == nil && !exists {
		err = client.MakeBucket(ctx, bucketName, minio.MakeBucketOptions{})
		if err != nil {
			return nil, err
		}
		// Set public policy
		policy := `{
			"Version": "2012-10-17",
			"Statement": [
				{
					"Action": ["s3:GetBucketLocation", "s3:ListBucket"],
					"Effect": "Allow",
					"Principal": {"AWS": ["*"]},
					"Resource": ["arn:aws:s3:::` + bucketName + `"]
				},
				{
					"Action": ["s3:GetObject"],
					"Effect": "Allow",
					"Principal": {"AWS": ["*"]},
					"Resource": ["arn:aws:s3:::` + bucketName + `/*"]
				}
			]
		}`
		err = client.SetBucketPolicy(ctx, bucketName, policy)
		if err != nil {
			return nil, err
		}
	}

	return &MinioClient{
		Client: client,
		Bucket: bucketName,
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
