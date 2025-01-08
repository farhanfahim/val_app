// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:val_app/configs/utils.dart';
import '../color/colors.dart';
import 'custom_text_widget.dart';

class CategoryComponent extends StatelessWidget {
  Function()? onTap;
  String img;
  String title;
  CategoryComponent({super.key, required this.onTap, this.title = "", this.img = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              padding: title == "View All" ? EdgeInsets.all(14) : EdgeInsets.zero,
              decoration: BoxDecoration(color: AppColors.whiteColor, boxShadow: [BoxShadow(color: AppColors.purpleShadowColor.withOpacity(0.08), blurRadius: 7, offset: Offset(0, 8))], borderRadius: BorderRadius.circular(12)),
              child: title != "View All"
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Utils().customCachedNetworkImage(
                        shape: BoxShape.rectangle,
                        url: img,
                        height: 60,
                        width: 60,
                      ))
                  : ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(Utils.getIconImage(img))),
            ),
            const SizedBox(
              height: 14,
            ),
            CustomTextWidget(
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
