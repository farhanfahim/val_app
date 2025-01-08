import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:val_app/view/chats/widgets/my_video_player.dart';

import '../../configs/color/colors.dart';

class VideoView extends StatelessWidget {
  final String? video;
  VideoView({this.video,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
              scrolledUnderElevation:0,
              backgroundColor: Colors.black,
              clipBehavior: Clip.none,
              leadingWidth: MediaQuery.sizeOf(context).width*0.25,

              leading:Padding(
                padding: const EdgeInsets.only(left: 8.0,top: 2.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.whiteColor ,
                  ),
                ),
              )
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              int sensitivity = 15;
              if (details.delta.dy > sensitivity) {
                Navigator.pop(context);
              } else if (details.delta.dy < -sensitivity) {
                Navigator.pop(context);
              }
            },
            child:  MyVideoPlayer(mediaUrl: video!),
          ),
        )
    );
  }
}
