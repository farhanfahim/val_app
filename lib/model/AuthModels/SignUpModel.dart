class SignupModel {
  int? statusCode;
  bool? status;
  String? message;
  Data? data;

  SignupModel({this.statusCode, this.status, this.message, this.data});

  SignupModel.fromJson(Map<String, dynamic> json) {
    statusCode = json["status_code"];
    status = json["status"];
    message = json["message"];
    data = json["data"] == null ? null : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status_code"] = statusCode;
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? userId;
  String? email;
  String? fullName;
  String? access;
  String? refresh;
  String? phoneNumber;
  String? role;

  Data({this.userId,this.email, this.fullName, this.access, this.refresh, this.phoneNumber, this.role});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json["user_id"];
    email = json["email"];
    fullName = json["full_name"];
    access = json["access"];
    refresh = json["refresh"];
    phoneNumber = json["phone_number"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["user_id"] = userId;
    _data["email"] = email;
    _data["full_name"] = fullName;
    _data["access"] = access;
    _data["refresh"] = refresh;
    _data["phone_number"] = phoneNumber;
    _data["role"] = role;
    return _data;
  }
}
