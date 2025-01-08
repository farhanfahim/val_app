class OccupationModel {
  bool? status;
  int? statusCode;
  String? message;
  List<OccupationList>? data;

  OccupationModel({this.status, this.statusCode, this.message, this.data});

  OccupationModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["status_code"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => OccupationList.fromJson(e)).toList();
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

class OccupationList {
  int? id;
  String? occupations;

  OccupationList({this.id, this.occupations});

  OccupationList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    occupations = json["occupations"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["occupations"] = occupations;
    return _data;
  }
}
