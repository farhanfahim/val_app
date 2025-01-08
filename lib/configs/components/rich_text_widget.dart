// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:val_app/configs/color/colors.dart';

// ignore: must_be_immutable
class RichTextWidget extends StatelessWidget {
  String? text;
  String? centerText;
  String? onTapText;
  Color color;
  Color? centerColor;
  Color onTapColor;
  double textFontSize;
  double? centerFontSize;
  double onTapFontSize;
  FontWeight textFontWeight;
  FontWeight? centerFontWeight;
  FontWeight onTapFontWeight;
  TextDecoration? decoration;
  TextDecoration? centerDecoration;
  void Function()? onTap;
  double? height;
  RichTextWidget({
    Key? key,
    this.text,
    this.centerText,
    this.onTapText,
    this.color = AppColors.blackColor,
    this.centerColor = AppColors.blackColor,
    this.onTapColor = AppColors.blackColor,
    this.textFontSize = 14,
    this.centerFontSize = 14,
    this.onTapFontSize = 14,
    this.textFontWeight = FontWeight.normal,
    this.centerFontWeight = FontWeight.normal,
    this.onTapFontWeight = FontWeight.normal,
    this.decoration = TextDecoration.none,
    this.centerDecoration = TextDecoration.none,
    this.onTap,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: color,
              fontSize: textFontSize,
              height: height,
              fontFamily: "Manrope",
              fontWeight: textFontWeight,
            ),
          ),
          TextSpan(
            text: centerText ?? "",
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: centerColor,
              fontSize: centerFontSize,
              fontFamily: "Manrope",
              decoration: centerDecoration,
              fontWeight: textFontWeight,
            ),
          ),
          TextSpan(
            text: onTapText.toString(),
            style: TextStyle(
              color: onTapColor,
              fontSize: onTapFontSize,
              fontFamily: "Manrope",
              fontWeight: onTapFontWeight,
              decoration: decoration,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
