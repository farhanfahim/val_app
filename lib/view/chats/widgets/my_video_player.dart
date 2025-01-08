import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'flick_video_full_screen_controls.dart';

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    Key? key,
    required this.mediaUrl,
    this.onMediaTap,
    this.borderRadius = 20.0,
  }) : super(key: key);

  final String mediaUrl;
  final double borderRadius;
  final Function()? onMediaTap;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late FlickManager _flickManager;

  @override
  void initState() {

    _flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.mediaUrl),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: FlickVideoPlayer(
          flickManager: _flickManager,
          flickVideoWithControls: const FlickVideoWithControls(
            videoFit: BoxFit.fitWidth,
            controls: SafeArea(
              child: FlickPortraitControls(),
            ),
          ),
          flickVideoWithControlsFullscreen: const FlickVideoFullScreenControls(),
          preferredDeviceOrientationFullscreen: const [
            DeviceOrientation.portraitUp,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        ));
  }

  @override
  void dispose() {
    _flickManager.dispose();
    super.dispose();
  }
}
