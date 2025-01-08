class FilterCategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  List<FilterCategoryData>? data;

  FilterCategoryModel({this.status, this.statusCode, this.message, this.data});

  FilterCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FilterCategoryData>[];
      json['data'].forEach((v) {
        data!.add(new FilterCategoryData.fromJson(v));
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

class FilterCategoryData {
  int? id;
  String? category;
  bool? isSelected;
  List<CatTools>? tools;

  FilterCategoryData({this.id, this.category, this.isSelected, this.tools});

  FilterCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    isSelected = json['is_selected'];
    if (json['tools'] != null) {
      tools = <CatTools>[];
      json['tools'].forEach((v) {
        tools!.add(new CatTools.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['is_selected'] = this.isSelected;
    if (this.tools != null) {
      data['tools'] = this.tools!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CatTools {
  int? id;
  String? tool;
  bool? isSelected;

  CatTools({this.id, this.tool, this.isSelected});

  CatTools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tool = json['tool'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool'] = this.tool;
    data['is_selected'] = this.isSelected;
    return data;
  }
}