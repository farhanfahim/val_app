import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/utils.dart';

class SendQueryViewModel extends ChangeNotifier {
  TextEditingController subjectTextEditingController = TextEditingController();
  TextEditingController messageTextEditingController = TextEditingController();
  final queryFormKey = GlobalKey<FormState>();
  FocusNode focusSubject = FocusNode();
  FocusNode focusMessage = FocusNode();

  SendQueryViewModel() {
    {
      focusSubject.addListener(notifyListeners);
      focusMessage.addListener(notifyListeners);
    }
  }
  Future<void> sendQuery(BuildContext context) async {
    // Show loading dialog
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "subject": subjectTextEditingController.text,
      "message": messageTextEditingController.text,
    };
    print("change pass data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().sendQuery(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        // Utils.toastMessage(response['message'].toString());
        alertDialog(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
  }

  Future<dynamic> alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.only(top: 38, bottom: 23, left: 21, right: 21),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgIconComponent(icon: "tick_shadow.svg", height: 120, width: 120),
                SizedBox(height: 23),
                CustomTextWidget(
                  textAlign: TextAlign.center,
                  text: "Thank you for your feedback",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
                SizedBox(height: 8),
                CustomTextWidget(
                  textAlign: TextAlign.center,
                  text: "We will get back to you shortly!",
                  color: AppColors.grey3,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 36),
                CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  height: 40,
                  radius: 26,
                  title: "Alright!",
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  fontColor: AppColors.purple2,
                  borderColor: AppColors.purple2,
                  bgColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
