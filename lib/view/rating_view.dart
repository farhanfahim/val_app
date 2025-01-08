import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/main_scaffold.dart';

import '../configs/components/custom_text_widget.dart';
import '../configs/components/start_rating.dart';
import '../configs/components/svg_icons_component.dart';

class RatingView extends StatelessWidget {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: CustomAppBar(
        leading: true,
        backButtonColor: AppColors.blackColor,
        title: "Rating",
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 14, left: 24, right: 24),
        child: Column(
          children: [
            SizedBox(height: 10),
            Divider(color: AppColors.grey2.withOpacity(.3)),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIconComponent(
                    icon: "star_yellow_icon.svg",
                    height: 27,
                    width: 27,
                  ),
                  SizedBox(width: 10),
                  CustomTextWidget(
                    text: "4.5",
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(width: 5),
                  CustomTextWidget(
                    text: "Avg.\nRating",
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  )
                ],
              ),
            ),
            SizedBox(height: 30),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: 5,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            lineHeight: 24,
                            // percent: 0.0,
                            percent: double.parse(index == 0 ? "100" : "60") / 100,
                            backgroundColor: AppColors.grey3.withOpacity(0.15),
                            barRadius: const Radius.circular(40),
                            progressColor: AppColors.primaryColor,
                            animation: true,
                            animationDuration: 1200,
                          ),
                        ),
                        
                        SizedBox(width: 11),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              StarRating(
                                rating: double.parse(index == 0 ? "5" : "3"),
                                width: 14,
                                height: 14,
                                spacer: 2,
                              ),
                              // StarRating(rating: 0),
                              SizedBox(width: 6),
                              CustomTextWidget(
                                text: index == 0 ? "100" : "60%",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
