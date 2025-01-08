import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/view_model/accounts/send_query_view_model.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_text_field.dart';
import '../../../configs/validator/app_validator.dart';

class SendQueryWidget extends StatefulWidget {
  const SendQueryWidget({
    super.key,
  });

  @override
  State<SendQueryWidget> createState() => _SendQueryWidgetState();
}

class _SendQueryWidgetState extends State<SendQueryWidget> {
  final SendQueryViewModel controller = SendQueryViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<SendQueryViewModel>(
        builder: (context, cnt, child) {
          return Form(
            key: cnt.queryFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomTextWidget(
                          text: "How can we help you?",
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 7 / 812),
                        CustomTextWidget(
                          textAlign: TextAlign.center,
                          text: "Lorem ipsum dolor sit amet consectetur.Ac ornare pharetra facilisis felis.",
                          fontSize: 16,
                          color: AppColors.grey3,
                          fontWeight: FontWeight.normal,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 30 / 812),
                        Align(alignment: Alignment.topLeft, child: CustomTextWidget(text: "Subject", fontSize: 14, fontWeight: FontWeight.w700)),
                        SizedBox(height: MediaQuery.of(context).size.height * 7 / 812),
                        CustomTextField(
                          padding: 12,
                          maxLines: 1,
                          maxLength: 64,
                          cursorColor: AppColors.primaryColor,
                          fillColor: AppColors.whiteColor,
                          focusColor: AppColors.primaryColor,
                          hint: "Enter subject...",
                          hintFontSize: 14,
                          textInputType: TextInputType.visiblePassword,
                          txtController: cnt.subjectTextEditingController,
                          validatorFtn: AppValidator.required,
                          textInputAction: TextInputAction.next,
                          node: cnt.focusSubject,
                          borderRadius: 41,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 10 / 812),
                        Align(alignment: Alignment.topLeft, child: CustomTextWidget(text: "Message", fontSize: 14, fontWeight: FontWeight.w700)),
                        SizedBox(height: MediaQuery.of(context).size.height * 7 / 812),
                        CustomTextField(
                          padding: 12,
                          minLines: 6,
                          maxLines: 6,
                          maxLength: 300,
                          showMaxLength: true,
                          cursorColor: AppColors.primaryColor,
                          fillColor: AppColors.whiteColor,
                          focusColor: AppColors.primaryColor,
                          hint: "Enter message...",
                          hintFontSize: 14,
                          textInputType: TextInputType.visiblePassword,
                          txtController: cnt.messageTextEditingController,
                          validatorFtn: AppValidator.required,
                          textInputAction: TextInputAction.done,
                          node: cnt.focusMessage,
                          borderRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: CustomButton(
                    onTap: () {
                      //tick_shadow
                      if (controller.queryFormKey.currentState!.validate()) {
                        // alertDialog(context);
                        controller.sendQuery(context);
                      }
                    },
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    bgColor: Colors.transparent,
                    borderColor: AppColors.primaryColor,
                    title: "Submit Query",
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontColor: AppColors.primaryColor,
                    radius: 100,
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
