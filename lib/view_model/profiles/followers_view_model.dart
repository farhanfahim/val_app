import 'package:flutter/material.dart';

import '../../Repository/home_api/home_api_repo.dart';
import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';
import '../../model/followers_model.dart';

class FollowersViewModel extends ChangeNotifier {
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  List<Followers> followersList = [];
  bool isLoading = true;

  Future<void> getFollowers(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getFollowersFollowing(headers: headers);
      if (response['status'] == true) {
        final followers = FollowersFollowingModel.fromJson(response);
        if (followers.data!.followers!.isEmpty) {
          // Utils.toastMessage("not found");
        } else {
          // followersList = [];
          followersList = followers.data?.followers ?? [];
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

  Future<void> followUnfollow(BuildContext context, {String? id, required Followers follow}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        follow.isFollow = !follow.isFollow!;
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }
}
