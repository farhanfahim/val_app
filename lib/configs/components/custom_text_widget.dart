import 'package:flutter/material.dart'; 
import '../color/colors.dart';

// ignore: must_be_immutable
class CustomTextWidget extends StatelessWidget {
  dynamic text;
  final Color color;
  final String? fontFamily;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign textAlign;
  final double lineHeight;
  final double letterSpacing;
  final TextOverflow overFlow;
  final TextDecoration? decoration;
  final int? maxLines;

  CustomTextWidget({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.color = AppColors.blackColor,
    this.fontFamily = "Manrope",
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.overFlow = TextOverflow.visible,
    this.letterSpacing = 0.10,
    this.lineHeight = 1.2,
    this.decoration = TextDecoration.none,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      textAlign: textAlign,
      maxLines: maxLines,
      style: TextStyle(
        decoration: decoration,
        height: lineHeight,
        letterSpacing: letterSpacing,
        overflow: overFlow,
        color: color,
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
