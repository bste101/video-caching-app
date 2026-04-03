import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:go_router/go_router.dart";
import "package:video_caching_app/features/auth/presentation/bloc/auth_bloc.dart";
import "package:video_caching_app/features/auth/presentation/bloc/auth_event.dart";
import "package:video_caching_app/features/auth/presentation/bloc/auth_state.dart";
import "../bloc/feed_bloc.dart";
import "../bloc/feed_event.dart";
import "../bloc/feed_state.dart";
import "../widgets/video_player_widget.dart";
import "../../data/models/video_model.dart";

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _currentIndex = 0;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(const FeedEvent.fetchFeedRequested());
  }

  Future<void> _pickAndUploadVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      if (!mounted) return;
      context.read<FeedBloc>().add(FeedEvent.uploadVideoRequested(video.path));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Uploading video...")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () => context.go("/login"),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (message) => Center(child: Text(message)),
              success: (videos, cursor, hasReachedMax) {
                if (videos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTopBar(context),
                        const Icon(Icons.video_library, color: Colors.white54, size: 80),
                        const SizedBox(height: 20),
                        const Text("No videos found", style: TextStyle(color: Colors.white54, fontSize: 18)),
                      ],
                    ),
                  );
                }
                return PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: videos.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    context.read<FeedBloc>().add(FeedEvent.viewAdded(videos[index].id));
                    if (index >= videos.length - 2) {
                      context.read<FeedBloc>().add(const FeedEvent.fetchMoreFeedRequested());
                    }
                  },
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return Stack(
                      children: [
                        VideoPlayerWidget(
                          video: video,
                          isPlaying: index == _currentIndex,
                        ),
                        _buildSidebar(context, video),
                        _buildBottomInfo(video),
                        _buildTopBar(context),
                      ],
                    );
                  },
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _pickAndUploadVideo,
          backgroundColor: Colors.pinkAccent,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      top: 40,
      right: 15,
      child: IconButton(
        icon: const Icon(Icons.logout, color: Colors.white, size: 30),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
                    Navigator.pop(context);
                  },
                  child: const Text("Logout", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, VideoModel video) {
    return Positioned(
      right: 15,
      bottom: 100,
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              video.isLiked ? Icons.favorite : Icons.favorite_border,
              color: video.isLiked ? Colors.red : Colors.white,
              size: 35,
            ),
            onPressed: () {
              context.read<FeedBloc>().add(FeedEvent.toggleLikeRequested(video.id));
            },
          ),
          Text("${video.likeCount}", style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          const Icon(Icons.comment, color: Colors.white, size: 35),
          const Text("0", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 20),
          const Icon(Icons.share, color: Colors.white, size: 35),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(VideoModel video) {
    return Positioned(
      left: 15,
      bottom: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "@user_${video.userId.length > 8 ? video.userId.substring(0, 8) : video.userId}",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(video.caption, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
