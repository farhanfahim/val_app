// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/home_view_model.dart';
import '../app_urls.dart';
import 'circular_icon_button.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';
import 'svg_icons_component.dart';

class PostComponent extends StatelessWidget {
  Widget? posts;
  final String caption;
  final String profileName;
  final String profileImage;
  final Function()? onProjectDetail;
  final Function()? onFollow;
  final Function()? onLike;
  final Function()? onSave;
  final Function()? onRate;
  final Function()? viewLiked;
  final Function()? onTapUserProfile;
  final bool? isLike;
  final bool? isSave;
  final bool? isFollow;
  final String likecount;
  final String commentCount;
  final String viewCount;
  final String postedDateTime;
  final String location;
  bool isMyPostDetail = false;
  PostComponent({
    super.key,
    required this.isMyPostDetail,
    this.caption = "",
    this.location = "",
    this.profileName = "",
    this.profileImage = "",
    this.onFollow,
    this.onLike,
    this.onSave,
    this.onRate,
    this.onProjectDetail,
    this.isLike = false,
    this.isSave = false,
    this.isFollow = false,
    this.posts,
    this.viewLiked,
    this.onTapUserProfile,
    this.likecount = "",
    this.commentCount = "",
    this.viewCount = "",
    this.postedDateTime = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProjectDetail,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                  child: posts,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircularIconButton(onTap: () async {
                        final result = await Share.share('${AppUrl.baseUrl}/44');

                        if (result.status == ShareResultStatus.success) {
                          print('Thank you for sharing my website!');
                        }
                      }, img: "forward_icon.svg"),
                      const SizedBox(width: 11),
                      // CircularIconButton(onTap: onRate, img: "star_icon.svg"),
                      // const SizedBox(width: 11),
                      CircularIconButton(onTap: onSave, img: isSave == true ? "saved_white_icon.svg" : "save_white_icon.svg"),
                      const SizedBox(width: 11),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 11),
            Padding(
              padding: EdgeInsets.only(left: 18, right: 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgIconComponent(icon: isLike == false ? "like_icon.svg" : "liked_icon.svg", onTap: onLike),
                      const SizedBox(width: 9),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: viewLiked,
                        child: CustomTextWidget(text: likecount, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(width: 24),
                      SvgIconComponent(icon: "msg_icon.svg"),
                      const SizedBox(width: 8),
                      CustomTextWidget(text: commentCount, fontWeight: FontWeight.w600, fontSize: 12),
                      const SizedBox(width: 24),
                      SvgIconComponent(icon: "eye_dark.svg"),
                      const SizedBox(width: 8),
                      CustomTextWidget(text: viewCount, color: AppColors.blackColor, fontSize: 12, fontWeight: FontWeight.w600)
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(text: caption, fontSize: 18, fontWeight: FontWeight.w700),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    text: postedDateTime,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey2,
                  ),
                  const SizedBox(height: 9),
                  Divider(thickness: 1, color: AppColors.grey),
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapUserProfile,
                        child:
                      Utils().customCachedNetworkImage(height: 40, width: 40, shape: BoxShape.circle, url: profileImage)
                        
                         ,),
                      const SizedBox(width: 10),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onTapUserProfile,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              text: profileName,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            CustomTextWidget(
                              text: location, //"Oakland, United States",
                              color: AppColors.grey2,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      Consumer<HomeViewModel>(
                        builder: (context, value, child) {
                          return CustomButton(
                            onTap: onFollow,
                            height: 30,
                            width: 82,
                            radius: 26,
                            title: isFollow == true ? "Following" : "Follow",
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            fontColor: isFollow == true ? AppColors.whiteColor : AppColors.purple2,
                            borderColor: AppColors.purple2,
                            bgColor: isFollow == true ? AppColors.primaryColor : AppColors.whiteColor,
                          );
                        },
                      )
                      // Consumer<User>(
                      //   builder: (context, value, child) {
                      //     return CustomButton(
                      //       onTap: onFollow,
                      //       height: 30,
                      //       width: 82,
                      //       radius: 26,
                      //       title: isFollow == true ? "Following" : "Follow",
                      //       fontWeight: FontWeight.w700,
                      //       fontSize: 12,
                      //       fontColor: isFollow == true ? AppColors.whiteColor : AppColors.purple2,
                      //       borderColor: AppColors.purple2,
                      //       bgColor: isFollow == true ? AppColors.primaryColor : AppColors.whiteColor,
                      //     );
                      //   },
                      // )
                    ],
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
