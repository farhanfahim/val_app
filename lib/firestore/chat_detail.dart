import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDetail {
  ChatDetail({
    this.createdAt,
    this.updatedAt,
    this.lastMessage,
    this.name,
    this.userIds,
  });

  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? lastMessage;
  String? name;
  List<int>? userIds;

  factory ChatDetail.fromJson(Map<String, dynamic> json) => ChatDetail(
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    lastMessage: json["last_message"],
    name: json["name"],
    userIds: List<int>.from(json["users_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt,
    "updated_at": updatedAt,
    "last_message": lastMessage,
    "name": name,
    "users_ids": userIds?.map((e) => e).toList(),
  };
}

class DeletedStatus {
  DeletedStatus({
    this.id,
    this.isDeleted,
  });

  int? id;
  bool? isDeleted;

  factory DeletedStatus.fromJson(Map<String, dynamic> json) => DeletedStatus(
    id: json["id"],
    isDeleted: json["is_deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_deleted": isDeleted,
  };
}

class ReadStatus {
  ReadStatus({
    this.id,
    this.isRead,
  });

  int? id;
  bool? isRead;

  factory ReadStatus.fromJson(Map<String, dynamic> json) => ReadStatus(
    id: json["id"],
    isRead: json["is_read"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_read": isRead,
  };
}
class BlockedStatuses {
  BlockedStatuses({
    this.id,
    this.isBlocked,
  });

  int? id;
  bool? isBlocked;

  factory BlockedStatuses.fromJson(Map<String, dynamic> json) => BlockedStatuses(
    id: json["id"],
    isBlocked: json["is_blocked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_blocked": isBlocked,
  };
}

class GroupMessageStatuses {
  GroupMessageStatuses({
    this.id,
    this.isGroupMessageDeleted,
  });

  int? id;
  bool? isGroupMessageDeleted;

  factory GroupMessageStatuses.fromJson(Map<String, dynamic> json) => GroupMessageStatuses(
    id: json["id"],
    isGroupMessageDeleted: json["is_group_message_deleted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_group_message_deleted": isGroupMessageDeleted,
  };
}

class DeletedMessageId {
  DeletedMessageId({
    this.id,
    this.deletedMessageId,
  });

  int? id;
  String? deletedMessageId;

  factory DeletedMessageId.fromJson(Map<String, dynamic> json) => DeletedMessageId(
    id: json["id"],
    deletedMessageId: json["deleted_message_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deleted_message_id": deletedMessageId,
  };
}
