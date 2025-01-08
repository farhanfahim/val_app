// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/routes/routes.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/rich_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/validator/app_validator.dart';
import '../../view_model/auth_view_model/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // context.read<LoginViewModel>().loadUserCredentials();
    //shariq updated from my laptop remember me condition
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // executes after build
      final credentials = await Utils.getUserCredentials();
      if (credentials['isRememberMe'] == true) {
        context.read<LoginViewModel>().loadUserCredentials();
      }
    });
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, controller, child) {
          return MainScaffold(
            backgroundColor: AppColors.primaryColor,
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MainScaffold(
                backgroundColor: Colors.transparent,
                appBar: CustomAppBar(
                  leading: false,
                  bgColor: Colors.transparent,
                  backButtonColor: AppColors.whiteColor,
                ),
                body: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 93 / 812,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextWidget(
                          text: "Hello, Welcome back!",
                          fontSize: 28,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 5 / 812,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextWidget(
                          text: "Login to your account",
                          fontSize: 22,
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 23 / 812,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 579 / 812,
                        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 35 / 812,
                                ),
                                Form(
                                  key: controller.loginFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                        padding: 19,
                                        maxLines: 1,
                                        cursorColor: AppColors.primaryColor,
                                        fillColor: controller.focusEmail.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                        focusColor: AppColors.primaryColor,
                                        hint: "Email",
                                        hintFontSize: 14,
                                        prefixIcon: SvgIconComponent(
                                          icon: "email_icon.svg",
                                          color: controller.focusEmail.hasFocus ? AppColors.primaryColor : null,
                                        ),
                                        textInputType: TextInputType.emailAddress,
                                        txtController: controller.emailTextEditingController,
                                        validatorFtn: AppValidator.emailValidator,
                                        textInputAction: TextInputAction.next,
                                        node: controller.focusEmail,
                                        // inputFormat: [
                                        //   LengthLimitingTextInputFormatter(40),
                                        // ],
                                        onTap: () {},
                                        borderRadius: 41,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 20 / 812,
                                      ),
                                      CustomTextField(
                                        obscure: controller.isPasswordVisible,
                                        padding: 19,
                                        maxLines: 1,
                                        prefixIcon: SvgIconComponent(
                                          icon: "lock_icon.svg",
                                          color: controller.focusPassword.hasFocus ? AppColors.primaryColor : null,
                                        ),
                                        cursorColor: AppColors.primaryColor,
                                        fillColor: controller.focusPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                        focusColor: AppColors.primaryColor,
                                        hint: "Password",
                                        hintFontSize: 14,
                                        textInputType: TextInputType.visiblePassword,
                                        txtController: controller.passwordTextEditingController,
                                        suffixIcon: GestureDetector(
                                            onTap: () {
                                              controller.isPasswordVisible = !controller.isPasswordVisible;
                                              controller.notifyListeners();
                                            },
                                            child: controller.isPasswordVisible == true
                                                ? Icon(
                                                    Icons.visibility_off_outlined,
                                                    color: Colors.black.withOpacity(0.4),
                                                  )
                                                : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                                        validatorFtn: AppValidator.passwordSignInValidator,
                                        textInputAction: TextInputAction.done,
                                        node: controller.focusPassword,
                                        onTap: () {},
                                        borderRadius: 41,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 29 / 812,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                //shariq updated from my laptop remember me condition
                                                controller.rememberMe = !controller.rememberMe;
                                                if (controller.rememberMe) {
                                                  Utils.saveUserCredentials(
                                                    email: controller.emailTextEditingController.text,
                                                    password: controller.passwordTextEditingController.text,
                                                    rememberMe: controller.rememberMe,
                                                  );
                                                } else {
                                                  Utils.clearUserCredentials();
                                                }
                                                controller.notifyListeners();
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      SvgIconComponent(
                                                        icon: controller.rememberMe ? "checkbox_purple.svg" : "remember_me_not.svg",
                                                        height: 20,
                                                        width: 20,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      CustomTextWidget(
                                                        text: "Remember me",
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: Color(0xFF949BAB),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(context, RoutesName.forgotPassword);
                                                    },
                                                    child: CustomTextWidget(
                                                      text: "Forgot Password?",
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.red,
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 37 / 812,
                                ),
                                CustomButton(
                                  onTap: () async {
                                    // Navigator.pushNamed(context, RoutesName.interest);
                                    await controller.login(context);
                                    // Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
                                  },
                                  radius: 26,
                                  height: MediaQuery.of(context).size.height * 49 / 812,
                                  fontWeight: FontWeight.w700,
                                  bgColor: AppColors.primaryColor,
                                  fontColor: AppColors.whiteColor,
                                  fontSize: 15,
                                  title: "Login",
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 20 / 812,
                                ),
                                Center(
                                  child: CustomTextWidget(
                                    text: "or continue with",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF949BAB),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 20 / 812,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          controller.signInWithGoogle(context);
                                        },
                                        child: Container(
                                            height: 57,
                                            width: 57,
                                            padding: EdgeInsets.all(17),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.txtFieldgrey.withOpacity(0.2)),
                                            child: SvgIconComponent(
                                              icon: "google_icon.svg",
                                            ))),
                                    const SizedBox(
                                      width: 22,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // controller.signInWithFacebook();
                                      },
                                      child: Container(
                                          height: 57,
                                          width: 57,
                                          padding: EdgeInsets.all(17),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.txtFieldgrey.withOpacity(0.2)),
                                          child: SvgIconComponent(
                                            icon: "facebook_icon.svg",
                                          )),
                                    ),
                                    if (Platform.isIOS) ...[
                                      const SizedBox(
                                        width: 22,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            controller.signInWithApple(context);
                                          },
                                          child: Container(
                                            height: 57,
                                            width: 57,
                                            padding: EdgeInsets.all(17),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.txtFieldgrey.withOpacity(0.2)),
                                            child: SvgIconComponent(
                                              icon: "apple_icon.svg",
                                            ),
                                          ))
                                    ]
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 105 / 812,
                                ),
                                Center(
                                    child: RichTextWidget(
                                  text: "Don’t have an account?",
                                  textFontSize: 16,
                                  textFontWeight: FontWeight.w600,
                                  onTapText: " Sign Up",
                                  onTapFontSize: 16,
                                  onTapFontWeight: FontWeight.w600,
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutesName.signup);
                                    // Get.toNamed(Routes.signupscreen);
                                  },
                                  color: Color(0xFF949BAB),
                                  onTapColor: AppColors.primaryColor,
                                )),
                                const SizedBox(
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
