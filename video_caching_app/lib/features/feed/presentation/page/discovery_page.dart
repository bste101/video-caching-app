import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/feed_bloc.dart';
import '../bloc/feed_event.dart';
import '../bloc/feed_state.dart';
import '../widgets/discovery_video_player.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  // Master switch to stop all videos when navigating away
  final ValueNotifier<bool> _isPageActive = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedBloc = context.read<FeedBloc>();
      feedBloc.state.maybeWhen(
        success: (videos, cursor, hasReachedMax) {
          if (videos.isEmpty) feedBloc.add(const FeedEvent.fetchFeedRequested());
        },
        orElse: () => feedBloc.add(const FeedEvent.fetchFeedRequested()),
      );
    });
  }

  @override
  void dispose() {
    _isPageActive.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Discovery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
            failure: (message) => Center(child: Text(message, style: const TextStyle(color: Colors.white))),
            success: (videos, cursor, hasReachedMax) {
              if (videos.isEmpty) {
                return const Center(child: Text('No videos found', style: TextStyle(color: Colors.white54)));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<FeedBloc>().add(const FeedEvent.fetchFeedRequested());
                },
                color: Colors.pinkAccent,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return GestureDetector(
                      key: ValueKey('discovery-${video.id}'),
                      onTap: () async {
                        // 1. IMMEDIATELY stop all grid videos to free decoders
                        _isPageActive.value = false;
                        
                        // 2. Navigate to feed
                        await context.push('/feed', extra: index);
                        
                        // 3. When coming back, re-enable playback
                        _isPageActive.value = true;
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isPageActive,
                        builder: (context, isActive, child) {
                          return DiscoveryVideoPlayer(
                            video: video,
                            isPageActive: isActive, // Pass the master switch
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator(color: Colors.pinkAccent)),
          );
        },
      ),
    );
  }
}
