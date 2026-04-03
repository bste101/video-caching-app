import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
abstract class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String id,
    required String userId,
    required String videoUrl,
    String? thumbnailUrl,
    required String caption,
    @Default(0) int likeCount,
    @Default(0) int viewCount,
    @Default(false) bool isLiked, // Local UI state
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
}
