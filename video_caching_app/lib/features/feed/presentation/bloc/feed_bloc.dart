import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/feed_remote_data_source.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedRemoteDataSource _feedRemoteDataSource;

  FeedBloc(this._feedRemoteDataSource) : super(const FeedState.initial()) {
    on<FetchFeedRequested>(_onFetchFeedRequested);
    on<FetchMoreFeedRequested>(_onFetchMoreFeedRequested);
    on<ToggleLikeRequested>(_onToggleLikeRequested);
    on<ViewAdded>(_onViewAdded);
    on<UploadVideoRequested>(_onUploadVideoRequested);
    on<Reset>((event, emit) => emit(const FeedState.initial()));
  }

  Future<void> _onUploadVideoRequested(
    UploadVideoRequested event,
    Emitter<FeedState> emit,
  ) async {
    try {
      await _feedRemoteDataSource.uploadVideo(event.filePath);
      // After upload, trigger a full refresh to get the updated feed from server
      add(const FetchFeedRequested());
    } catch (e) {
      print("Upload failed: $e");
    }
  }

  Future<void> _onFetchFeedRequested(
    FetchFeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    emit(const FeedState.loading());
    try {
      final videos = await _feedRemoteDataSource.getFeed();
      emit(FeedState.success(videos: videos, hasReachedMax: videos.isEmpty));
    } catch (e) {
      emit(FeedState.failure('Failed to fetch feed: $e'));
    }
  }

  Future<void> _onFetchMoreFeedRequested(
    FetchMoreFeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    await state.mapOrNull(
      success: (currentState) async {
        if (currentState.hasReachedMax) return;

        try {
          final videos = await _feedRemoteDataSource.getFeed(cursor: currentState.cursor);
          if (videos.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(currentState.copyWith(
              videos: [...currentState.videos, ...videos],
              hasReachedMax: false,
            ));
          }
        } catch (_) {
          // Silently fail for "load more"
        }
      },
    );
  }

  Future<void> _onToggleLikeRequested(
    ToggleLikeRequested event,
    Emitter<FeedState> emit,
  ) async {
    await state.mapOrNull(
      success: (currentState) async {
        // --- Optimistic Update ---
        final oldVideos = currentState.videos;
        final updatedVideos = oldVideos.map((v) {
          if (v.id == event.videoId) {
            final newIsLiked = !v.isLiked;
            return v.copyWith(
              isLiked: newIsLiked,
              likeCount: newIsLiked ? v.likeCount + 1 : v.likeCount - 1,
            );
          }
          return v;
        }).toList();

        emit(currentState.copyWith(videos: updatedVideos));

        try {
          final isLikedOnBackend = await _feedRemoteDataSource.toggleLike(event.videoId);
          
          state.mapOrNull(
            success: (actualState) {
              final verifiedVideos = actualState.videos.map((v) {
                if (v.id == event.videoId && v.isLiked != isLikedOnBackend) {
                  return v.copyWith(
                    isLiked: isLikedOnBackend,
                    likeCount: isLikedOnBackend ? v.likeCount + 1 : v.likeCount - 1,
                  );
                }
                return v;
              }).toList();
              emit(actualState.copyWith(videos: verifiedVideos));
            },
          );
        } catch (e) {
          state.mapOrNull(
            success: (actualState) {
              emit(actualState.copyWith(videos: oldVideos));
            },
          );
        }
      },
    );
  }

  Future<void> _onViewAdded(
    ViewAdded event,
    Emitter<FeedState> emit,
  ) async {
    try {
      await _feedRemoteDataSource.addView(event.videoId);
    } catch (_) {}
  }
}
