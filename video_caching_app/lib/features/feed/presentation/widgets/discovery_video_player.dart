import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/video_model.dart';
import 'dart:io';

class DiscoveryVideoPlayer extends StatefulWidget {
  final VideoModel video;
  final bool isPageActive; // New: master switch

  const DiscoveryVideoPlayer({
    super.key,
    required this.video,
    required this.isPageActive,
  });

  @override
  State<DiscoveryVideoPlayer> createState() => _DiscoveryVideoPlayerState();
}

class _DiscoveryVideoPlayerState extends State<DiscoveryVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isVisible = false;

  @override
  void didUpdateWidget(DiscoveryVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If page becomes inactive, kill the controller IMMEDIATELY
    if (!widget.isPageActive && oldWidget.isPageActive) {
      _disposeController();
      if (mounted) setState(() {});
    } 
    // If page becomes active again and we are visible, re-init
    else if (widget.isPageActive && !oldWidget.isPageActive) {
      if (_isVisible) _initializeController();
    }
    
    if (oldWidget.video.videoUrl != widget.video.videoUrl) {
      _disposeController();
      if (_isVisible && widget.isPageActive) _initializeController();
    }
  }

  Future<void> _initializeController() async {
    if (_controller != null || widget.video.videoUrl.isEmpty || !widget.isPageActive) return;

    String finalUrl = widget.video.videoUrl;
    if (Platform.isAndroid) {
      finalUrl = finalUrl.replaceAll('localhost', '10.0.2.2').replaceAll('minio', '10.0.2.2');
    }
    if (!finalUrl.startsWith('http') && finalUrl.isNotEmpty) {
      finalUrl = "http://10.0.2.2:9000/videos/$finalUrl";
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(finalUrl));
    _controller = controller;

    try {
      await controller.initialize();
      if (mounted && _controller == controller && widget.isPageActive) {
        setState(() {
          _isInitialized = true;
          _controller?.setLooping(true);
          _controller?.setVolume(0);
          if (_isVisible) _controller?.play();
        });
      } else {
        // If no longer active by the time it initialized, dispose it
        controller.dispose();
      }
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  void _disposeController() {
    if (_controller == null) return;
    
    final oldController = _controller;
    _controller = null; 
    _isInitialized = false;
    
    // Immediate synchronous disposal
    oldController?.pause();
    oldController?.dispose();
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video-${widget.video.id}'),
      onVisibilityChanged: (visibilityInfo) {
        if (!mounted) return;
        final visiblePercentage = visibilityInfo.visibleFraction * 100;
        
        if (visiblePercentage > 10 && widget.isPageActive) {
          _isVisible = true;
          if (_controller == null) {
            _initializeController();
          } else if (visiblePercentage > 50) {
            if (_isInitialized) _controller?.play();
          } else {
            _controller?.pause();
          }
        } else {
          _isVisible = false;
          _disposeController();
          if (mounted) setState(() {});
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: (_isInitialized && widget.isPageActive && _controller != null)
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.caption,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.white54, size: 14),
                      const SizedBox(width: 4),
                      Text('${widget.video.likeCount}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
