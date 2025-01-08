import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class FlickVideoFullScreenControls extends StatelessWidget {
  const FlickVideoFullScreenControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlickVideoWithControls(
      videoFit: BoxFit.fitWidth,
      controls: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: const SafeArea(
          child: FlickPortraitControls(
            iconSize: 25,
          ),
        ),
      ),
    );
  }
}
