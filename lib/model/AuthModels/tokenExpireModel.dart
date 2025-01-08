class TokenExpireModel {
  String? detail;
  String? code;
  List<Messages>? messages;

  TokenExpireModel({this.detail, this.code, this.messages});

  TokenExpireModel.fromJson(Map<String, dynamic> json) {
    detail = json["detail"];
    code = json["code"];
    messages = json["messages"] == null ? null : (json["messages"] as List).map((e) => Messages.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["detail"] = detail;
    _data["code"] = code;
    if (messages != null) {
      _data["messages"] = messages?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Messages {
  String? tokenClass;
  String? tokenType;
  String? message;

  Messages({this.tokenClass, this.tokenType, this.message});

  Messages.fromJson(Map<String, dynamic> json) {
    tokenClass = json["token_class"];
    tokenType = json["token_type"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["token_class"] = tokenClass;
    _data["token_type"] = tokenType;
    _data["message"] = message;
    return _data;
  }
}
