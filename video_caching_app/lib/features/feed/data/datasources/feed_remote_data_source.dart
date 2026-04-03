import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/video_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<VideoModel>> getFeed({String? cursor});
  Future<bool> toggleLike(String videoId);
  Future<void> addView(String videoId);
  Future<VideoModel> uploadVideo(String filePath);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio _dio;

  FeedRemoteDataSourceImpl(this._dio);

  static final String _baseUrl = dotenv.get('API_BASE_URL', fallback: 'http://localhost:8000/api');

  @override
  Future<List<VideoModel>> getFeed({String? cursor}) async {
    final response = await _dio.get(
      '$_baseUrl/videos/feed',
      queryParameters: cursor != null ? {'cursor': cursor} : null,
    );

    final List videosJson = response.data['videos'] ?? [];
    return videosJson.map((json) => VideoModel.fromJson(json)).toList();
  }

  @override
  Future<bool> toggleLike(String videoId) async {
    final response = await _dio.post('$_baseUrl/videos/$videoId/like');
    return response.data['liked'] ?? false;
  }

  @override
  Future<void> addView(String videoId) async {
    await _dio.post('$_baseUrl/videos/$videoId/views');
  }

  @override
  Future<VideoModel> uploadVideo(String filePath) async {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await _dio.post(
      '$_baseUrl/videos/upload',
      data: formData,
    );

    return VideoModel.fromJson(response.data);
  }
}
