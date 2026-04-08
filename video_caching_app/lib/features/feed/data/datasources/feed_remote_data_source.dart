import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/video_model.dart';
import 'package:get_storage/get_storage.dart';

abstract class FeedRemoteDataSource {
  Future<List<VideoModel>> getFeed({String? cursor});
  Future<bool> toggleLike(String videoId);
  Future<void> addView(String videoId);
  Future<VideoModel> uploadVideo(String filePath);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio _dio;

  FeedRemoteDataSourceImpl(this._dio);

  static final String _baseUrl = dotenv.get(
    'API_BASE_URL',
    fallback: 'http://localhost:8000/api',
  );

  @override
  Future<List<VideoModel>> getFeed({String? cursor}) async {
    final storage = GetStorage();
    final String? token = storage.read('auth_token');

    final response = await _dio.get(
      '$_baseUrl/videos/feed',
      queryParameters: cursor != null ? {'cursor': cursor} : null,
      options: token != null
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null,
    );

    final List videosJson = response.data['videos'] ?? [];
    return videosJson.map((json) => VideoModel.fromJson(json)).toList();
  }

  @override
  Future<bool> toggleLike(String videoId) async {
    final storage = GetStorage();
    final String? token = storage.read('auth_token');

    if (token == null) throw Exception('User not authenticated');

    final response = await _dio.post(
      '$_baseUrl/videos/$videoId/like',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['liked'] ?? false;
  }

  @override
  Future<void> addView(String videoId) async {
    final storage = GetStorage();
    final String? token = storage.read('auth_token');

    await _dio.post(
      '$_baseUrl/videos/$videoId/views',
      options: token != null
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null,
    );
  }

  @override
  Future<VideoModel> uploadVideo(String filePath) async {

    final storage = GetStorage();
    
    final String? token = storage.read(
      'auth_token',
    ); 

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    final response = await _dio.post(
      '$_baseUrl/videos/upload',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return VideoModel.fromJson(response.data);
  }
}
