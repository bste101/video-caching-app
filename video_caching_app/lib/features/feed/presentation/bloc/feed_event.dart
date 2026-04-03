import "package:freezed_annotation/freezed_annotation.dart";

part "feed_event.freezed.dart";

@freezed
class FeedEvent with _$FeedEvent {
  const factory FeedEvent.fetchFeedRequested() = FetchFeedRequested;
  const factory FeedEvent.fetchMoreFeedRequested() = FetchMoreFeedRequested;
  const factory FeedEvent.toggleLikeRequested(String videoId) = ToggleLikeRequested;
  const factory FeedEvent.viewAdded(String videoId) = ViewAdded;
  const factory FeedEvent.uploadVideoRequested(String filePath) = UploadVideoRequested;
}
