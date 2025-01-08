import 'package:flutter/material.dart';

import 'svg_icons_component.dart';

class CircularIconButton extends StatelessWidget {
  final String img;
  final Function()? onTap;
  const CircularIconButton({super.key, this.img = "", required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        height: 37,
        width: 37,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3), shape: BoxShape.circle),
        child: SvgIconComponent(
          icon: img,
          height: 18,
          width: 18,
        ),
      ),
    );
  }
}
