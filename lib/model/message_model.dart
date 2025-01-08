
import '../configs/app_urls.dart';

class Data {
  int? id;
  int? profileId;
  String? name;
  String? firestoreId;
  bool? isMute;
  List<Message>? message;
  bool? verify;
  bool? isBlocked;
  String? image;
  String? statusId;

  Data(
      {this.id,
      this.name,
      this.firestoreId,
      this.isMute,
      this.message,
      this.verify,
      this.image,
      this.statusId,
      this.profileId,
      this.isBlocked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    name = json['name'];
    firestoreId = json['firestore_id'];
    isMute = json['is_mute'];
    isBlocked = json['is_blocked'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(new Message.fromJson(v));
      });
    }
    verify = json['verify'];
    image = json['chat_image'] == null
        ? "https://raysensenbach.com/wp-content/uploads/2013/04/default.jpg"
        : AppUrl.baseUrl + json['chat_image'];
    statusId = json['status_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['name'] = this.name;
    data['firestore_id'] = this.firestoreId;
    data['is_mute'] = this.isMute;
    data['is_blocked'] = this.isBlocked;
    if (this.message != null) {
      data['message'] = this.message!.map((v) => v.toJson()).toList();
    }
    data['verify'] = this.verify;
    data['image'] = this.image;
    data['status_id'] = this.statusId;
    return data;
  }
}

class Message {
  int? id;
  String? message;
  String? chatMedia;
  String? createdAt;
  String? type;
  int? sender;
  int? reciepient;
  int? iGroup;
  String? direction;

  Message(
      {this.id,
      this.message,
      this.chatMedia,
      this.createdAt,
      this.type,
      this.sender,
      this.reciepient,
      this.iGroup,
      this.direction});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    chatMedia = json['chat_media'];
    createdAt = json['created_at'];
    type = json['type'];
    sender = json['sender'];
    reciepient = json['reciepient'];
    iGroup = json['i_group'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['chat_media'] = this.chatMedia;
    data['created_at'] = this.createdAt;
    data['type'] = this.type;
    data['sender'] = this.sender;
    data['reciepient'] = this.reciepient;
    data['i_group'] = this.iGroup;
    data['direction'] = this.direction;
    return data;
  }
}

class MessageModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  MessageModel({this.status, this.statusCode, this.message, this.data});

  MessageModel.fromJson(Map<String, dynamic> json) {
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
