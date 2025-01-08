import 'package:flutter/material.dart';

import '../../Repository/home_api/home_api_repo.dart';
import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';
import '../../model/followers_model.dart';

class UserFollowersViewModel extends ChangeNotifier {
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  List<Followers> userfollowersList = [];
  List<Followers> followed = [];
  bool isLoading = true;

  Future<void> getUserFollowers(BuildContext context, String id, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await AccountHttpApiRepository().getOtherUserFollowersFollowing(headers: headers, id: id);
      if (response['status'] == true) {
        final followers = FollowersFollowingModel.fromJson(response);
        if (followers.data!.followers!.isEmpty) {
          // Utils.toastMessage("not found");
        } else {
          // userfollowersList = [];
          userfollowersList = followers.data?.followers ?? [];
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

  void followersSelection(Followers follow) {
    if (followed.contains(follow)) {
      followed.remove(follow);
    } else {
      followed.add(follow);
    }
    notifyListeners();
  }

  Future<void> followUnfollow(BuildContext context, {String? id, required Followers follow, int? index}) async {
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
        // followersSelection(follow);
        userfollowersList[index!].isFollow = !userfollowersList[index].isFollow!;
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
