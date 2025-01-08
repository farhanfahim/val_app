import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/main.dart';
import '../../Repository/chats_api/chat_api_repo.dart';
import '../../configs/file_picker_util.dart';
import '../../configs/utils.dart';
import '../../data/enums/PickerType.dart';
import '../../firestore/chat_detail.dart';
import '../../firestore/chat_strings.dart';
import '../../firestore/chatting_model.dart';
import '../../firestore/firebase_user_model.dart';
import '../../firestore/firestore_controller.dart';
import '../project/create_project_view_model.dart';

class ChatDetailViewModel extends ChangeNotifier {
  final TextEditingController msgTextController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isMessageSend = false;
  FocusNode messageFocusNode = FocusNode();
  List<ChattingModel> chatList = [];
  ChatDetail? chatDetail = ChatDetail();
  String documentId = "";
  String myUserId = "";
  String userId = "";
  bool isBlocked = false;
  String blockMessage = "";
  bool isBlockedByMe = false;
  bool isBlockedByOther = false;

  List<dynamic> addDatesInNewList() {
    List<dynamic> _returnList;
    List<dynamic> _newData = addChatDateInSnapshot(chatList);
    _returnList = List<dynamic>.from(_newData.reversed);
    return _returnList;
  }

  List<dynamic> addChatDateInSnapshot(List<ChattingModel> snapshot) {
    List<dynamic> _returnList = [];

    String currentDate = "";

    for (ChattingModel item in snapshot) {
      var format = DateFormat('EEEE, MMM d, yyyy');
      var date = item.time!=null?item.time!.toDate(): DateTime.now();
      if (currentDate.isEmpty) {
        currentDate = format.format(date);
        _returnList.add(date);
      }

      if (currentDate == format.format(date)) {
        _returnList.add(item);
      } else {
        currentDate = format.format(date);
        _returnList.add( item.time!=null?item.time!.toDate(): DateTime.now());
        _returnList.add(item);
      }
    }
    return _returnList;
  }


  Stream<List<ChattingModel>> getChatMessages() {
    print("get chats");
    final StreamController<List<ChattingModel>> c = StreamController<List<ChattingModel>>();

    if(documentId.isNotEmpty) {

      FirebaseFirestore.instance
          .collection(ChatStrings.chatsCollectionReference)
          .doc(documentId)
          .collection(ChatStrings.threadsCollectionReference)
          .orderBy(ChatStrings.createdAt, descending: false)
          .snapshots()
          .listen((chatListSnapshot) {
        chatList.clear();

        for (var chatMessageDocument in chatListSnapshot.docs) {
          chatList.add(ChattingModel(
            id: chatMessageDocument[ChatStrings.id],
            type: chatMessageDocument[ChatStrings.messageType],
            userId: int.parse(myUserId),
            senderId: chatMessageDocument[ChatStrings.senderId],
            text: chatMessageDocument[ChatStrings.text],
            image: chatMessageDocument[ChatStrings.imageUrl],
            video: chatMessageDocument[ChatStrings.videoUrl],
            time: chatMessageDocument[ChatStrings.createdAt],
          ));
        }

        notifyListeners();
      });
    }
    return c.stream;
  }

  bool isDateToday(DateTime date) {
    final now = DateTime.now();
    final inputDate = DateTime(date.year, date.month, date.day);

    return now.year == inputDate.year &&
        now.month == inputDate.month &&
        now.day == inputDate.day;
  }

  getDocumentId(String userId,bool once) async {
    List<int> ids = [int.parse(myUserId), int.parse(userId)];

    FirebaseFirestore.instance
        .collection(ChatStrings.chatsCollectionReference)
        .where(ChatStrings.userIds, arrayContainsAny: ids)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          var idsFromJson = doc.get(ChatStrings.userIds);

          List<int> idsList = List<int>.from(idsFromJson);
          Function unOrdDeepEq =
              const DeepCollectionEquality.unordered().equals;

          if (unOrdDeepEq(idsList, ids) == true) {
            documentId = doc.id;
            if(once){
              sendPush(userId);
            }
            observeChatData();
            markMessagesRead();
            break;
          }
        }
      } else {
        return "";
      }
      getChatMessages();
      notifyListeners();
      return documentId;
    });
  }

  void markMessagesRead() async {
    if (documentId.isNotEmpty) {
      final CollectionReference threadsCollection = FirebaseFirestore.instance
          .collection(ChatStrings.chatsCollectionReference)
          .doc(documentId)
          .collection(ChatStrings.threadsCollectionReference);

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final QuerySnapshot querySnapshot = await threadsCollection
          .where(ChatStrings.senderId, isNotEqualTo: int.parse(myUserId))
          .get();
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        batch.update(document.reference, {ChatStrings.isRead: true});
      });

      await batch.commit();
    }
  }

  void observeChatData() {

    if (documentId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection(ChatStrings.chatsCollectionReference)
          .doc(documentId)
          .snapshots()
          .listen((chatDetailSnapshot) {
        print("observe");
        chatDetail = ChatDetail.fromJson(chatDetailSnapshot.data()!);
        updateBlockStatus();
        messageTextFieldStatus();

      });
    }
  }

  FirebaseUserModel? _user;
  FirebaseUserModel? get user => _user;

  void listenToUser(userId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _user = FirebaseUserModel.fromFirestore(snapshot.data()!, snapshot.id);
        notifyListeners(); // Notify listeners about the change
      } else {
        _user = null; // User not found
        notifyListeners();
      }
    });
  }

  sendMessage(String message, int type) async {

    print("farhan");
    print(message);
    print(documentId);
    print("${type}");
    FirestoreController.instance.saveMsgToChatRoom(
        documentId.isNotEmpty ? documentId : null,
        myUserId,
        userId,
        message,
        type,
        "",
        "");
    if(documentId.isNotEmpty) {
      sendPush(userId);
    }

    msgTextController.text = "";
    msgTextController.text.isEmpty
        ? isMessageSend = false
        : isMessageSend = true;

    try {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    } catch (e) {}
    if(documentId.isEmpty){
      await getDocumentId(userId,true);
    }
    notifyListeners();
  }

  void pickImageFromCamera() async {
    final pickedFile = await FilePickerUtil.pickImages(pickerType: PickerType.camera);
    if (pickedFile != null && pickedFile.isNotEmpty) {
      for(var item in pickedFile){

        File? fileImage = File("");
        fileImage = File(item.path!);
        sendAttachments(NavigationService.navigatorKey.currentContext, fileImage, item.path!, ChatStrings.messageTypeImage,"");
        messageFocusNode.unfocus();
        msgTextController.text = "";
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });

      }

    }
  }

  void pickMediaFromGallery() async {
    final pickedFile = await FilePickerUtil.pickMedia();

    if (pickedFile != null && pickedFile.isNotEmpty) {
      for(var item in pickedFile){
        File? fileImage = File("");
        fileImage = File(item.path!);
        if(item.galleryMode == GalleryMode.video){
          print(item.thumbPath);
          print(fileImage);
          sendAttachments(NavigationService.navigatorKey.currentContext,fileImage, item.path!, ChatStrings.messageTypeVideo,File(item.thumbPath!));
        }else{
          print(item.path);
          print(fileImage);
          sendAttachments(NavigationService.navigatorKey.currentContext,fileImage, item.path!, ChatStrings.messageTypeImage,"");

        }
        messageFocusNode.unfocus();
        msgTextController.text = "";
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      }
    }
  }

  sendMediaMessage(String message,int type,String url,String thumbnail) async {

    FirestoreController.instance.saveMsgToChatRoom(
        documentId.isNotEmpty ? documentId : null,
        myUserId,
        userId,
        message,
        type,
        thumbnail,
        url);

    if(documentId.isNotEmpty) {
      sendPush(userId);
    };
    msgTextController.text = "";
    msgTextController.text.isEmpty
        ? isMessageSend = false
        : isMessageSend = true;

    try {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    } catch (e) {}
    if(documentId.isEmpty){
      await getDocumentId(userId,true);
    }
    notifyListeners();
  }

  Future<void> blockUnBlockUser(context) async {
    if (documentId.isNotEmpty) {

      var chatDetail = await FirebaseFirestore.instance
          .collection(ChatStrings.chatsCollectionReference)
          .doc(documentId)
          .get();

      List<dynamic> blockedStatuses = chatDetail.get(ChatStrings.blockedStatuses);
      for (var blockedStatus in blockedStatuses) {

        if (blockedStatus[ChatStrings.id] != int.parse(myUserId)) {

          if(isBlockedByMe){
            isBlockedByMe = false;
            blockedStatus[ChatStrings.isBlocked] = isBlockedByMe;
            unBlockUser(context,userId);
          }else{
            isBlockedByMe = true;
            blockedStatus[ChatStrings.isBlocked] = isBlockedByMe;
            blockUser(context,userId);
          }


        }
      }
      await FirebaseFirestore.instance
          .collection(ChatStrings.chatsCollectionReference)
          .doc(documentId)
          .update({
        ChatStrings.blockedStatuses: blockedStatuses,
      });
      notifyListeners();
    }
  }

  Future<void> updateBlockStatus() async {

    var chatDetail = await FirebaseFirestore.instance
        .collection(ChatStrings.chatsCollectionReference)
        .doc(documentId)
        .get();

    List<dynamic> blockedStatuses =
    chatDetail.get(ChatStrings.blockedStatuses);
    ///Setting block/unblock to bottom sheet
    for (var blockedStatus in blockedStatuses) {
      if (blockedStatus[ChatStrings.id] != int.parse(myUserId)) {
        isBlockedByMe = blockedStatus[ChatStrings.isBlocked];
        notifyListeners();

      }if (blockedStatus[ChatStrings.id] == int.parse(myUserId)) {
        isBlockedByOther = blockedStatus[ChatStrings.isBlocked];
        notifyListeners();

      }
    }

  }

  Future<void> messageTextFieldStatus() async {

    var chatDetail = await FirebaseFirestore.instance
        .collection(ChatStrings.chatsCollectionReference)
        .doc(documentId)
        .get();

    List<dynamic> blockedStatuses =
    chatDetail.get(ChatStrings.blockedStatuses);

    for (var blockedStatus in blockedStatuses) {
      /*if (blockedStatus[ChatStrings.id] == int.parse(myUserId) && blockedStatus[ChatStrings.isBlocked]) {
        isBlockedByOther = true;

      }else if (blockedStatus[ChatStrings.id] != int.parse(myUserId) && blockedStatus[ChatStrings.isBlocked]) {
        isBlockedByMe = true;
      }*/

      if (blockedStatus[ChatStrings.id] != int.parse(myUserId)) {
        isBlockedByMe = blockedStatus[ChatStrings.isBlocked];

      }else if (blockedStatus[ChatStrings.id] == int.parse(myUserId)) {
        isBlockedByOther = blockedStatus[ChatStrings.isBlocked];

      }
    }

    if(isBlockedByOther && isBlockedByMe){
      blockMessage = "You are blocked by  ${user!.name}";
    }else if(isBlockedByOther){
      blockMessage = "You are blocked by  ${user!.name}";
    }else if(isBlockedByMe){
      blockMessage = "You blocked ${user!.name}";
    }
    notifyListeners();

  }

  ChatHttpApiRepository chatRepo = ChatHttpApiRepository();

  final List<File>  mediaFiles = [];
  var thumbnailUrl = "";
  Future<void> sendAttachments(context,file,path,type,thumbnail) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    Map<String,String> data = {};
    try {
      mediaFiles.clear();
      mediaFiles.add(file);
      int totalSize = await calculateTotalFileSize(mediaFiles);
      if(convertBytesToMB(totalSize)<=25){
        notifyListeners();
        var response = await chatRepo.sendAttachmentsApi( data, headers, mediaFiles, "file");
        if (response["status"]) {
          print(response.toString());
          List<dynamic> medialist = response['data']['media_lst'];
          mediaFiles.clear();
          print(medialist.toString());
          for(var item in medialist){
            if(type == ChatStrings.messageTypeImage){
              sendMediaMessage(p.basename(path), ChatStrings.messageTypeImage, "${AppUrl.baseUrl}$item","");
            }else{
              sendVideoAttachments(context,"${AppUrl.baseUrl}$item",path,thumbnail);

            }
          }

          notifyListeners();
        }
      }else{
        Utils.toastMessage("Your file is too large. Please keep it under 25MB.");
      }
    } catch (error) {
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      Navigator.pop(context);
    }
  }
  Future<void> sendVideoAttachments(context,fileUrl,path,thumbnail) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    Map<String,String> data = {};
    try {
      mediaFiles.add(thumbnail);
      notifyListeners();
      var response = await chatRepo.sendAttachmentsApi( data, headers, mediaFiles, "file");
      if (response["status"]) {
        print(response.toString());
        List<dynamic> medialist = response['data']['media_lst'];
        mediaFiles.clear();
        print(medialist.toString());
        thumbnailUrl = "${AppUrl.baseUrl}${medialist.first}";
        sendMediaMessage(p.basename(path), ChatStrings.messageTypeVideo, fileUrl,thumbnailUrl);
        notifyListeners();
      }
    } catch (error) {
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      Navigator.pop(context);
    }
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
      dynamic response = await chatRepo.unblockUser(
        data: jsonEncode(data),
        headers: headers,
      );
    } catch (error) {
      Utils.toastMessage(error.toString());
    }finally{

      notifyListeners();
    }
  }
  Future<void> blockUser(BuildContext context, String id) async {
    // Show loading dialog

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
      dynamic response = await chatRepo.blockUser(
        data: jsonEncode(data),
        headers: headers,
      );
    } catch (error) {
      Utils.toastMessage(error.toString());
    }finally{

      notifyListeners();
    }
  }
  Future<void> sendPush( String id) async {
    // Show loading dialog

    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "document_id": documentId,
      "receiver_id": id,
    };
    print("data:" + data.toString());
    try {
      dynamic response = await chatRepo.sendPush(
        data: jsonEncode(data),
        headers: headers,
      );
    } catch (error) {
      Utils.toastMessage(error.toString());
    }finally{

      notifyListeners();
    }
  }


}
class AttachmentResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  AttachmentResponseModel(
      {this.status, this.statusCode, this.message, this.data});

  AttachmentResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? mediaLst;

  Data({this.mediaLst});

  Data.fromJson(Map<String, dynamic> json) {
    mediaLst = json['media_lst'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_lst'] = this.mediaLst;
    return data;
  }
}

Future<int> calculateTotalFileSize(List<File> files) async {
  int totalSize = 0;

  for (var file in files) {
    try {
      // Get the size of the file in bytes
      int fileSize = await file.length();
      totalSize += fileSize;
    } catch (e) {
      print("Error getting size for file: ${file.path}, error: $e");
    }
  }

  return totalSize;
}

double convertBytesToMB(int bytes) {
  return bytes / (1024 * 1024); // Convert bytes to megabytes
}
