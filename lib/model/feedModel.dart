class FeedModel {
  String? status;
  Data? data;

  FeedModel({this.status, this.data});

  FeedModel.fromJson(Map<String, dynamic> json) {
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
  List<UserProfile>? userProfile;
  List<Categories>? categories;
  List<TopProfiles>? topProfiles;
  List<Projects>? projects;

  Data({this.userProfile, this.categories, this.topProfiles, this.projects});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['user_profile'] != null) {
      userProfile = <UserProfile>[];
      json['user_profile'].forEach((v) {
        userProfile!.add(new UserProfile.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['top_profiles'] != null) {
      topProfiles = <TopProfiles>[];
      json['top_profiles'].forEach((v) {
        topProfiles!.add(new TopProfiles.fromJson(v));
      });
    }
    if (json['projects'] != null) {
      projects = <Projects>[];
      json['projects'].forEach((v) {
        projects!.add(new Projects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.topProfiles != null) {
      data['top_profiles'] = this.topProfiles!.map((v) => v.toJson()).toList();
    }
    if (this.projects != null) {
      data['projects'] = this.projects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  String? username;
  String? mainImage;
  String? city;

  UserProfile({this.id, this.username, this.mainImage, this.city});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    mainImage = json['main_image'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['city'] = this.city;
    return data;
  }
}

class Categories {
  int? id;
  String? category;
  String? categoryImage;

  Categories({this.id, this.category, this.categoryImage});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    categoryImage = json['category_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['category_image'] = this.categoryImage;
    return data;
  }
}

class TopProfiles {
  int? valProfileId;
  int? userId;
  String? username;
  String? mainImage;
  String? city;
  String? occupation;
  bool? isFollowed;
  bool? isSaved;
  int? followersCount;
  int? viewsCount;
  int? reviewCount;

  TopProfiles({this.valProfileId, this.userId, this.username, this.mainImage, this.city, this.occupation, this.isFollowed, this.isSaved, this.followersCount, this.viewsCount, this.reviewCount});

  TopProfiles.fromJson(Map<String, dynamic> json) {
    valProfileId = json['val_profile_id'];
    userId = json['user_id'];
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
    data['user_id'] = this.userId;
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

class Projects {
  int? projectId;
  String? title;
  List<MediaFiles>? mediaFiles;
  String? postedOn;
  int? likeCount;
  int? commentCount;
  int? viewCount;
  bool? isSaved;
  bool? isLiked;
  bool? isFollowed;
  Profile? profile;

  Projects({this.projectId, this.title, this.mediaFiles, this.postedOn, this.likeCount, this.commentCount, this.viewCount, this.isSaved, this.isLiked, this.isFollowed, this.profile});

  Projects.fromJson(Map<String, dynamic> json) {
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
    isFollowed = json['is_followed'];
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
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
    data['is_followed'] = this.isFollowed;
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
  String? city;

  Profile({this.valProfileId, this.username, this.mainImage, this.city});

  Profile.fromJson(Map<String, dynamic> json) {
    valProfileId = json['val_profile_id'];
    username = json['username'];
    mainImage = json['main_image'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['val_profile_id'] = this.valProfileId;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['city'] = this.city;
    return data;
  }
}
