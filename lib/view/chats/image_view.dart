import 'package:flutter/material.dart';
import 'package:val_app/view/chats/widgets/common_image_view.dart';
import '../../configs/color/colors.dart';


class ImageView extends StatelessWidget {

  final String? image;
  ImageView({this.image,super.key});

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
                  // Down Swipe
                  Navigator.pop(context);
                } else if (details.delta.dy < -sensitivity) {
                  // Up Swipe
                  Navigator.pop(context);
                }
              },
              child: Center(
                child: CommonImageView(
                  url: image,
                ),
              )
          ),
        )
    );
  }
}
