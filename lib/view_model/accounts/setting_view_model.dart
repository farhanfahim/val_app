import 'package:flutter/material.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/routes/routes_name.dart';
import '../../configs/sharedPerfs.dart';
import '../../configs/utils.dart';
import '../../firestore/firestore_controller.dart';

class SettingViewModel extends ChangeNotifier {
  bool enableNotification = false;
  Future<void> deleteAccount(BuildContext context) async {
    // Show loading dialog
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {};
    print("change pass data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().deleteAccount(
        data: data,
        headers: headers,
      );
      if (response['status'] == true) {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
        String id = SharedPrefs.instance.getString("userId") ?? "";
        await SharedPrefs.instance.clearPrefsSpecific('accessToken');
        await SharedPrefs.instance.clearPrefsSpecific('refreshToken');
        await SharedPrefs.instance.clearPrefsSpecific('userId');
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.login, (Route<dynamic> route) => false);
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

  bool isLoading = true;

  Future<void> notificationToggle(BuildContext context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().notificationToggle(headers: headers);
      if (response['status'] == true) {
        enableNotification = !enableNotification;
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> getNotificationToggle(BuildContext context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getNotificationToggle(headers: headers);
      if (response['status'] == true) {
        print(response.toString());
        enableNotification = response['data']['toggle'];
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }
}
