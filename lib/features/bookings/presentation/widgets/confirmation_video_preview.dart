import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:velmar_ads/core/theme/app_pallete.dart';
import 'package:velmar_ads/features/library/presentation/widgets/fullscreen_video_player.dart';

class ConfirmationVideoPreview extends StatefulWidget {
  final String videoUrl;

  const ConfirmationVideoPreview({
    super.key,
    required this.videoUrl,
  });

  @override
  State<ConfirmationVideoPreview> createState() => _ConfirmationVideoPreviewState();
}

class _ConfirmationVideoPreviewState extends State<ConfirmationVideoPreview> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller!.setVolume(0);
        _controller!.pause();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openFullscreen() {
    if (_controller == null || !_isInitialized) return;
    
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => FullscreenVideoPlayer(
          controller: _controller!,
        ),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: AppPallete.surfaceVariant,
        child: const Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: AppPallete.secondary,
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        color: AppPallete.surfaceVariant,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppPallete.primary),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _openFullscreen,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            ),
          ),
          Container(
            color: Colors.black.withValues(alpha: 0.15),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow,
              color: AppPallete.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
