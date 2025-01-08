// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'svg_icons_component.dart';

class StarRating extends StatelessWidget {
  final double? rating;
  final int maxRating;
  double? width;
  double? height;
  double? spacer;
  String? iconOne;
  String? iconTwo;
  StarRating({
    Key? key,
    required this.rating,
    this.maxRating = 5,
    this.width,
    this.height,
    this.spacer,
    this.iconOne,
    this.iconTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxRating,
        (index) {
          return Row(
            children: [
              SvgIconComponent(icon: index < rating! ? iconOne ?? "star_yellow_icon.svg" : iconTwo ?? "star_grey_icon2.svg", width: width ?? 15, height: height ?? 15),
              SizedBox(width: spacer ?? 5),
            ],
          );
        },
      ),
    );
  }
}
