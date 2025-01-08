import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/configs/utils.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  TextEditingController emailTextEditingController = TextEditingController();
  final forgotFormKey = GlobalKey<FormState>();

  FocusNode focusEmail = FocusNode();

  ForgotPasswordViewModel() {
    focusEmail.addListener(notifyListeners);
  }

  @override
  void dispose() {
    focusEmail.dispose();
    super.dispose();
  }

  void forgotPassword() {
    if (forgotFormKey.currentState!.validate()) {
      // Perform login logic here
    }
  }

  Future<void> forgetPass(BuildContext context) async {
    if (forgotFormKey.currentState!.validate()) {
      // Show loading dialog
      Utils().loadingDialog(context);

      var headers = {'Content-Type': 'application/json'};
      dynamic data = {
        "email": emailTextEditingController.text.trim().toLowerCase(),
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
          // Navigator.pushNamed(context, RoutesName.bottomNav);
          Navigator.pushNamed(context, RoutesName.code, arguments: {
            'email': emailTextEditingController.text.toLowerCase(),
          });
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
}
