import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:val_app/Repository/my_account_api/account_http_api_repository.dart';

import '../../configs/utils.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController newPasswordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  final changePasswordFormKey = GlobalKey<FormState>();
  FocusNode focusPassword = FocusNode();
  FocusNode focusNewPassword = FocusNode();
  FocusNode focusConfirmPassword = FocusNode();
  bool isPasswordVisible = true;
  bool isNewPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible = !isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    notifyListeners();
  }

  ChangePasswordViewModel() {
    {
      focusPassword.addListener(() => notifyListeners());
      focusNewPassword.addListener(() => notifyListeners());
      focusConfirmPassword.addListener(() => notifyListeners());
    }
  }
  Future<void> changePassword(BuildContext context) async {
    // Show loading dialog
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "current_password": passwordTextEditingController.text,
      "new_password": confirmPasswordTextEditingController.text,
    };
    print("change pass data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().changePassword(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        print(response.toString());
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
        Navigator.pop(context);
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

  @override
  void dispose() {
    focusPassword.dispose();
    focusNewPassword.dispose();
    focusConfirmPassword.dispose();
    super.dispose();
  }
}
