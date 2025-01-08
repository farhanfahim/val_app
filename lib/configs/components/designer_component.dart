// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/home_view_model.dart';
import '../color/colors.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';

class DesignerComponent extends StatelessWidget {
  String img;
  String profileName;
  String location;
  String reviewCount;
  String projectViews;
  String followCount;
  bool isFollowed;
  bool isSaved;
  Function()? onFollow;
  Function()? onProfile;
  Function()? onSave;
  DesignerComponent({
    super.key,
    this.img = "",
    this.onSave,
    this.location = "",
    this.reviewCount = "",
    this.projectViews = "",
    this.followCount = "",
    this.isFollowed = false,
    this.profileName = "",
    this.onFollow,
    this.onProfile,
    this.isSaved = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onProfile,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 17),
        width: 300,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Utils().customCachedNetworkImage(shape: BoxShape.circle, height: 40, width: 40, url: img),
                // CircleAvatar(
                //   radius: 23,
                //   backgroundImage:
                //   AssetImage(Utils.getCommonImage(img)),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        text: profileName, //"Carter Levin",
                        fontSize: 14,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(height: 3),
                      CustomTextWidget(
                        text: location, //"California, United States",
                        color: AppColors.grey2,
                        maxLines: 1,
                        overFlow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                IconButton(onPressed: onSave, icon: SvgIconComponent(icon: isSaved ? "saved_purple_filled.svg" : "saved_purple_outline.svg"))
                // GestureDetector(
                //     behavior: HitTestBehavior.opaque,
                //     onTap: () => onSave,
                //     child: SvgIconComponent(icon: isSaved ? "saved_purple_filled.svg" : "saved_purple_outline.svg"))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Consumer<HomeViewModel>(builder: (context, provider, child) {
              return CustomButton(
                onTap: onFollow,
                height: 30,
                radius: 26,
                title: isFollowed ? "Following" : "Follow",
                fontWeight: FontWeight.w600,
                fontSize: 12,
                fontColor: isFollowed ? AppColors.whiteColor : AppColors.purple2,
                borderColor: AppColors.purple2,
                bgColor: isFollowed ? AppColors.purple2 : AppColors.whiteColor,
              );
            }),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CustomTextWidget(
                        text: reviewCount, // "1.3K",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextWidget(
                        text: "Reviews",
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey2,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 19,
                  ),
                  Container(height: 41, width: 0.5, color: AppColors.grey2),
                  const SizedBox(width: 19),
                  Column(
                    children: [
                      CustomTextWidget(text: projectViews, fontSize: 14, fontWeight: FontWeight.w700),
                      const SizedBox(height: 4),
                      CustomTextWidget(text: "Project Views", fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.grey2),
                    ],
                  ),
                  const SizedBox(width: 19),
                  Container(height: 41, width: 0.5, color: AppColors.grey2),
                  const SizedBox(width: 13),
                  Column(
                    children: [
                      CustomTextWidget(
                        text: followCount, //"5.5K",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomTextWidget(
                        text: "Followers",
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
