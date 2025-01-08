// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 
import 'package:val_app/configs/validator/app_validator.dart';
import '../../configs/app_constants.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/rich_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/auth_view_model/signup_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    return ChangeNotifierProvider<SignupViewModel>(
        create: (_) => SignupViewModel(),
        child: Consumer<SignupViewModel>(
          builder: (context, viewModel, child) {
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
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomTextWidget(
                            text: "Let’s Get Started",
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
                            text: "Register your account",
                            fontSize: 22,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 13 / 812,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 711 / 812,
                          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 24 / 812,
                                    ),
                                    Form(
                                      key: viewModel.signUpFormKey,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomTextField(
                                            padding: 19,
                                            maxLines: 1,
                                            maxLength: 15,
                                            cursorColor: AppColors.primaryColor,
                                            fillColor: viewModel.focusUserName.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                            focusColor: AppColors.primaryColor,
                                            hint: "Full Name",
                                            hintFontSize: 14,
                                            prefixIcon: SvgIconComponent(
                                              icon: "username_icon.svg",
                                              color: viewModel.focusUserName.hasFocus ? AppColors.primaryColor : null,
                                            ),
                                            textInputType: TextInputType.name,
                                            txtController: viewModel.userNameTextEditingController,
                                            validatorFtn: AppValidator.fullNameValidator,
                                            textInputAction: TextInputAction.next,
                                            node: viewModel.focusUserName,
                                            inputFormat: [LengthLimitingTextInputFormatter(40)],
                                            onTap: () {},
                                            borderRadius: 41,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 20 / 812,
                                          ),
                                          CustomTextField(
                                            padding: 19,
                                            maxLines: 1,
                                            cursorColor: AppColors.primaryColor,
                                            fillColor: viewModel.focusEmail.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                            focusColor: AppColors.primaryColor,
                                            hint: "Email",
                                            hintFontSize: 14,
                                            prefixIcon: SvgIconComponent(
                                              icon: "email_icon.svg",
                                              color: viewModel.focusEmail.hasFocus ? AppColors.primaryColor : null,
                                            ),
                                            textInputType: TextInputType.emailAddress,
                                            txtController: viewModel.emailTextEditingController,
                                            validatorFtn: AppValidator.emailValidator,
                                            textInputAction: TextInputAction.next,
                                            node: viewModel.focusEmail,
                                            onTap: () {},
                                            borderRadius: 41,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 20 / 812,
                                          ),
                                          CustomTextField(
                                            padding: 19,
                                            maxLines: 1,
                                            cursorColor: AppColors.primaryColor,
                                            fillColor: viewModel.focusPhone.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                            focusColor: AppColors.primaryColor,
                                            hint: "Phone",
                                            hintFontSize: 14,
                                            prefixIcon: SvgIconComponent(
                                              icon: "phone.svg",
                                              color: viewModel.focusPhone.hasFocus ? AppColors.primaryColor : null,
                                            ),
                                            textInputType: TextInputType.phone,
                                            txtController: viewModel.phoneTextEditingController,
                                            validatorFtn: AppValidator.phoneValidator,
                                            textInputAction: TextInputAction.next,
                                            node: viewModel.focusPhone,
                                            maxLength: 12,
                                            inputFormat: [LengthLimitingTextInputFormatter(20)],
                                            onTap: () {},
                                            borderRadius: 41,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 20 / 812,
                                          ),
                                          CustomTextField(
                                            obscure: viewModel.isPasswordVisible,
                                            padding: 19,
                                            //maxLines: 2,
                                            prefixIcon: SvgIconComponent(
                                              icon: "lock_icon.svg",
                                              color: viewModel.focusPassword.hasFocus ? AppColors.primaryColor : null,
                                            ),
                                            cursorColor: AppColors.primaryColor,
                                            fillColor: viewModel.focusPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                            focusColor: AppColors.primaryColor,
                                            hint: "Password",
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  viewModel.isPasswordVisible = !viewModel.isPasswordVisible;
                                                  viewModel.notifyListeners();
                                                },
                                                child: viewModel.isPasswordVisible == true
                                                    ? Icon(
                                                        Icons.visibility_off_outlined,
                                                        color: Colors.black.withOpacity(0.4),
                                                      )
                                                    : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                                            hintFontSize: 14,
                                            textInputType: TextInputType.visiblePassword,
                                            txtController: viewModel.passwordTextEditingController,
                                            validatorFtn: AppValidator.passwordValidator,
                                            textInputAction: TextInputAction.next,
                                            node: viewModel.focusPassword,
                                            onTap: () {},
                                            borderRadius: 41,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 20 / 812,
                                          ),
                                          CustomTextField(
                                            obscure: viewModel.isConfirmPasswordVisible,
                                            padding: 19,
                                            maxLines: 1,
                                            prefixIcon: Image.asset(
                                              "assets/images/icon/password_icon.png",
                                              color: viewModel.focusConfirmPassword.hasFocus ? AppColors.primaryColor : AppColors.txtFieldgrey,
                                            ),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  viewModel.isConfirmPasswordVisible = !viewModel.isConfirmPasswordVisible;
                                                  viewModel.notifyListeners();
                                                },
                                                child: viewModel.isConfirmPasswordVisible == true
                                                    ? Icon(
                                                        Icons.visibility_off_outlined,
                                                        color: Colors.black.withOpacity(0.4),
                                                      )
                                                    : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                                            cursorColor: AppColors.primaryColor,
                                            fillColor: viewModel.focusConfirmPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                            focusColor: AppColors.primaryColor,
                                            hint: "Confirm password",
                                            hintFontSize: 14,
                                            textInputType: TextInputType.visiblePassword,
                                            txtController: viewModel.confirmPasswordTextEditingController,
                                            validatorFtn: (v) {
                                              if (viewModel.confirmPasswordTextEditingController.text == '') {
                                                return Constants.confirmPasswordEmptyMsg;
                                              } else if (viewModel.confirmPasswordTextEditingController.text != viewModel.passwordTextEditingController.text) {
                                                return 'Password Mismatched';
                                              }
                                              return null;
                                            },
                                            textInputAction: TextInputAction.done,
                                            node: viewModel.focusConfirmPassword,
                                            onTap: () {},
                                            borderRadius: 41,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 29 / 812,
                                          ),
                                          Row(
                                            children: [
                                              SvgIconComponent(
                                                icon: viewModel.isAccept == true ? "remember_me.svg" : "remember_me_not.svg",
                                                height: 20,
                                                width: 20,
                                                onTap: () {
                                                  viewModel.isAccept = !viewModel.isAccept;
                                                  viewModel.notifyListeners();
                                                },
                                              ),
                                              const SizedBox(
                                                width: 9,
                                              ),
                                              RichTextWidget(
                                                text: "I accept ",
                                                textFontWeight: FontWeight.w500,
                                                textFontSize: 13,
                                                onTapFontWeight: FontWeight.w500,
                                                onTapFontSize: 13,
                                                onTap: () {},
                                                onTapText: "Terms of service",
                                                color: AppColors.txtFieldgrey,
                                                onTapColor: AppColors.primaryColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 23 / 812,
                                    ),
                                    CustomButton(
                                      onTap: () async {
                                        await viewModel.signUp(context);
                                        // if (viewModel.signUpFormKey.currentState!.validate() && viewModel.isAccept == true) {
                                        //viewModel.signUp();
                                        // Navigator.pushNamed(context, RoutesName.createProfile, arguments: {
                                        //   'isEdit': false,
                                        // });
                                        // }
                                        // if (viewModel.signUpFormKey.currentState!.validate() && viewModel.isAccept) {
                                        //   await viewModel.signUp(context);
                                        // }
                                        // Navigator.pushNamed(context, RoutesName.createProfile, arguments: {'isEdit': false});
                                      },
                                      radius: 26,
                                      height: MediaQuery.of(context).size.height * 49 / 812,
                                      fontWeight: FontWeight.w600,
                                      bgColor: viewModel.isAccept == false ? AppColors.primaryColor.withOpacity(0.2) : AppColors.primaryColor,
                                      fontColor: viewModel.isAccept == false ? AppColors.whiteColor.withOpacity(0.8) : AppColors.whiteColor,
                                      fontSize: 15,
                                      title: "Sign Up",
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
                                      height: MediaQuery.of(context).size.height * 19 / 812,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                             viewModel.signInWithGoogle(context);
                                          },
                                          child: Container(
                                              height: 57,
                                              width: 57,
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.txtFieldgrey.withOpacity(0.2)),
                                              child: SvgIconComponent(
                                                icon: "google_icon.svg",
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 22,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            viewModel.signInWithFacebook();
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
                                               viewModel.signInWithApple(context);
                                            },
                                            child: Container(
                                              height: 57,
                                              width: 57,
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.txtFieldgrey.withOpacity(0.2)),
                                              child: Image.asset("assets/images/icon/apple_icon.png"),
                                            ),
                                          )
                                        ]
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 25 / 812,
                                    ),
                                    Center(
                                        child: RichTextWidget(
                                      text: "Already have an account?",
                                      textFontSize: 16,
                                      textFontWeight: FontWeight.w600,
                                      onTapText: " Sign In",
                                      onTapFontSize: 16,
                                      onTapFontWeight: FontWeight.w600,
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      color: Color(0xFF949BAB),
                                      onTapColor: AppColors.primaryColor,
                                    )),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 10 / 812,
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    )
                                  ],
                                ),
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
        ));
  }
}
