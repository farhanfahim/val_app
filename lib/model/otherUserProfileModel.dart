
class OtherUserProfileModel {
  String? status;
  Data? data;

  OtherUserProfileModel({this.status, this.data});

  OtherUserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class Data {
  String? mainImage;
  String? coverImage;
  String? username;
  String? city;
  List<Occupations>? occupations;
  List<Skills>? skills;
  String? about;
  int? userId;
  int? id;
  int? totalProjectViews;
  int? totalProjectLikes;
  int? totalFollowers;
  int? totalFollowing;
  bool? isFollowing;
  List<Projects>? projects;

  Data(
      {this.mainImage,
        this.coverImage,
        this.username,
        this.city,
        this.occupations,
        this.skills,
        this.about,
        this.id,
        this.userId,
        this.totalProjectViews,
        this.totalProjectLikes,
        this.totalFollowers,
        this.totalFollowing,
        this.isFollowing,
        this.projects});

  Data.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    coverImage = json['cover_image'];
    username = json['username'];
    city = json['city'];
    if (json['occupations'] != null) {
      occupations = <Occupations>[];
      json['occupations'].forEach((v) {
        occupations!.add(new Occupations.fromJson(v));
      });
    }
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(new Skills.fromJson(v));
      });
    }
    about = json['about'];
    id = json['id'];
    userId = json['user_id'];
    totalProjectViews = json['total_project_views'];
    totalProjectLikes = json['total_project_likes'];
    totalFollowers = json['total_followers'];
    totalFollowing = json['total_following'];
    isFollowing = json['is_following'];
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(new Projects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['cover_image'] = this.coverImage;
    data['username'] = this.username;
    data['city'] = this.city;
    if (this.occupations != null) {
      data['occupations'] = this.occupations!.map((v) => v.toJson()).toList();
    }
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v.toJson()).toList();
    }
    data['about'] = this.about;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['total_project_views'] = this.totalProjectViews;
    data['total_project_likes'] = this.totalProjectLikes;
    data['total_followers'] = this.totalFollowers;
    data['total_following'] = this.totalFollowing;
    data['is_following'] = this.isFollowing;
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Occupations {
  int? id;
  String? occupations;

  Occupations({this.id, this.occupations});

  Occupations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occupations = json['occupations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['occupations'] = this.occupations;
    return data;
  }
}

class Skills {
  int? id;
  String? tool;

  Skills({this.id, this.tool});

  Skills.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tool = json['tool'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool'] = this.tool;
    return data;
  }
}



class Projects {
  int? projectId;
  String? title;
  String? coverMedia;

  Projects({this.projectId, this.title, this.coverMedia});

  Projects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    coverMedia = json['cover_media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['cover_media'] = this.coverMedia;
    return data;
  }
}





