// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/view_model/accounts/terms_view_model.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_appbar.dart';
import '../../../configs/components/html_viewer.dart';
import '../../../configs/components/main_scaffold.dart';
import '../../../configs/utils.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  final TermsViewModel cnt = TermsViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getTerms(context, isPullToRefresh: false);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cnt,
      child: Consumer<TermsViewModel>(
        builder: (ctx, tController, child) {
          return MainScaffold(
            appBar: CustomAppBar(
              leading: true,
            ),
            body: tController.isLoading
                ? const SizedBox.shrink()
                : tController.termsData?.data == null
                    ? Utils.noDataFoundMessage("No terms found.")
                    : RefreshIndicator(
                        backgroundColor: AppColors.whiteColor,
                        color: AppColors.primaryColor,
                        onRefresh: () async {
                          await tController.getTerms(context, isPullToRefresh: true);
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SvgIconComponent(icon: "terms.svg"),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: "Terms & Conditions",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        SizedBox(height: 4),
                                        CustomTextWidget(
                                          text: "Update ${DateFormat('MMM dd, yyyy').format(DateTime.parse(tController.termsData?.data?.createdOn ?? ""))}",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey3,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                HtmlViewer(htmlContent: tController.termsData?.data?.text ?? ""),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ),
          );
        },
      ),
    );
  }
}
