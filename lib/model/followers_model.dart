class FollowersFollowingModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  FollowersFollowingModel({this.status, this.statusCode, this.message, this.data});

  FollowersFollowingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Followers>? followers;
  List<Following>? following;

  Data({this.followers, this.following});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(new Followers.fromJson(v));
      });
    }
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(new Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  int? id;
  String? username;
  String? mainImage;
  bool? isFollow;

  Followers({this.id, this.username, this.mainImage});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    mainImage = json['main_image'];
    isFollow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['is_follow'] = this.isFollow;
    return data;
  }
}

class Following {
  int? id;
  String? username;
  String? mainImage;
  bool? isFollow;

  Following({this.id, this.username, this.mainImage});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    mainImage = json['main_image'];
    isFollow = json['is_follow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['is_follow'] = this.isFollow;
    return data;
  }
}
