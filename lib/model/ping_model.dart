class PingModel {
  Data? data;
  String? message;
  bool? status;
  int? statusCode;

  PingModel({this.data, this.message, this.status, this.statusCode});

  PingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int? iProfile;
  String? lastActive;
  bool? isActive;

  Data({this.iProfile, this.lastActive, this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    iProfile = json['i_profile'];
    lastActive = json['last_active'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['i_profile'] = this.iProfile;
    data['last_active'] = this.lastActive;
    data['is_active'] = this.isActive;
    return data;
  }
}
