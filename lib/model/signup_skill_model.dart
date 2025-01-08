class SignupSkillsModel {
  String? status;
  List<SignupSkillsData>? data;

  SignupSkillsModel({this.status, this.data});

  SignupSkillsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SignupSkillsData>[];
      json['data'].forEach((v) {
        data!.add(new SignupSkillsData.fromJson(v));
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

class SignupSkillsData {
  int? id;
  String? tool;
  int? iCategory;

  SignupSkillsData({this.id, this.tool, this.iCategory});

  SignupSkillsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tool = json['tool'];
    iCategory = json['i_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool'] = this.tool;
    data['i_category'] = this.iCategory;
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignupSkillsData && other.id == id; // Compare based on `id`
  }

  @override
  int get hashCode => id.hashCode;
}
