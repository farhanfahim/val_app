import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/sharedPerfs.dart';
import '../../configs/utils.dart';
import '../../firestore/chat_strings.dart';
import '../../model/block_user_model.dart';

class BlockedUserViewModel extends ChangeNotifier {

  BlockUserModel blockedUserView = BlockUserModel();
  AccountHttpApiRepository accRepo = AccountHttpApiRepository();

  List<Data> blockedList = [];
  bool isLoading = true;

  Future<void> getBlockedUsers(BuildContext context,{bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      final response = await accRepo.getBlockList(headers: headers);
      if (response['status']) {
        final blockUserModel = BlockUserModel.fromJson(response);
        if (blockUserModel.data!.isNotEmpty) {
          blockedList = blockUserModel.data ?? [];
          print(blockedList.length);
        }
        if (isPullToRefresh == false) Navigator.pop(context);

      } else {
        if (isPullToRefresh == false) Navigator.pop(context);
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

            List<dynamic> blockedStatuses = chatDetail.get(ChatStrings.blockedStatuses);
            for (var blockedStatus in blockedStatuses) {

              if (blockedStatus[ChatStrings.id] != int.parse(myUserId)) {
                blockedStatus[ChatStrings.isBlocked] = false;
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


  Future<void> unBlockUser(BuildContext context, String id) async {
    // Show loading dialog

    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "block_id": id,
    };
    print("blocking data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().unblockUser(
        data: jsonEncode(data),
        headers: headers,
      );
      if(response['status']){
        updateBlockStatusOnFirestore(id);
      }
    } catch (error) {
      Utils.toastMessage(error.toString());
    }finally{

      notifyListeners();
    }
  }


}
