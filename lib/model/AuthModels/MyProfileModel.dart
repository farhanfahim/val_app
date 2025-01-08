class MyProfileModel {
  bool? status;
  int? statusCode;
  String? message;
  Data? data;

  MyProfileModel({this.status, this.statusCode, this.message, this.data});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
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
  Profile? profile;
  ValProfile? valProfile;
  List<Skills>? skills;
  List<Occupations>? occupations;
  List<PostedProjects>? postedProjects;
  List<DraftedProjects>? draftedProjects;
  int? totalLikes;
  int? totalViews;
  int? totalFollowers;
  int? totalFollowing;

  Data({this.profile, this.valProfile, this.skills, this.occupations, this.postedProjects, this.draftedProjects, this.totalLikes, this.totalViews, this.totalFollowers, this.totalFollowing});

  Data.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    valProfile = json['val_profile'] != null ? new ValProfile.fromJson(json['val_profile']) : null;
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(new Skills.fromJson(v));
      });
    }
    if (json['occupations'] != null) {
      occupations = <Occupations>[];
      json['occupations'].forEach((v) {
        occupations!.add(new Occupations.fromJson(v));
      });
    }
    if (json['posted_projects'] != null) {
      postedProjects = <PostedProjects>[];
      json['posted_projects'].forEach((v) {
        postedProjects!.add(new PostedProjects.fromJson(v));
      });
    }
    if (json['drafted_projects'] != null) {
      draftedProjects = <DraftedProjects>[];
      json['drafted_projects'].forEach((v) {
        draftedProjects!.add(new DraftedProjects.fromJson(v));
      });
    }
    totalLikes = json['total_likes'];
    totalViews = json['total_views'];
    totalFollowers = json['total_followers'];
    totalFollowing = json['total_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.valProfile != null) {
      data['val_profile'] = this.valProfile!.toJson();
    }
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v.toJson()).toList();
    }
    if (this.occupations != null) {
      data['occupations'] = this.occupations!.map((v) => v.toJson()).toList();
    }
    if (this.postedProjects != null) {
      data['posted_projects'] = this.postedProjects!.map((v) => v.toJson()).toList();
    }
    if (this.draftedProjects != null) {
      data['drafted_projects'] = this.draftedProjects!.map((v) => v.toJson()).toList();
    }
    data['total_likes'] = this.totalLikes;
    data['total_views'] = this.totalViews;
    data['total_followers'] = this.totalFollowers;
    data['total_following'] = this.totalFollowing;
    return data;
  }
}

class Profile {
  int? user;
  int? role;
  String? joinDate;
  String? phoneNumber;

  Profile({this.user, this.role, this.joinDate, this.phoneNumber});

  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    role = json['role'];
    joinDate = json['join_date'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['role'] = this.role;
    data['join_date'] = this.joinDate;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class ValProfile {
  String? mainImage;
  String? coverImage;
  String? username;
  String? city;
  String? country;
  String? state;
  String? about;

  ValProfile({this.mainImage, this.coverImage, this.username, this.city, this.country, this.state, this.about});

  ValProfile.fromJson(Map<String, dynamic> json) {
    mainImage = json['main_image'];
    coverImage = json['cover_image'];
    username = json['username'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_image'] = this.mainImage;
    data['cover_image'] = this.coverImage;
    data['username'] = this.username;
    data['city'] = this.city;
    data['country'] = this.country;
    data['state'] = this.state;
    data['about'] = this.about;
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

class PostedProjects {
  int? projectId;
  String? title;
  String? media;
  num? rating;

  PostedProjects({this.projectId, this.title, this.media, this.rating});

  PostedProjects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    media = json['media'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['media'] = this.media;
    data['rating'] = this.rating;
    return data;
  }
}

class DraftedProjects {
  int? projectId;
  String? title;
  String? media;

  DraftedProjects({this.projectId, this.title, this.media});

  DraftedProjects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    media = json['media'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['media'] = this.media;
    return data;
  }
}
