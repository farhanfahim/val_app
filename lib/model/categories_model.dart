class CategoriesModel {
  bool? status;
  int? statusCode;
  String? message;
  List<CategoriesData>? data;

  CategoriesModel({this.status, this.statusCode, this.message, this.data});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["status_code"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => CategoriesData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["status_code"] = statusCode;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class CategoriesData {
  int? id;
  String? category;
  bool? isSelected = false;

  CategoriesData({this.id,this.isSelected, this.category});

  CategoriesData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    category = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = category;
    return _data;
  }
}
