import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/configs/utils.dart';

class CreatePasswordViewModel extends ChangeNotifier {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();

  TextEditingController otpFieldController = TextEditingController();
  final createPasswordFormKey = GlobalKey<FormState>();

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  FocusNode focusPassword = FocusNode();
  FocusNode focusConfirmPassword = FocusNode();

  CreatePasswordViewModel() {
    focusPassword.addListener(notifyListeners);
    focusConfirmPassword.addListener(notifyListeners);
  }

  @override
  void dispose() {
    focusPassword.removeListener(notifyListeners);
    focusPassword.dispose();
    focusConfirmPassword.dispose();
    passwordTextEditingController.dispose();
    confirmPasswordTextEditingController.dispose();
    otpFieldController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  void resetPassword() {
    if (createPasswordFormKey.currentState!.validate()) {
      // Perform login logic here
    }
  }

  Future<void> getCreatePass(BuildContext context, String email) async {
    if (createPasswordFormKey.currentState!.validate()) {
      if (passwordTextEditingController.text == confirmPasswordTextEditingController.text) {
        // Show loading dialog
        Utils().loadingDialog(context);

        var headers = {'Content-Type': 'application/json'};
        dynamic data = {
          "email": email.toLowerCase(),
          "new_password": confirmPasswordTextEditingController.text,
        };
        print("createpass" + data.toString());
        try {
          dynamic response = await AuthHttpApiRepository().createPassword(data: jsonEncode(data), headers: headers);
          if (response['status'] == "success") {
            Utils.toastMessage('Password updated successfully');
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, RoutesName.login);
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
      } else {
        Utils.toastMessage("Password Missmatched");
      }
    }
  }
}
