// ignore: must_be_immutable
import 'package:flutter/material.dart';

import '../color/colors.dart';
import 'custom_text_widget.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Function()? onLeadingPress;
  String? title;
  Widget? trailing;
  bool leading;
  Color bgColor;
  Color? backButtonColor;
  Color? trailingColor;
  Color? titleColor;
  Color? backIconColor;
  bool centerTitle;
  double? elevation;
  Widget? leadingWidget;
  IconThemeData? iconThemeData;

  CustomAppBar({
    Key? key,
    this.title,
    this.elevation = 0,
    this.centerTitle = true,
    this.onLeadingPress,
    this.leading = false,
    this.backIconColor = AppColors.blackColor,
    this.bgColor = AppColors.blackColor,
    this.trailingColor,
    this.titleColor,
    this.trailing,
    this.leadingWidget,
    this.backButtonColor,
    this.iconThemeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      elevation: elevation,
      backgroundColor: bgColor,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      iconTheme: iconThemeData,
      title: title != null
          ? Padding(
              padding: EdgeInsets.only(
                left: leading == false ? 14 : 0,
                top: 10,
              ),
              child: CustomTextWidget(
                text: title.toString(),
                color: titleColor ?? AppColors.blackColor,
                textAlign: TextAlign.center,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          : leadingWidget,
      leading: leading == true
          ? Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 24,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: backIconColor,
                onPressed: onLeadingPress ??
                    () {
                      Navigator.pop(context);
                    },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: backButtonColor ?? AppColors.blackColor,
                  // colorScheme.background: backIconColor,
                ),
                // icon: SvgIconComponent(
                //   icon: "appbar_back_2x.svg",
                //   color: backButtonColor ?? AppColors.white,
                //   // colorScheme.background: backIconColor,
                // )
                // ImageIcon(
                //   Image.asset(
                //     AppColors.getIconImage("appbar_back_2x.svg"),
                //   ).image,
                //   color: backButtonColor ?? AppColors.white,
                //   size: 24,
                // ),
              ),
            )
          : null,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24, top: 10),
          child: trailing ?? const SizedBox.shrink(),
        ),
        // trailing == null
        // ? const SizedBox()
        // : IconButton(
        //     padding: const EdgeInsets.only(left: 0, bottom: 8),
        //     alignment: Alignment.centerLeft,
        //     onPressed: onTrailingPressed,
        //     color: AppColors.black,
        //     icon: SvgIconComponent(icon: trailing!, height: 22, width: 23,color: trailingColor ?? AppColors.black),)
      ],
    );
  }
}
