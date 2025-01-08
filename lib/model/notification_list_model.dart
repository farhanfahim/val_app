class NotificationListModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? notificationData;

  NotificationListModel(
      {this.status, this.statusCode, this.message, this.notificationData});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      notificationData = <Data>[];
      json['data'].forEach((v) {
        notificationData!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.notificationData != null) {
      data['data'] =
          this.notificationData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? createdOn;
  String? type;
  String? notification;
  String? title;
  bool? isRead;
  bool? action;
  Content? content;
  int? recieverProfile;

  Data(
      {this.id,

        this.createdOn,
        this.type,
        this.notification,
        this.title,
        this.isRead,
        this.action,
        this.content,
        this.recieverProfile});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    createdOn = json['created_on'];
    type = json['type'];
    notification = json['notification'];
    title = json['title'];
    isRead = json['is_read'];
    action = json['action'];
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    recieverProfile = json['reciever_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['created_on'] = this.createdOn;
    data['type'] = this.type;
    data['notification'] = this.notification;
    data['title'] = this.title;
    data['is_read'] = this.isRead;
    data['action'] = this.action;
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['reciever_profile'] = this.recieverProfile;
    return data;
  }
}


class Content {
  String? type;
  String? valProfile;
  String? projectId;

  Content({this.type,this.valProfile,this.projectId});

  Content.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    valProfile = json['val_profile'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['val_profile'] = this.valProfile;
    data['project_id'] = this.projectId;
    return data;
  }
}