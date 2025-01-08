// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/html_viewer.dart';
import 'package:val_app/view_model/accounts/privacy_view_model.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_appbar.dart';
import '../../../configs/components/custom_text_widget.dart';
import '../../../configs/components/main_scaffold.dart';
import '../../../configs/components/svg_icons_component.dart';
import '../../../configs/utils.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  final PrivacyViewModel cnt = PrivacyViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getPrivacy(context, isPullToRefresh: false);
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
      child: Consumer<PrivacyViewModel>(
        builder: (ctx, pController, child) {
          return MainScaffold(
            appBar: CustomAppBar(
              leading: true,
            ),
            body: pController.isLoading
                ? const SizedBox.shrink()
                : pController.privacyData?.data == null
                    ? Utils.noDataFoundMessage("No privacy found.")
                    : RefreshIndicator(
                        backgroundColor: AppColors.whiteColor,
                        color: AppColors.primaryColor,
                        onRefresh: () async {
                          await pController.getPrivacy(context, isPullToRefresh: true);
                        },
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SvgIconComponent(icon: "privacy.svg"),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: "Privacy Policy",
                                          fontSize: 24,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        SizedBox(height: 4),
                                        CustomTextWidget(
                                          text: "Update ${DateFormat('MMM dd, yyyy').format(DateTime.parse(pController.privacyData?.data?.createdOn ?? ""))}",
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.grey3,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                HtmlViewer(htmlContent: pController.privacyData?.data?.privacypolicy ?? ""),
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
