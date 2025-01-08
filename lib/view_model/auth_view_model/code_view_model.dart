import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/configs/utils.dart';

class CodeViewModel extends ChangeNotifier {
//  final String argument;

  TextEditingController otpFieldController = TextEditingController();
  final codeFormKey = GlobalKey<FormState>();

  FocusNode focusEmail = FocusNode();

  CodeViewModel() {
    focusEmail.addListener(notifyListeners);
  }

  @override
  void dispose() {
    focusEmail.dispose();
    super.dispose();
  }

  void verifyOtp() {
    if (codeFormKey.currentState!.validate()) {
      // Perform login logic here
    }
  }

  Future<void> getOtp(BuildContext context, String email) async {
    // if (codeFormKey.currentState!.validate()) {
    // Show loading dialog
    Utils().loadingDialog(context);

    var headers = {'Content-Type': 'application/json'};
    dynamic data = {
      "otp": otpFieldController.text,
    };

    try {
      dynamic response = await AuthHttpApiRepository().otp(
        data: jsonEncode(data),
        headers: headers,
      );

      if (response['status'] == true) {
        // Set user data and navigate

        Navigator.pop(context);
        //Utils.toastMessage(response['message'].toString());
        SharedPrefs.instance.setString("accessToken", response['data']['access'].toString());
        // Navigator.pushNamed(context, RoutesName.bottomNav);
        Navigator.pushNamed(context, RoutesName.createPassword, arguments: {"email": email});
        notifyListeners();

        if (kDebugMode) {
          print("Access token: ${SharedPrefs.instance.getString("accessToken")}");
        }
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
    // }
  }

  Future<void> resendOTP(BuildContext context, {String? email}) async {
    Utils().loadingDialog(context);

    var headers = {'Content-Type': 'application/json'};
    dynamic data = {
      "email": email,
    };

    try {
      dynamic response = await AuthHttpApiRepository().forgetPass(
        data: jsonEncode(data),
        headers: headers,
      );

      if (response['status'] == true) {
        // Set user data and navigate
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
        notifyListeners();
        if (kDebugMode) {
          print("Access token: ${SharedPrefs.instance.getString("accessToken")}");
        }
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
  }
}
