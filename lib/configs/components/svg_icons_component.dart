// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:val_app/configs/utils.dart';

class SvgIconComponent extends StatelessWidget {
  final String icon;
  final double? width;
  final double? height;
  final Function()? onTap;
  final Color? color;
  const SvgIconComponent({Key? key, required this.icon, this.width, this.height, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        Utils.getIconImage(icon),
        height: height,
        width: width,
        color: color,
      ),
    );
  }
}
