class InterestModel {
  bool? status;
  int? statusCode;
  String? message;
  List<InterestData>? interestData;

  InterestModel({this.status, this.statusCode, this.message, this.interestData});

  InterestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      interestData = <InterestData>[];
      json['data'].forEach((v) {
        interestData!.add(new InterestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.interestData != null) {
      data['data'] = this.interestData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InterestData {
  int? id;
  String? name;
  String? image;

  InterestData({this.id, this.name, this.image});

  InterestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
