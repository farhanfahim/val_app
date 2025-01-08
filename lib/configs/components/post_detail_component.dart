// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/utils.dart';

import 'custom_button_widget.dart';
import 'custom_text_widget.dart';
import 'svg_icons_component.dart';

class PostDetailComponent extends StatelessWidget {
  Widget? posts;
  final String caption;
  final String profileName;
  final String profileImage;
  final String description;
  final String location;
  final String rating;
  final String occupation;
  final String likeCount;
  final String commentCount;
  final String viewCount;
  Widget? tools;
  Widget? tags;
  Widget? category;
  bool showContent;
  bool isFollow;
  final String publish;
  final Function()? onProjectDetail;
  final Function()? onFollow;
  final Function()? onLike;
  final Function()? onSave;
  final Function()? onRate;
  void Function()? onTapShow;
  void Function()? onTapHide;
  void Function()? ratingOnTap;
  final bool? isLike;
  final bool? isSave;
  final bool? isMyPost;
  void Function()? onTapUserProfile;

  PostDetailComponent({
    Key? key,
    this.posts,
    this.occupation = "",
    this.caption = "",
    this.profileName = "",
    this.profileImage = "",
    this.description = "",
    this.location = "",
    this.tools,
    this.tags,
    this.category,
    this.showContent = false,
    this.isFollow = false,
    this.publish = "",
    this.onProjectDetail,
    this.onFollow,
    this.onLike,
    this.onSave,
    this.onRate,
    this.onTapShow,
    this.onTapHide,
    this.isLike = false,
    this.isSave = false,
    this.isMyPost = false,
    this.rating = '',
    this.ratingOnTap,
    this.onTapUserProfile,
    this.likeCount = '',
    this.commentCount = '',
    this.viewCount = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProjectDetail,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
        ),
        child: Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTapUserProfile, child: Utils().customCachedNetworkImage(width: 50, height: 50, shape: BoxShape.circle, url: profileImage)
                      //  CircleAvatar(
                      //   radius: 23,
                      //   backgroundImage: AssetImage(Utils.getCommonImage(profileImage)),
                      // ),
                      ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: profileName,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 3),
                      CustomTextWidget(
                        text: occupation,
                        color: AppColors.grey2,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgIconComponent(icon: "pin.svg"),
                          const SizedBox(width: 4),
                          CustomTextWidget(
                            text: location,
                            color: AppColors.grey2,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  isMyPost == true
                      ? SizedBox.shrink()
                      : CustomButton(
                          onTap: onFollow,
                          height: 30,
                          width: 82,
                          radius: 26,
                          title: isFollow ? "Following" : "Follow",
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          fontColor: isFollow ? AppColors.whiteColor : AppColors.purple2,
                          borderColor: AppColors.purple2,
                          bgColor: isFollow ? AppColors.purple2 : AppColors.whiteColor,
                        ),
                ],
              ),
            ),
            SizedBox(height: 9),
            Container(child: posts),
            const SizedBox(height: 11),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgIconComponent(icon: isLike == false ? "like_icon.svg" : "liked_icon.svg", onTap: onLike),
                      const SizedBox(width: 9),
                      CustomTextWidget(text: likeCount, fontWeight: FontWeight.w600, fontSize: 12),
                      const SizedBox(width: 24),
                      SvgIconComponent(icon: "msg_icon.svg"),
                      const SizedBox(width: 8),
                      CustomTextWidget(text: commentCount, fontWeight: FontWeight.w600, fontSize: 12),
                      const SizedBox(width: 24),
                      SvgIconComponent(icon: "eye_dark.svg"),
                      const SizedBox(width: 8),
                      CustomTextWidget(text: viewCount, color: AppColors.blackColor, fontSize: 12, fontWeight: FontWeight.w600),
                      Spacer(),
                      rating.isEmpty
                          ? SizedBox.shrink()
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: ratingOnTap,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.blackColor.withOpacity(.6),
                                ),
                                child: Row(
                                  children: [
                                    SvgIconComponent(
                                      icon: "star_yellow_icon.svg",
                                      height: 11,
                                      width: 11,
                                    ),
                                    SizedBox(width: 3.5),
                                    CustomTextWidget(
                                      text: rating,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                            )
                    ],
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(text: caption, fontSize: 18, fontWeight: FontWeight.w700),
                  const SizedBox(height: 8),
                  CustomTextWidget(text: "Published: $publish", fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey3),
                  const SizedBox(height: 9),
                  showContent == false
                      ? SizedBox.shrink()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(thickness: 1, color: AppColors.grey),
                            const SizedBox(height: 10),
                            CustomTextWidget(
                              text: description,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey3,
                            ),
                            const SizedBox(height: 9),
                            Divider(thickness: 1, color: AppColors.grey),
                            const SizedBox(height: 10),
                            CustomTextWidget(text: "Tools", fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.blackColor),
                            const SizedBox(height: 13),
                            SizedBox(
                              child: tools,
                            ),
                            const SizedBox(height: 9),
                            Divider(thickness: 1, color: AppColors.grey),
                            const SizedBox(height: 10),
                            CustomTextWidget(text: "Tags", fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.blackColor),
                            const SizedBox(height: 13),
                            SizedBox(
                              child: tags,
                            ),
                            const SizedBox(height: 9),
                            Divider(thickness: 1, color: AppColors.grey),
                            const SizedBox(height: 10),
                            CustomTextWidget(text: "Categories", fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.blackColor),
                            const SizedBox(height: 13),
                            SizedBox(
                              child: category,
                            ),
                            const SizedBox(height: 13),
                          ],
                        ),
                ],
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: showContent == false ? onTapShow : onTapHide,
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                showContent == false
                    ? Positioned(
                        top: 15,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onTapShow,
                          child: Column(
                            children: [
                              Center(
                                child: CustomTextWidget(
                                  text: "More Info",
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgIconComponent(icon: "arrow_down.svg"),
                            ],
                          ),
                        ),
                      )
                    : Positioned(
                        top: 15,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: onTapHide,
                          child: Column(
                            children: [
                              Center(
                                child: CustomTextWidget(
                                  text: "Close Info",
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgIconComponent(icon: "arrow_up.svg"),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
