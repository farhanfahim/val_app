// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/main_scaffold.dart'; 
import 'package:val_app/view_model/auth_view_model/forgot_password_view_model.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/validator/app_validator.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, controller, child) {
          return MainScaffold(
            backgroundColor: AppColors.primaryColor,
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: MainScaffold(
                backgroundColor: AppColors.primaryColor,
                appBar: CustomAppBar(
                  leading: true,
                  bgColor: Colors.transparent,
                  // backButtonColor: Styles.white,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 93 / 812,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: CustomTextWidget(
                        text: "Forgot Password?",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                        lineHeight: 1,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 5 / 812,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: CustomTextWidget(
                        text: "Enter your email address",
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 23 / 812,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Form(
                                  key: controller.forgotFormKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 29 / 812,
                                      ),
                                      CustomTextField(
                                        padding: 19,
                                        maxLines: 1,
                                        cursorColor: AppColors.primaryColor,
                                        fillColor: controller.focusEmail.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                        focusColor: AppColors.primaryColor,
                                        hint: "Email",
                                        hintFontSize: 14,
                                        prefixIcon: Image.asset(
                                          "assets/images/icon/message_icon.png",
                                          color: controller.focusEmail.hasFocus ? AppColors.primaryColor : AppColors.txtFieldgrey,
                                        ),
                                        textInputType: TextInputType.emailAddress,
                                        txtController: controller.emailTextEditingController,
                                        validatorFtn: AppValidator.emailValidator,
                                        textInputAction: TextInputAction.next,
                                        node: controller.focusEmail,
                                        onTap: () {},
                                        borderRadius: 41,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  onTap: () {
                                    controller.forgetPass(context);
                                    // if (controller.forgotFormKey.currentState!.validate()) {
                                    //   //  controller.forgotPassword();
                                    //   Navigator.pushNamed(context, RoutesName.code,arguments: {
                                    //     'email':controller.emailTextEditingController.text,
                                    //   });
                                    // }
                                  },
                                  radius: 26,
                                  height: MediaQuery.of(context).size.height * 49 / 812,
                                  fontWeight: FontWeight.w700,
                                  bgColor: AppColors.primaryColor,
                                  fontColor: AppColors.whiteColor,
                                  fontSize: 15,
                                  title: "Submit",
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 30 / 812,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Center(
                                    child: CustomTextWidget(
                                      text: "Enter your email address to recover \npassword.",
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.txtFieldgrey,
                                      fontSize: 16,
                                    ),
                                  ),
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
          );
        },
      ),
    );
  }
}
