import 'package:flutter/material.dart';
import 'package:val_app/model/terms_model.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';

class TermsViewModel extends ChangeNotifier {
  TermsModel? termsData;
  bool isLoading = true;

  Future<void> getTerms(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getTerms(headers: headers);
      if (response['status'] == true) {
        final terms = TermsModel.fromJson(response);

        termsData = terms;
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
