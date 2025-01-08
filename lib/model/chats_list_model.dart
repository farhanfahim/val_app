class ChatListModel {
  bool? status;
  num? statusCode;
  String? message;
  ChatData? data;

  ChatListModel({this.status, this.statusCode, this.message, this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? ChatData.fromJson(json['data']) : null;
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

class ChatData {
  num? id;
  String? name;
  String? firestoreId;
  bool? isMute;
  bool? isBlocked;
  bool? isFriend;
  List<ChatMessage>? message;

  ChatData({
    this.id,
    this.name,
    this.firestoreId,
    this.isMute,
    this.isBlocked,
    this.isFriend,
    this.message,
  });

  ChatData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isMute = json['is_mute'];
    isBlocked = json['is_blocked'];
    isFriend = json['is_friend'];
    firestoreId = json['firestore_id'];
    if (json['message'] != null) {
      message = List<ChatMessage>.from(
        json['message'].map((v) => ChatMessage.fromJson(v)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_mute': isMute,
      'is_blocked': isBlocked,
      'is_friend': isFriend,
      'firestore_id': firestoreId,
      'message': message?.map((v) => v.toJson()).toList(),
    };
  }
}

class ChatMessage {
  num? id;
  String? message;
  MediaFileData? chatMedia;
  String? createdAt;
  String? type;
  num? sender;
  num? recipient;
  num? iGroup;
  String? direction;

  ChatMessage({
    this.id,
    this.message,
    this.chatMedia,
    this.createdAt,
    this.type,
    this.sender,
    this.recipient,
    this.iGroup,
    this.direction,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    chatMedia = json['chat_media'] != null ? MediaFileData.fromJson(json['chat_media']) : null;
    createdAt = json['created_at'];
    type = json['type'];
    sender = json['sender'];
    recipient = json['reciepient'];
    iGroup = json['i_group'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'chat_media': chatMedia?.toJson(),
      'created_at': createdAt,
      'type': type,
      'sender': sender,
      'reciepient': recipient,
      'i_group': iGroup,
      'direction': direction,
    };
  }
}

class MediaFileData {
  String? filePath;

  MediaFileData({this.filePath});

  MediaFileData.fromJson(Map<String, dynamic> json) {
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    return {
      'file_path': filePath,
    };
  }
}
