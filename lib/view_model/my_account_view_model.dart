import 'package:flutter/material.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/MyProfileModel.dart';

import '../configs/routes/routes_name.dart';
import '../configs/sharedPerfs.dart';
import '../firebase/firebase_messaging.dart';
import '../firestore/firestore_controller.dart';
import '../model/AuthModels/SignInModel.dart';

class MyAccountViewModel extends ChangeNotifier {
  bool loader = true;
  MyProfileModel? myProfile;

  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> getMyProfile(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      MyProfileModel response = await homeRepo.getMyProfile(headers);

      if (response.status == true) {
        loader = false;
        myProfile = response;
        print("profile updated");
        notifyListeners();
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());

      print("error: $error");
    } finally {
      loader = false;
    }
  }
  Future<void> logout(BuildContext context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? refreshToken = credentials['refreshToken'];
    var fcmToken = await FirebaseMessagingHandler().getFcmToken();
    print("fcm token" + fcmToken);
    dynamic data = {
      "refresh": refreshToken,
      "fcm": fcmToken,
    };
    try {
      dynamic response =
      await homeRepo.logout(data: data);

      if (response["status"]!) {
        Navigator.pop(context);
        String id = SharedPrefs.instance.getString("userId") ?? "";
        final credentials = await Utils.getUserCredentials();
        await SharedPrefs.instance.clearPrefs();
        if (credentials['email'] != null && credentials['password'] != null) {
          Utils.saveUserCredentials(
            email: credentials['email']!,
            password: credentials['password']!,
            rememberMe: credentials['isRememberMe'],
          );
        }
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (Route<dynamic> route) => false);
        notifyListeners();
      } else {
        Navigator.pop(context);
        // Check for token expiration error
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }
}
