import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/otherUserProfileModel.dart';
import 'package:val_app/model/postDetailModel.dart';
import 'package:val_app/model/skills_model.dart';
import 'package:val_app/view_model/home_view_model.dart';
import 'package:val_app/view_model/profiles/my_profile_view_model.dart';

import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/sharedPerfs.dart';
import '../../firestore/chat_strings.dart';

enum TabsEnum { work, about }

class UserMyProfileViewModel extends ChangeNotifier {
  TabsEnum _selected = TabsEnum.work;

  TabsEnum get selected => _selected;

  void setSelected(TabsEnum selection) {
    _selected = selection;
    notifyListeners();
  }

  List<SkillsModel> skills = [
    // SkillsModel(id: 1, name: "illustration"),
    // SkillsModel(id: 2, name: "animation"),
    // SkillsModel(id: 3, name: "3d modeling"),
    // SkillsModel(id: 4, name: "3d animation"),
  ];

  Future<void> getFollowProfile(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        otherUSer?.data?.isFollowing = !otherUSer!.data!.isFollowing!;
        Provider.of<HomeViewModel>(context, listen: false).getAllFeeds(context);

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

  OtherUserProfileModel? otherUSer;
  PostDetailModel? myProfileDetail;
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();
  bool otherUserLoader = true;

  Future<void> getOtherUserProfile(BuildContext context, {required String id}) async {
    print("CALLED");
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      OtherUserProfileModel response =
          await homeRepo.getOtherUser(headers: headers, data: data, id: id);

      if (response.status == "success") {
        Navigator.pop(context);
        otherUSer = response;
        print("feeds" + otherUSer!.data!.id.toString());
        otherUserLoader = false;
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getMyProfiledetail(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      PostDetailModel response =
          await homeRepo.getMyProfileDetail(headers, data, id: id);

      if (response.status == "success") {
        Navigator.pop(context);

        myProfileDetail = response;
        Provider.of<MyProfileViewModel>(context, listen: false)
            .setPostDetailData(response);
        Navigator.pushNamed(context, RoutesName.userPostDetail);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  updateBlockStatusOnFirestore(String userId) async {
    String myUserId = SharedPrefs.instance.getString("userId") ?? "";
    List<int> ids = [int.parse(myUserId), int.parse(userId)];

    FirebaseFirestore.instance
        .collection(ChatStrings.chatsCollectionReference)
        .where(ChatStrings.userIds, arrayContainsAny: ids)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          var idsFromJson = doc.get(ChatStrings.userIds);

          List<int> idsList = List<int>.from(idsFromJson);
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          if (unOrdDeepEq(idsList, ids) == true) {
            var chatDetail = await FirebaseFirestore.instance
                .collection(ChatStrings.chatsCollectionReference)
                .doc(doc.id)
                .get();

            List<dynamic> blockedStatuses =
                chatDetail.get(ChatStrings.blockedStatuses);
            for (var blockedStatus in blockedStatuses) {
              if (blockedStatus[ChatStrings.id] != int.parse(myUserId)) {
                blockedStatus[ChatStrings.isBlocked] = true;
              }
            }
            await FirebaseFirestore.instance
                .collection(ChatStrings.chatsCollectionReference)
                .doc(doc.id)
                .update({
              ChatStrings.blockedStatuses: blockedStatuses,
            });
            break;
          }
        }
      } else {
        return "";
      }
    });
  }

  Future<void> blockUser(BuildContext context, String id) async {
    // Show loading dialog
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "profile_id": id,
    };
    print("blocking data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().blockUser(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        updateBlockStatusOnFirestore(id);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        await Provider.of<HomeViewModel>(context, listen: false)
            .getAllFeeds(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Navigator.pop(context);

        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
  }
}
