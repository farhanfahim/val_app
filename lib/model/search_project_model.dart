class SearchProjectModel {
  bool? status;
  String? message;
  SearchData? data;

  SearchProjectModel({this.status, this.message, this.data});

  SearchProjectModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SearchData {
  List<Projects>? projects;

  SearchData({this.projects});

  SearchData.fromJson(Map<String, dynamic> json) {
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(new Projects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Projects {
  int? projectId;
  String? projectTitle;
  String? coverMedia;

  Projects({this.projectId, this.projectTitle, this.coverMedia});

  Projects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    projectTitle = json['project_title'];
    coverMedia = json['cover_media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['project_title'] = this.projectTitle;
    data['cover_media'] = this.coverMedia;
    return data;
  }
}
