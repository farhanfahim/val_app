class CreateProfileModel {
  String? mainImage;
  String? coverImage;
  String? username;
  String? city;
  String? country;
  String? state;
  String? about;

  CreateProfileModel({this.mainImage, this.coverImage, this.username, this.city, this.country, this.state, this.about});

  // CreateProfileModel.fromJson(Map<String, dynamic> json) {
  //   mainImage = json["main_image"];
  //   coverImage = json["cover_image"];
  //   username = json["username"];
  //   city = json["city"];
  //   country = json["country"];
  //   state = json["state"];
  //   about = json["about"];
  // }
  CreateProfileModel.fromJson(Map<String, dynamic> json) {
    mainImage = json["main_image"] as String? ?? "";
    coverImage = json["cover_image"] as String? ?? "";
    username = json["username"] as String? ?? "";
    city = json["city"] as String? ?? "";
    country = json["country"] as String? ?? "";
    state = json["state"] as String? ?? "";
    about = json["about"] as String? ?? "";
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["main_image"] = mainImage;
    _data["cover_image"] = coverImage;
    _data["username"] = username;
    _data["city"] = city;
    _data["country"] = country;
    _data["state"] = state;
    _data["about"] = about;
    return _data;
  }
}

class FilteredSkillsModel {
  bool? status;
  List<FilteredSkillsDataList>? data;

  FilteredSkillsModel({this.status, this.data});

  FilteredSkillsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FilteredSkillsDataList>[];
      json['data'].forEach((v) {
        data!.add(new FilteredSkillsDataList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilteredSkillsDataList {
  int? id;
  String? skills;
  int? iOccupations;

  FilteredSkillsDataList({this.id, this.skills, this.iOccupations});

  FilteredSkillsDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skills = json['skills'];
    iOccupations = json['i_occupations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['skills'] = this.skills;
    data['i_occupations'] = this.iOccupations;
    return data;
  }
}
