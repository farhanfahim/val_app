import 'package:flutter/material.dart';
import '../color/colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  void Function()? onTap;
  String? title;
  double? fontSize;
  double radius;
  double? height;
  double? width;
  FontWeight? fontWeight;
  Color? fontColor;
  Color? bgColor;
  Widget? icon;
  Widget? iconRight;
  bool isIcon;
  bool isIconRight;
  Gradient? gradient;
  Color? borderColor;
  double? borderWidth;
  TextDecoration? decoration;
  EdgeInsetsGeometry? padding;
  CustomButton({
    super.key,
    this.onTap,
    this.title,
    this.borderColor,
    this.borderWidth,
    this.fontSize = 16,
    this.radius = 9,
    this.height = 48.75,
    this.width = 375,
    this.fontWeight = FontWeight.normal,
    this.fontColor = AppColors.whiteColor,
    this.bgColor = AppColors.blackColor,
    this.icon,
    this.gradient,
    this.isIcon = false,
    this.isIconRight = false,
    this.iconRight,
    this.padding,
    this.decoration = TextDecoration.none,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: padding,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: bgColor,
          border: borderColor != null ? Border.all(width: borderWidth ?? 1, color: borderColor!) : null,
          gradient: gradient,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: isIconRight == true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              // icon ?? const SizedBox(),
              // isIcon ? const SizedBox(width: 13.19) : const SizedBox(),
              Text(
                title.toString(),
                style: TextStyle(
                  fontFamily: "Manrope",
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: fontColor,
                  decoration: decoration,
                  decorationColor: AppColors.blackColor,
                ),
              ),
              isIconRight ? const SizedBox(width: 6) : const SizedBox(),
              iconRight ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
