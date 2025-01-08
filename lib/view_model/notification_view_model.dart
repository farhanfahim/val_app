import 'package:flutter/material.dart';
import '../Repository/home_api/home_api_repo.dart';
import '../configs/utils.dart';
import '../model/notification_list_model.dart';

class NotificationViewModel extends ChangeNotifier {

  NotificationListModel notificationModel = NotificationListModel();
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  List<Data> notificationList = [];
  bool isLoading = true;

  Future<void> getNotifications(BuildContext context,{bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      final response = await homeRepo.getNotifications(headers: headers);
      if (response['status']) {
        final notificationModel = NotificationListModel.fromJson(response);
        if (notificationModel.notificationData!.isNotEmpty) {
          notificationList = notificationModel.notificationData ?? [];
          print(notificationList.length);
        }
        if (isPullToRefresh == false) Navigator.pop(context);

      } else {
        if (isPullToRefresh == false) Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }

    } catch (error) {
      if (isPullToRefresh == false) Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      notifyListeners();
      isLoading = false;
    }
  }

}
