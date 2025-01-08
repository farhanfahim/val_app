import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_text_widget.dart';
import '../../../configs/components/svg_icons_component.dart';
import '../../../configs/utils.dart';
import '../../../view_model/accounts/help_faq_view_model.dart';

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  final FaqViewModel controller = FaqViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getFAQ(context, isPullToRefresh: false);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<FaqViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            backgroundColor: AppColors.whiteColor,
            color: AppColors.primaryColor,
            onRefresh: () async {
              await controller.getFAQ(context, isPullToRefresh: true);
            },
            child: viewModel.isLoading
                ? const SizedBox.shrink()
                : viewModel.faqData.isEmpty
                    ? Utils.noDataFoundMessage("No data found.")
                    : ListView.separated(
                        // shrinkWrap: true,
                        itemCount: viewModel.faqData.length,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(top: 6, left: 18, right: 12, bottom: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: AppColors.whiteColor,
                              border: Border.all(color: AppColors.borderColor.withOpacity(.4), width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  offset: const Offset(8, 9),
                                  blurRadius: 22,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Theme(
                              data: ThemeData().copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                highlightColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                childrenPadding: EdgeInsets.zero,
                                tilePadding: EdgeInsets.zero,
                                trailing: viewModel.faqData[index].isExpand == true ? const SvgIconComponent(icon: "close_purple_circle.svg") : const SvgIconComponent(icon: "add_purple_circle2.svg"),
                                title: CustomTextWidget(
                                  text: viewModel.faqData[index].question ?? "",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                                onExpansionChanged: (expanded) {
                                  viewModel.toggleExpansion(index, expanded);
                                },
                                expandedAlignment: Alignment.centerLeft,
                                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    text: viewModel.faqData[index].answer ?? "",
                                    color: AppColors.blueLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 10)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
