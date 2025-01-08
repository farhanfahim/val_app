class SavedProjectModel {
  String? status;
  Data? data;

  SavedProjectModel({this.status, this.data});

  SavedProjectModel.fromJson(Map<String, dynamic> json) {
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
  List<SavedProfiles>? savedProfiles;
  List<SavedProjects>? savedProjects;

  Data({this.savedProfiles, this.savedProjects});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['saved_profiles'] != null) {
      savedProfiles = <SavedProfiles>[];
      json['saved_profiles'].forEach((v) {
        savedProfiles!.add(new SavedProfiles.fromJson(v));
      });
    }
    if (json['saved_projects'] != null) {
      savedProjects = <SavedProjects>[];
      json['saved_projects'].forEach((v) {
        savedProjects!.add(new SavedProjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.savedProfiles != null) {
      data['saved_profiles'] =
          this.savedProfiles!.map((v) => v.toJson()).toList();
    }
    if (this.savedProjects != null) {
      data['saved_projects'] =
          this.savedProjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SavedProfiles {
  int? valProfileId;
  String? username;
  String? mainImage;
  String? city;
  String? occupation;
  bool? isFollowed;
  bool? isSaved;
  int? followersCount;
  int? viewsCount;
  int? reviewCount;

  SavedProfiles(
      {this.valProfileId,
      this.username,
      this.mainImage,
      this.city,
      this.occupation,
      this.isFollowed,
      this.isSaved,
      this.followersCount,
      this.viewsCount,
      this.reviewCount});

  SavedProfiles.fromJson(Map<String, dynamic> json) {
    valProfileId = json['val_profile_id'];
    username = json['username'];
    mainImage = json['main_image'];
    city = json['city'];
    occupation = json['occupation'];
    isFollowed = json['is_followed'];
    isSaved = json['is_saved'];
    followersCount = json['followers_count'];
    viewsCount = json['views_count'];
    reviewCount = json['review_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['val_profile_id'] = this.valProfileId;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['city'] = this.city;
    data['occupation'] = this.occupation;
    data['is_followed'] = this.isFollowed;
    data['is_saved'] = this.isSaved;
    data['followers_count'] = this.followersCount;
    data['views_count'] = this.viewsCount;
    data['review_count'] = this.reviewCount;
    return data;
  }
}

class SavedProjects {
  int? projectId;
  String? title;
  List<MediaFiles>? mediaFiles;
  String? postedOn;
  int? likeCount;
  int? commentCount;
  int? viewCount;
  bool? isSaved;
  bool? isLiked;
  Profile? profile;

  SavedProjects(
      {this.projectId,
      this.title,
      this.mediaFiles,
      this.postedOn,
      this.likeCount,
      this.commentCount,
      this.viewCount,
      this.isSaved,
      this.isLiked,
      this.profile});

  SavedProjects.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    if (json['media_files'] != null) {
      mediaFiles = <MediaFiles>[];
      json['media_files'].forEach((v) {
        mediaFiles!.add(new MediaFiles.fromJson(v));
      });
    }
    postedOn = json['posted_on'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    viewCount = json['view_count'];
    isSaved = json['is_saved'];
    isLiked = json['is_liked'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    if (this.mediaFiles != null) {
      data['media_files'] = this.mediaFiles!.map((v) => v.toJson()).toList();
    }
    data['posted_on'] = this.postedOn;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['view_count'] = this.viewCount;
    data['is_saved'] = this.isSaved;
    data['is_liked'] = this.isLiked;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class MediaFiles {
  String? media;
  bool? isCover;

  MediaFiles({this.media, this.isCover});

  MediaFiles.fromJson(Map<String, dynamic> json) {
    media = json['media'];
    isCover = json['is_cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media'] = this.media;
    data['is_cover'] = this.isCover;
    return data;
  }
}

class Profile {
  int? valProfileId;
  String? username;
  String? mainImage;
  bool? isFollowed;
  String? city;

  Profile(
      {this.valProfileId,
      this.username,
      this.mainImage,
      this.isFollowed,
      this.city});

  Profile.fromJson(Map<String, dynamic> json) {
    valProfileId = json['val_profile_id'];
    username = json['username'];
    mainImage = json['main_image'];
    isFollowed = json['is_followed'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['val_profile_id'] = this.valProfileId;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['is_followed'] = this.isFollowed;
    data['city'] = this.city;
    return data;
  }
}


// class SavedProjectModel {
//   String? status;
//   Data? data;

//   SavedProjectModel({this.status, this.data});

//   SavedProjectModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   List<SavedProfiles>? savedProfiles;
//   List<SavedProjects>? savedProjects;

//   Data({this.savedProfiles, this.savedProjects});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['saved_profiles'] != null) {
//       savedProfiles = <SavedProfiles>[];
//       json['saved_profiles'].forEach((v) {
//         savedProfiles!.add(new SavedProfiles.fromJson(v));
//       });
//     }
//     if (json['saved_projects'] != null) {
//       savedProjects = <SavedProjects>[];
//       json['saved_projects'].forEach((v) {
//         savedProjects!.add(new SavedProjects.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.savedProfiles != null) {
//       data['saved_profiles'] = this.savedProfiles!.map((v) => v.toJson()).toList();
//     }
//     if (this.savedProjects != null) {
//       data['saved_projects'] = this.savedProjects!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SavedProfiles {
//   int? valProfileId;
//   String? username;
//   String? mainImage;
//   String? occupation;
//   String? city;
//   bool? isFollowed;
//   bool? isSaved;
//   int? followersCount;
//   int? viewsCount;
//   int? reviewCount;

//   SavedProfiles({this.valProfileId, this.username, this.mainImage, this.occupation, this.isFollowed, this.isSaved, this.followersCount, this.viewsCount, this.reviewCount});

//   SavedProfiles.fromJson(Map<String, dynamic> json) {
//     valProfileId = json['val_profile_id'];
//     username = json['username'];
//     city = json['city'];
//     mainImage = json['main_image'];
//     occupation = json['occupation'];
//     isFollowed = json['is_followed'];
//     isSaved = json['is_saved'];
//     followersCount = json['followers_count'];
//     viewsCount = json['views_count'];
//     reviewCount = json['review_count'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['val_profile_id'] = this.valProfileId;
//     data['username'] = this.username;
//     data['city'] = this.city;
//     data['main_image'] = this.mainImage;
//     data['occupation'] = this.occupation;
//     data['is_followed'] = this.isFollowed;
//     data['is_saved'] = this.isSaved;
//     data['followers_count'] = this.followersCount;
//     data['views_count'] = this.viewsCount;
//     data['review_count'] = this.reviewCount;
//     return data;
//   }
// }

// class SavedProjects {
//   int? projectId;
//   String? title;
//   List<MediaFiles>? mediaFiles;
//   String? postedOn;
//   int? likeCount;
//   bool? isFollowed;
//   int? commentCount;
//   int? viewCount;
//   bool? isSaved;
//   bool? isLiked;
//   Profile? profile;

//   SavedProjects({this.projectId, this.title, this.isFollowed, this.mediaFiles, this.postedOn, this.likeCount, this.commentCount, this.viewCount, this.isSaved, this.isLiked, this.profile});

//   SavedProjects.fromJson(Map<String, dynamic> json) {
//     projectId = json['project_id'];
//     title = json['title'];
//     if (json['media_files'] != null) {
//       mediaFiles = <MediaFiles>[];
//       json['media_files'].forEach((v) {
//         mediaFiles!.add(new MediaFiles.fromJson(v));
//       });
//     }
//     postedOn = json['posted_on'];
//     likeCount = json['like_count'];
//     commentCount = json['comment_count'];
//     isFollowed = json['is_followed'];
//     viewCount = json['view_count'];
//     isSaved = json['is_saved'];
//     isLiked = json['is_liked'];
//     profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['project_id'] = this.projectId;
//     data['title'] = this.title;
//     if (this.mediaFiles != null) {
//       data['media_files'] = this.mediaFiles!.map((v) => v.toJson()).toList();
//     }
//     data['posted_on'] = this.postedOn;
//     data['is_followed'] = this.isFollowed;
//     data['like_count'] = this.likeCount;
//     data['comment_count'] = this.commentCount;
//     data['view_count'] = this.viewCount;
//     data['is_saved'] = this.isSaved;
//     data['is_liked'] = this.isLiked;
//     if (this.profile != null) {
//       data['profile'] = this.profile!.toJson();
//     }
//     return data;
//   }
// }

// class MediaFiles {
//   String? media;
//   bool? isCover;

//   MediaFiles({this.media, this.isCover});

//   MediaFiles.fromJson(Map<String, dynamic> json) {
//     media = json['media'];
//     isCover = json['is_cover'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['media'] = this.media;
//     data['is_cover'] = this.isCover;
//     return data;
//   }
// }

// class Profile {
//   int? valProfileId;
//   String? username;
//   String? mainImage;
//   String? city;

//   Profile({this.valProfileId, this.username, this.mainImage, this.city});

//   Profile.fromJson(Map<String, dynamic> json) {
//     valProfileId = json['val_profile_id'];
//     username = json['username'];
//     mainImage = json['main_image'];
//     city = json['city'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['val_profile_id'] = this.valProfileId;
//     data['username'] = this.username;
//     data['main_image'] = this.mainImage;
//     data['city'] = this.city;
//     return data;
//   }
// }
