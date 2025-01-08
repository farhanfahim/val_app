import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../model/chats_list_model.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage? message;

  ChatMessageWidget({required this.message});

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.message?.chatMedia != null) {
      _videoController = VideoPlayerController.file(File(widget.message!.chatMedia!.filePath!))
        ..initialize().then((_) {
          setState(() {});
        });

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        fullScreenByDefault: true,
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message?.chatMedia != null) {
      final mediaPath = widget.message!.chatMedia!.filePath;

      return Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Check if the media is an image
          image: mediaPath != null && mediaPath.isNotEmpty && (mediaPath.endsWith('.jpg') || mediaPath.endsWith('.png'))
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: FileImage(File(mediaPath)),
                )
              : null, // No decoration if not an image
        ),
        child: mediaPath != null && mediaPath.isNotEmpty && (mediaPath.endsWith('.mp4') || mediaPath.endsWith('.mov'))
            // Check if the media is a video
            ? GestureDetector(
                onTap: () {
                  if (_chewieController != null && _videoController!.value.isInitialized) {
                    _chewieController!.play();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _videoController != null && _videoController!.value.isInitialized ? Chewie(controller: _chewieController!) : CircularProgressIndicator(),
                    Icon(
                      Icons.play_circle_outline,
                      size: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(), // Show nothing if it's not a video
      );
    } else {
      return SizedBox.shrink(); // No media available
    }
  }
}
