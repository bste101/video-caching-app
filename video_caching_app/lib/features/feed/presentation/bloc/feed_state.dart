import "package:freezed_annotation/freezed_annotation.dart";
import "../../data/models/video_model.dart";

part "feed_state.freezed.dart";

@freezed
class FeedState with _$FeedState {
  const factory FeedState.initial() = _Initial;
  const factory FeedState.loading() = _Loading;
  const factory FeedState.success({
    required List<VideoModel> videos,
    String? cursor,
    @Default(false) bool hasReachedMax,
  }) = _Success;
  const factory FeedState.failure(String message) = _Failure;
}
