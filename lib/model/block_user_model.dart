class BlockUserModel {
  bool? status;
  int? statusCode;
  String? message;
  List<Data>? data;

  BlockUserModel({this.status, this.statusCode, this.message, this.data});

  BlockUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? blockId;
  String? username;
  String? mainImage;

  Data({this.blockId, this.username, this.mainImage});

  Data.fromJson(Map<String, dynamic> json) {
    blockId = json['block_id'];
    username = json['username'];
    mainImage = json['main_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['block_id'] = this.blockId;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    return data;
  }
}