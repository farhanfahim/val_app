class SkillsModel {
  bool? status;
  int? statusCode;
  String? message;
  List<SkilList>? data;

  SkillsModel({this.status, this.statusCode, this.message, this.data});

  SkillsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    statusCode = json["status_code"];
    message = json["message"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => SkilList.fromJson(e)).toList();
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

class SkilList {
  int? id;
  String? toolSkills;

  SkilList({this.id, this.toolSkills});

  SkilList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    toolSkills = json["tool_skills"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["tool_skills"] = toolSkills;
    return _data;
  }
}
