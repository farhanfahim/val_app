

import '../configs/app_urls.dart';

class Data {
  String? firestoreId;
  List<GroupList>? groupList;
  List<String>? statusId;
  bool? isNotify;

  Data({this.firestoreId, this.groupList, this.statusId,this.isNotify});

  Data.fromJson(Map<String, dynamic> json) {
    firestoreId = json['firestore_id'];
    if (json['group_list'] != null) {
      groupList = <GroupList>[];
      json['group_list'].forEach((v) {
        groupList!.add(new GroupList.fromJson(v));
      });
    }
    statusId = json['status_id'].cast<String>();
    isNotify = json['is_notified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firestore_id'] = this.firestoreId;
    if (this.groupList != null) {
      data['group_list'] = this.groupList!.map((v) => v.toJson()).toList();
    }
    data['status_id'] = this.statusId;
    data['is_notified'] = this.isNotify;
    return data;
  }
}

class FriendsModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  FriendsModel({this.status, this.statusCode, this.message, this.data});

  FriendsModel.fromJson(Map<String, dynamic> json) {
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

class GroupList {
  int? id;
  String? groupName;
  String? createdAt;
  String? type;
  String? groupImage;
  int? createdBy;
  int? userId;
  String? lastMessage;
  String? messageTime;
  int? unread;
  bool? verify;

  GroupList(
      {this.id,
      this.groupName,
      this.createdAt,
      this.type,
      this.groupImage,
      this.createdBy,
      this.userId,
      this.lastMessage,
      this.messageTime,
      this.unread,
      this.verify});

  GroupList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    createdAt = json['created_at'];
    type = json['type'];
    groupImage = json['group_image'] == null
        ? "https://raysensenbach.com/wp-content/uploads/2013/04/default.jpg"
        : AppUrl.baseUrl + json['group_image'];
    createdBy = json['created_by'];
    userId = json['user_id'];
    lastMessage = json['last_message'];
    messageTime = json['message_time'];
    unread = json['unread'];
    verify = json['verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['group_name'] = this.groupName;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['group_image'] = this.groupImage;
    data['created_by'] = this.createdBy;
    data['user_id'] = this.userId;
    data['last_message'] = this.lastMessage;
    data['message_time'] = this.messageTime;
    data['unread'] = this.unread;
    data['verify'] = this.verify;
    return data;
  }
}
