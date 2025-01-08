// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/main_scaffold.dart'; 
import 'package:val_app/view_model/auth_view_model/create_password_view_model.dart'; 
import '../../configs/app_constants.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/validator/app_validator.dart';

class CreatePasswordView extends StatelessWidget {
  final String email;
  const CreatePasswordView({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Navigator.pop(context);
    // var email = Provider.of<ForgotPasswordViewModel>(context, listen: false).emailTextEditingController.text;
    return ChangeNotifierProvider(
      create: (_) => CreatePasswordViewModel(),
      child: Consumer<CreatePasswordViewModel>(
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
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 93 / 812,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextWidget(
                        text: "Reset Password",
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                        lineHeight: 1,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 5 / 812,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextWidget(
                        text: "Set a new and strong password",
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Form(
                                key: controller.createPasswordFormKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 29 / 812,
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
                                      textInputType: TextInputType.visiblePassword,
                                      txtController: controller.passwordTextEditingController,
                                      validatorFtn: AppValidator.passwordValidator,
                                      textInputAction: TextInputAction.next,
                                      node: controller.focusPassword,
                                      onTap: () {},
                                      borderRadius: 41,
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 20 / 812,
                                    ),
                                    CustomTextField(
                                      obscure: controller.isConfirmPasswordVisible,
                                      padding: 19,
                                      maxLines: 1,
                                      prefixIcon: SvgIconComponent(
                                        icon: "lock_icon.svg",
                                        color: controller.focusConfirmPassword.hasFocus ? AppColors.primaryColor : null,
                                      ),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            controller.isConfirmPasswordVisible = !controller.isConfirmPasswordVisible;
                                            controller.notifyListeners();
                                          },
                                          child: controller.isConfirmPasswordVisible == true
                                              ? Icon(
                                                  Icons.visibility_off_outlined,
                                                  color: Colors.black.withOpacity(0.4),
                                                )
                                              : Icon(Icons.visibility_outlined, color: Colors.black.withOpacity(0.4))),
                                      cursorColor: AppColors.primaryColor,
                                      fillColor:
                                          controller.focusConfirmPassword.hasFocus ? AppColors.whiteColor : AppColors.txtFieldgrey.withOpacity(.2),
                                      focusColor: AppColors.primaryColor,
                                      hint: "Confirm Password",
                                      hintFontSize: 14,
                                      txtController: controller.confirmPasswordTextEditingController,
                                      validatorFtn: (v) {
                                        if (controller.confirmPasswordTextEditingController.text == '') {
                                          return Constants.confirmPasswordEmptyMsg;
                                        } else if (controller.confirmPasswordTextEditingController.text !=
                                            controller.passwordTextEditingController.text) {
                                          return 'Password Mismatched';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.next,
                                      node: controller.focusConfirmPassword,
                                      onTap: () {},
                                      borderRadius: 41,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              CustomButton(
                                onTap: () {
                                  controller.getCreatePass(context, email);
                                  // if (controller.createPasswordFormKey.currentState!.validate()) {
                                  //   Navigator.pushReplacementNamed(context, RoutesName.login);
                                  //   //controller.resetPassword();
                                  // }
                                },
                                radius: 26,
                                height: MediaQuery.of(context).size.height * 49 / 812,
                                fontWeight: FontWeight.w600,
                                bgColor: AppColors.primaryColor,
                                fontColor: AppColors.whiteColor,
                                fontSize: 15,
                                title: "Reset",
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
          );
        },
      ),
    );
  }
}
