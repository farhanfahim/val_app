// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/main_scaffold.dart';
import '../../view_model/accounts/help_support_view_model.dart';
import 'widgets/faq_widget.dart';
import 'widgets/send_query_widget.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final HelpSupportViewModel controller = HelpSupportViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Scaffold(
        body: Center(
          child: Consumer<HelpSupportViewModel>(
            builder: (context, controller, child) {
              return MainScaffold(
                appBar: CustomAppBar(
                  leading: true,
                  title: "Help & FAQ’s",
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      headerSection(controller),
                      SizedBox(height: 25),
                      controller.isFaq ? Expanded(child: FaqWidget()) : Expanded(child: SendQueryWidget()),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container headerSection(HelpSupportViewModel controller) {
    return Container(
      height: 44,
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(8, 9),
            blurRadius: 22,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.isFaq = true;
                controller.notifyListeners();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: controller.isFaq ? AppColors.green : null,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: CustomTextWidget(
                    text: "FAQ’s",
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: controller.isFaq ? AppColors.blackColor : AppColors.grey2,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                controller.isFaq = false;
                controller.notifyListeners();
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: controller.isFaq ? null : AppColors.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: CustomTextWidget(
                    text: "Send Query",
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: controller.isFaq ? AppColors.grey2 : AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
