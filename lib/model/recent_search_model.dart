class RecentSearchModel {
  bool? status;
  String? message;
  List<RecentData>? data;

  RecentSearchModel({this.status, this.message, this.data});

  RecentSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RecentData>[];
      json['data'].forEach((v) {
        data!.add(new RecentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentData {
  int? searchId;
  String? searchTag;
  String? createdOn;

  RecentData({this.searchId, this.searchTag, this.createdOn});

  RecentData.fromJson(Map<String, dynamic> json) {
    searchId = json['search_id'];
    searchTag = json['search_tag'];
    createdOn = json['created_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_id'] = this.searchId;
    data['search_tag'] = this.searchTag;
    data['created_on'] = this.createdOn;
    return data;
  }
}
