import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';

import '../view_model/onboard_view_model.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardViewModel(),
      child: MainScaffold(
        backgroundColor: AppColors.primaryColor,
        body: Consumer<OnboardViewModel>(
          builder: (context, viewModel, child) {
            return Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView(
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: viewModel.onPageChanged,
                    controller: viewModel.pageController,
                    scrollDirection: Axis.vertical,
                    children: [
                      for (var i = 0; i < viewModel.titles.length; i++)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/Walkthrough 0${i + 1}.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 317,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(17),
                          topLeft: Radius.circular(17),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < 3; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                                  child: Container(
                                    height: 9,
                                    width: viewModel.selectedIndex == i ? 19 : 9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: viewModel.selectedIndex == i ? AppColors.primaryColor : AppColors.lightGrey2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomTextWidget(
                            text: viewModel.titles[viewModel.selectedIndex],
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                          SizedBox(height: 15),
                          CustomTextWidget(
                            text: viewModel.subtitles[viewModel.selectedIndex],
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey2,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => viewModel.nextPage(context),
                                  child: Container(
                                    height: 49,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    child: CustomTextWidget(
                                      text: 'Next',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                              if (viewModel.selectedIndex < 2) SizedBox(width: 10),
                              if (viewModel.selectedIndex < 2)
                                GestureDetector(
                                  onTap: () => viewModel.skip(context),
                                  child: Container(
                                    width: 85,
                                    height: 49,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(26),
                                    ),
                                    child: CustomTextWidget(
                                      text: 'Skip',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
