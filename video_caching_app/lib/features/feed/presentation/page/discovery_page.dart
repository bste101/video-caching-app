import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_state.dart';
import '../widgets/video_player_widget.dart';
import '../../data/models/video_model.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discovery', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (message) => Center(child: Text(message, style: const TextStyle(color: Colors.white))),
            success: (videos, cursor, hasReachedMax) {
              if (videos.isEmpty) {
                return const Center(child: Text('No videos found', style: TextStyle(color: Colors.white54)));
              }
              return ListView.builder(
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to FeedPage and jump to index
                      // For now, we'll use a simple approach: push a new FeedPage with initialIndex
                      context.push('/feed', extra: index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  VideoPlayerWidget(
                                    video: video,
                                    isPlaying: false, // Don't auto-play in list
                                  ),
                                  const Icon(Icons.play_circle_outline, color: Colors.white, size: 50),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video.caption,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite, color: Colors.red, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${video.likeCount}', style: const TextStyle(color: Colors.white70)),
                                    const SizedBox(width: 16),
                                    const Icon(Icons.visibility, color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Text('${video.viewCount}', style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
