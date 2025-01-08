// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/routes/routes_name.dart';

import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_appbar.dart';
import '../../../configs/components/custom_button_widget.dart';
import '../../../configs/components/custom_text_widget.dart';
import '../../../configs/components/main_scaffold.dart';
import '../../../configs/components/svg_icons_component.dart';
import '../../../configs/utils.dart';
import '../../../view_model/accounts/setting_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingViewModel cnt = SettingViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getNotificationToggle(context);
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
      child: Consumer<SettingViewModel>(
        builder: (ctx, stController, child) {
          return MainScaffold(
            appBar: CustomAppBar(
              leading: true,
              title: "Settings",
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onTap: () {
                      deleteSheet(context, stController);
                    },
                    title: "Delete Account",
                    bgColor: Colors.transparent,
                    fontColor: AppColors.grey3,
                    borderColor: AppColors.grey3,
                    radius: 100,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            body: stController.isLoading
                ? SizedBox.shrink()
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12),
                          Column(
                            children: [
                              rowWidget(name: "Notifications", onTap: () {}, stController, isNotification: true),
                              Divider(color: AppColors.grey4.withOpacity(.3)),
                              rowWidget(name: "Change Password", onTap: () {
                                Navigator.pushNamed(context, RoutesName.changePassword);
                              }, stController),
                              Divider(color: AppColors.grey4.withOpacity(.3)),
                              rowWidget(name: "Privacy Policy", onTap: () {
                                Navigator.pushNamed(context, RoutesName.privacy);
                              }, stController),
                              Divider(color: AppColors.grey4.withOpacity(.3)),
                              rowWidget(name: "Terms & Conditions", onTap: () {
                                Navigator.pushNamed(context, RoutesName.terms);
                              }, stController),
                              Divider(color: AppColors.grey4.withOpacity(.3)),
                            ],
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget rowWidget(SettingViewModel controller, {String? name, void Function()? onTap, bool isNotification = false}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(text: name, fontSize: 16, fontWeight: FontWeight.w700),
            isNotification
                ? Consumer<SettingViewModel>(
                    builder: (context, controller, child) {
                      return FlutterSwitch(
                        activeColor: AppColors.green,
                        width: 40,
                        height: 25,
                        padding: 0.5,
                        valueFontSize: 12.0,
                        toggleSize: 23.0,
                        value: controller.enableNotification,
                        onToggle: (val) async {
                          await controller.notificationToggle(context);
                        },
                      );
                    },
                  )
                : const SvgIconComponent(icon: "right_purple.svg"),
          ],
        ),
      ),
    );
  }

  void deleteSheet(BuildContext context, SettingViewModel controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                text: "Are you sure you want to delete your account?",
                fontSize: 18,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 33),
              Row(
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    bgColor: Colors.transparent,
                    radius: 50,
                    title: "No",
                    height: 49,
                    borderColor: AppColors.grey3,
                    fontColor: AppColors.grey3,
                    width: 156,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 15),
                  CustomButton(
                    onTap: () {
                      controller.deleteAccount(context);
                    },
                    radius: 50,
                    bgColor: Colors.transparent,
                    title: "Yes",
                    borderColor: AppColors.primaryColor,
                    fontColor: AppColors.primaryColor,
                    height: 49,
                    width: 156,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
