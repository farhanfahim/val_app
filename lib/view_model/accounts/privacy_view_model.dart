import 'package:flutter/material.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';
import '../../model/privacy_model.dart';

class PrivacyViewModel extends ChangeNotifier {
  PrivacyModel? privacyData;
  bool isLoading = true;

  Future<void> getPrivacy(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getPrivacy(headers: headers);
      if (response['status'] == true) {
        final terms = PrivacyModel.fromJson(response);

        privacyData = terms;
        print(response.toString());
        if (isPullToRefresh == false) Navigator.pop(context);
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
