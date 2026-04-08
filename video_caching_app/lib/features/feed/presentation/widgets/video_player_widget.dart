import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/video_model.dart';
import 'dart:io';

class VideoPlayerWidget extends StatefulWidget {
  final VideoModel video;
  final bool isPlaying;

  const VideoPlayerWidget({
    super.key,
    required this.video,
    required this.isPlaying,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.video.videoUrl.isEmpty) {
      _initializeVideoPlayerFuture = Future.error('Empty video URL');
      return;
    }

    String finalUrl = widget.video.videoUrl;
    
    // Map localhost/minio to 10.0.2.2 for Android emulators
    if (Platform.isAndroid) {
      finalUrl = finalUrl.replaceAll('localhost', '10.0.2.2');
      finalUrl = finalUrl.replaceAll('minio', '10.0.2.2');
    }

    // If it's just a filename (fallback), prepend the emulator base URL
    if (!finalUrl.startsWith('http') && finalUrl.isNotEmpty) {
      finalUrl = "http://10.0.2.2:9000/videos/$finalUrl";
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(finalUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setLooping(true);
      if (widget.isPlaying) {
        _controller.play();
      }
      setState(() {});
    }).catchError((error) {
      print("Video initialization failed: $error for $finalUrl");
      throw error;
    });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.video.videoUrl.isEmpty) return;
    if (widget.isPlaying) {
      if (_controller.value.isInitialized) _controller.play();
    } else {
      if (_controller.value.isInitialized) _controller.pause();
    }
  }

  @override
  void dispose() {
    if (widget.video.videoUrl.isNotEmpty) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video.videoUrl.isEmpty) {
      return const Center(child: Icon(Icons.error, color: Colors.white54));
    }
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
          return Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Icon(Icons.error, color: Colors.red, size: 50),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
