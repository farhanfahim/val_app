class TermsModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  TermsModel({this.status, this.statusCode, this.message, this.data});

  TermsModel.fromJson(Map<String, dynamic> json) {
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
  String? text;
  String? createdOn;

  Data({this.text, this.createdOn});

  Data.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['created_on'] = this.createdOn;
    return data;
  }
}
