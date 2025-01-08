// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import 'package:val_app/configs/components/main_scaffold.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/rich_text_widget.dart';
import '../../configs/validator/app_validator.dart';
import '../../view_model/auth_view_model/code_view_model.dart';

class CodeScreen extends StatelessWidget {
  final String email;
  CodeScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CodeViewModel(),
      child: Consumer<CodeViewModel>(
        builder: (context, controller, child) {
          return MainScaffold(
            backgroundColor: AppColors.primaryColor,
            appBar: CustomAppBar(
              leading: false,
              bgColor: Colors.transparent,
              backButtonColor: AppColors.whiteColor,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 93 / 812,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: CustomTextWidget(
                    text: "Enter Verification Code",
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
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: CustomTextWidget(
                    text: "Enter 4 digit code",
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
                    decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 29 / 812,
                          ),
                          Form(
                            key: controller.codeFormKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: PinCodeTextField(
                                animationType: AnimationType.fade,
                                appContext: context,
                                textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Manrope", fontSize: 22),
                                pastedTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontFamily: "Manrope", fontSize: 22),
                                length: 4,
                                validator: AppValidator.otpValidator,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(50),
                                  fieldHeight: 52,
                                  fieldWidth: 60,
                                  activeFillColor: AppColors.txtFieldgrey.withOpacity(0.2),
                                  activeColor: AppColors.txtFieldgrey.withOpacity(0.2),
                                  selectedFillColor: AppColors.whiteColor.withOpacity(0.2),
                                  selectedColor: AppColors.txtFieldgrey.withOpacity(0.2),
                                  inactiveFillColor: AppColors.txtFieldgrey.withOpacity(0.2),
                                  inactiveColor: Colors.transparent,
                                ),

                                hintStyle: TextStyle(color: AppColors.blackColor),
                                cursorColor: Colors.black,
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                controller: controller.otpFieldController,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    color: Colors.black12,
                                    blurRadius: 10,
                                  )
                                ],
                                onCompleted: (v) {
                                  debugPrint("Completed");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {
                                  // debugPrint(value);
                                  // setState(() {
                                  //   currentText = value;
                                  // });
                                },
                                beforeTextPaste: (text) {
                                  debugPrint("Allowing to paste $text");
                                  return true;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            onTap: () {
                              if (controller.codeFormKey.currentState!.validate()) {
                                controller.getOtp(context, email);
                              }
                              // if (controller.codeFormKey.currentState!.validate()) {
                              //   Navigator.pushNamed(context, RoutesName.createPassword);
                              // }
                            },
                            radius: 26,
                            height: MediaQuery.of(context).size.height * 49 / 812,
                            fontWeight: FontWeight.w600,
                            bgColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                            fontSize: 15,
                            title: "Submit",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 30 / 812,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: RichTextWidget(
                              text: "Enter 4-digit code sent to your email ",
                              centerText: "${email}",
                              centerDecoration: TextDecoration.underline,
                              onTapText: " Change Email",
                              textFontSize: 16,
                              onTapFontSize: 16,
                              centerFontSize: 16,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              onTapFontWeight: FontWeight.w600,
                              textFontWeight: FontWeight.w600,
                              centerFontWeight: FontWeight.w600,
                              color: AppColors.hintColor,
                              centerColor: AppColors.hintColor,
                              onTapColor: AppColors.primaryColor,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              // controller.otpFieldController.text = '';
                              // controller.getOtp(context, email);
                              controller.resendOTP(context, email: email);
                            },
                            child: SizedBox(
                              child: Center(
                                child: CustomTextWidget(
                                  text: "Resend Code",
                                  color: AppColors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
