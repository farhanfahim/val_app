import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:val_app/model/interest_model.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/routes/routes_name.dart';
import '../../configs/utils.dart';

class InterestViewModel extends ChangeNotifier {
  List<InterestData> interestList = [];

  List<int> selectedIntresetIds = [];
  bool isLoading = true;

  Future<void> getInterest(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getInterest(headers: headers);
      if (response['status'] == true) {
        final interests = InterestModel.fromJson(response);

        interestList = interests.interestData ?? [];
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

  void interestSelection(int id) {
    if (selectedIntresetIds.contains(id)) {
      selectedIntresetIds.remove(id);
    } else {
      // if (selectedIntresetIds.length < 5) {
      selectedIntresetIds.add(id);
      // } else {
      //   print('You can select only up to 5 interests.');
      // }
    }
    notifyListeners();
  }

  bool isSelected(int id) {
    return selectedIntresetIds.contains(id);
  }

  Future<void> addIntreset(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    Map<String, dynamic> data = {};
    for (var i = 0; i < selectedIntresetIds.length; i++) {
      data['interest_${i + 1}'] = selectedIntresetIds[i];
    }
    print("intreset data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().addInterest(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        Navigator.pop(context);
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.bottomNav, (Route<dynamic> route) => false);
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
}
