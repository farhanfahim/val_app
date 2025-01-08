// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/utils.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_appbar.dart';
import '../../../configs/components/custom_button_widget.dart';
import '../../../configs/components/custom_text_field.dart';
import '../../../configs/components/main_scaffold.dart';
import '../../../configs/components/svg_icons_component.dart'; 
import '../../../view_model/accounts/change_password_view_model.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final ChangePasswordViewModel cnt = ChangePasswordViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
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
      child: Consumer<ChangePasswordViewModel>(
        builder: (ctx, cpController, child) {
          return MainScaffold(
            appBar: CustomAppBar(
              leading: true,
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    onTap: () {
                      if (cpController.changePasswordFormKey.currentState!.validate()) {
                        cpController.changePassword(context);
                      }
                    },
                    title: "Change Password",
                    bgColor: Colors.transparent,
                    fontColor: AppColors.primaryColor,
                    borderColor: AppColors.primaryColor,
                    radius: 100,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
                child: Form(
                  key: cpController.changePasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12),
                      Image.asset(
                        Utils.getIconImage("security.png"),
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(height: 20),
                      CustomTextWidget(
                        text: "Change Password",
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      SizedBox(height: 8),
                      // CustomTextWidget(
                      //   text: "Lorem ipsum dolor sit amet consectetur pharetra nec nulla.",
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.w500,
                      //   color: AppColors.hintColor,
                      //   textAlign: TextAlign.center,
                      // ),
                      SizedBox(height: 72),
                      CustomTextField(
                        obscure: cpController.isPasswordVisible,
                        padding: 12,
                        enableBorderColor: Colors.transparent,
                        maxLines: 1,
                        prefixIcon: SvgIconComponent(
                          icon: "lock_icon.svg",
                          color: cpController.focusPassword.hasFocus ? AppColors.primaryColor : null,
                        ),
                        cursorColor: AppColors.primaryColor,
                        fillColor: cpController.focusPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                        focusColor: AppColors.primaryColor,
                        hint: "Current Password",
                        suffixIcon: GestureDetector(
                            onTap: () {
                              cpController.isPasswordVisible = !cpController.isPasswordVisible;
                              cpController.notifyListeners();
                            },
                            child: cpController.isPasswordVisible == true
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black.withOpacity(0.4),
                                  )
                                : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                        hintFontSize: 14,
                        textInputType: TextInputType.visiblePassword,
                        txtController: cpController.passwordTextEditingController,
                        validatorFtn: (v) {
                          if (cpController.passwordTextEditingController.text == '') {
                            return Constants.passwordCurrentEmptyMsg;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        node: cpController.focusPassword,
                        onTap: () {},
                        borderRadius: 41,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 20 / 812,
                      ),
                      CustomTextField(
                        enableBorderColor: Colors.transparent,
                        obscure: cpController.isNewPasswordVisible,
                        padding: 12,
                        maxLines: 1,
                        prefixIcon: SvgIconComponent(
                          icon: "lock_icon.svg",
                          color: cpController.focusNewPassword.hasFocus ? AppColors.primaryColor : null,
                        ),
                        cursorColor: AppColors.primaryColor,
                        fillColor: cpController.focusNewPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                        focusColor: AppColors.primaryColor,
                        hint: "New Password",
                        suffixIcon: GestureDetector(
                            onTap: () {
                              cpController.isNewPasswordVisible = !cpController.isNewPasswordVisible;
                              cpController.notifyListeners();
                            },
                            child: cpController.isNewPasswordVisible == true
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black.withOpacity(0.4),
                                  )
                                : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                        hintFontSize: 14,
                        textInputType: TextInputType.visiblePassword,
                        txtController: cpController.newPasswordTextEditingController,
                        // validatorFtn: AppValidator.newPasswordValidator,
                        validatorFtn: (v) {
                          if (cpController.newPasswordTextEditingController.text == "") return Constants.passwordEmptyMsg;
                          String pattern = Constants.regExpPassword;
                          RegExp regExp = RegExp(pattern);
                          bool passwordValid = regExp.hasMatch(cpController.newPasswordTextEditingController.text);

                          if (cpController.newPasswordTextEditingController.text.isEmpty) {
                            return Constants.passwordEmptyMsg;
                          } else if (cpController.newPasswordTextEditingController.text.length < 6) {
                            return Constants.passwordGreaterThanMsg;
                          } else if (!passwordValid) {
                            return Constants.enterValidPasswordHintMsg;
                          } else if (cpController.newPasswordTextEditingController.text == cpController.passwordTextEditingController.text) {
                            return 'New password must be different from current password.';
                          }
                          return null;
                          // if (cpController.newPasswordTextEditingController.text == '') {
                          //   return Constants.passwordNewEmptyMsg;
                          // } else if (cpController.passwordTextEditingController.text != cpController.newPasswordTextEditingController.text) {
                          //   return 'New password must be different from current password.';
                          // }
                          // return null;
                        },
                        textInputAction: TextInputAction.next,
                        node: cpController.focusNewPassword,
                        onTap: () {},
                        borderRadius: 41,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 20 / 812,
                      ),
                      CustomTextField(
                        enableBorderColor: Colors.transparent,
                        obscure: cpController.isConfirmPasswordVisible,
                        padding: 12,
                        maxLines: 1,
                        prefixIcon: Image.asset(
                          "assets/images/icon/password_icon.png",
                          color: cpController.focusConfirmPassword.hasFocus ? AppColors.primaryColor : AppColors.txtFieldgrey,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              cpController.isConfirmPasswordVisible = !cpController.isConfirmPasswordVisible;
                              cpController.notifyListeners();
                            },
                            child: cpController.isConfirmPasswordVisible == true
                                ? Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black.withOpacity(0.4),
                                  )
                                : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                        cursorColor: AppColors.primaryColor,
                        fillColor: cpController.focusConfirmPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                        focusColor: AppColors.primaryColor,
                        hint: "Confirm password",
                        hintFontSize: 14,
                        textInputType: TextInputType.visiblePassword,
                        txtController: cpController.confirmPasswordTextEditingController,
                        validatorFtn: (v) {
                          if (cpController.confirmPasswordTextEditingController.text == '') {
                            return Constants.confirmPasswordEmptyMsg;
                          } else if (cpController.confirmPasswordTextEditingController.text != cpController.newPasswordTextEditingController.text) {
                            return 'Password Mismatched';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        node: cpController.focusConfirmPassword,
                        onTap: () {},
                        borderRadius: 41,
                      ),
                      SizedBox(height: 100),
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
