class ToolsModel {
  String? status;
  List<ToolsDataList>? data;

  ToolsModel({this.status, this.data});

  ToolsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => ToolsDataList.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class ToolsDataList {
  int? id;
  String? tool;
  bool? isSelected = false;
  var iCategory;

  ToolsDataList({this.id, this.isSelected,this.tool, this.iCategory});

  ToolsDataList.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    tool = json["tool"];
    iCategory = json["i_category"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["tool"] = tool;
    _data["i_category"] = iCategory;
    return _data;
  }
}
