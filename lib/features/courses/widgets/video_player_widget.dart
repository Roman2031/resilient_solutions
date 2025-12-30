import 'package:flutter/material.dart';

/// Video Player Widget Placeholder
/// This is a placeholder for the video player functionality
/// TODO: Integrate actual video_player package for full functionality
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Function(Duration)? onProgressUpdate;
  final Function()? onComplete;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.onProgressUpdate,
    this.onComplete,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlaying = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Placeholder video content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPlaying ? Icons.pause_circle : Icons.play_circle,
                size: 64,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(height: 12),
              Text(
                'Video Player',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  widget.videoUrl,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // Play/Pause button overlay
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _togglePlayPause,
                child: Container(),
              ),
            ),
          ),

          // Progress bar at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(Duration(seconds: (_progress * 300).toInt())),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDuration(const Duration(seconds: 300)),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: _progress,
                  onChanged: (value) {
                    setState(() {
                      _progress = value;
                    });
                    widget.onProgressUpdate
                        ?.call(Duration(seconds: (value * 300).toInt()));
                  },
                  activeColor: Theme.of(context).primaryColor,
                  inactiveColor: Colors.white.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    // Simulate video playback
    if (_isPlaying) {
      _simulatePlayback();
    }
  }

  void _simulatePlayback() async {
    while (_isPlaying && _progress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted && _isPlaying) {
        setState(() {
          _progress += 0.001;
          if (_progress >= 1.0) {
            _progress = 1.0;
            _isPlaying = false;
            widget.onComplete?.call();
          }
        });
        widget.onProgressUpdate?.call(Duration(seconds: (_progress * 300).toInt()));
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}

/// TODO: Integrate actual video_player package
/// 
/// To integrate the real video player:
/// 
/// 1. Add dependency in pubspec.yaml:
///    video_player: ^2.9.2
/// 
/// 2. Import the package:
///    import 'package:video_player/video_player.dart';
/// 
/// 3. Replace placeholder with actual implementation:
/// 
/// class VideoPlayerWidget extends StatefulWidget {
///   final String videoUrl;
///   
///   @override
///   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
/// }
/// 
/// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
///   late VideoPlayerController _controller;
///   
///   @override
///   void initState() {
///     super.initState();
///     _controller = VideoPlayerController.network(widget.videoUrl)
///       ..initialize().then((_) {
///         setState(() {});
///       });
///     
///     _controller.addListener(() {
///       if (_controller.value.position >= _controller.value.duration * 0.9) {
///         widget.onComplete?.call();
///       }
///     });
///   }
///   
///   @override
///   void dispose() {
///     _controller.dispose();
///     super.dispose();
///   }
///   
///   @override
///   Widget build(BuildContext context) {
///     return AspectRatio(
///       aspectRatio: _controller.value.aspectRatio,
///       child: Stack(
///         alignment: Alignment.bottomCenter,
///         children: [
///           VideoPlayer(_controller),
///           VideoProgressIndicator(_controller, allowScrubbing: true),
///           _ControlsOverlay(controller: _controller),
///         ],
///       ),
///     );
///   }
/// }
