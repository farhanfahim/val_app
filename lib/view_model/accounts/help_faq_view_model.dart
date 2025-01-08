import 'package:flutter/material.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';
import '../../model/faq_model.dart';

class FaqViewModel extends ChangeNotifier {
  List<bool> expansionStates = [];
  bool _isToggling = false;
  List<FaqData> faqData = [];
  bool isLoading = true;

  Future<void> getFAQ(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getFAQ(headers: headers);
      if (response['status'] == true) {
        final faq = FAQModel.fromJson(response);
        if (faq.data!.isEmpty) {
          // Utils.toastMessage("FAQs not found");
        } else {
          // faqData = [];
          faqData = faq.data ?? [];
          notifyListeners();
        }
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

  void toggleExpansion(int index, bool expanded) {
    if (_isToggling) return;
    _isToggling = true;
    faqData[index].isExpand = !faqData[index].isExpand!;
    Future.delayed(const Duration(milliseconds: 300), () {
      _isToggling = false;
    });
    notifyListeners();
  }
}
