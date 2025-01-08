class ChatHomeModel {
  bool? status;
  num? statusCode;
  String? message;
  Data? data;

  ChatHomeModel({this.status, this.statusCode, this.message, this.data});

  ChatHomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'status_code': statusCode,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  String? firestoreId;
  List<String>? ids;
  List<GroupList>? groupList;

  Data({this.firestoreId, this.ids, this.groupList});

  Data.fromJson(Map<String, dynamic> json) {
    firestoreId = json['firestore_id'];
    ids = json['status_id'] != null ? List<String>.from(json['status_id']) : [];
    groupList = json['group_list'] != null ? List<GroupList>.from(json['group_list'].map((v) => GroupList.fromJson(v))) : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'firestore_id': firestoreId,
      'status_id': ids,
      'group_list': groupList?.map((v) => v.toJson()).toList(),
    };
  }
}

class GroupList {
  num? id;
  String? groupName;
  String? createdAt;
  String? type;
  dynamic groupImage;
  num? createdBy;
  num? userId;
  String? lastMessage;
  String? messageTime;
  String? subject;
  String? userName;
  num? unread;

  GroupList({
    this.id,
    this.groupName,
    this.createdAt,
    this.type,
    this.groupImage,
    this.createdBy,
    this.userId,
    this.lastMessage,
    this.messageTime,
    this.subject,
    this.userName,
    this.unread,
  });

  GroupList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupName = json['group_name'];
    createdAt = json['created_at'];
    type = json['type'];
    groupImage = json['group_image'];
    createdBy = json['created_by'];
    userId = json['user_id'];
    lastMessage = json['last_message'];
    messageTime = json['message_time'];
    subject = json['subject'];
    userName = json['user_name'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_name': groupName,
      'created_at': createdAt,
      'type': type,
      'group_image': groupImage,
      'created_by': createdBy,
      'user_id': userId,
      'last_message': lastMessage,
      'message_time': messageTime,
      'subject': subject,
      'user_name': userName,
      'unread': unread,
    };
  }
}
