import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_model.freezed.dart';
part 'video_model.g.dart';

@freezed
abstract class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String videoUrl,
    String? thumbnailUrl,
    @Default('') String caption,
    @Default(0) int likeCount,
    @Default(0) int viewCount,
    @Default(false) bool isLiked,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
}
