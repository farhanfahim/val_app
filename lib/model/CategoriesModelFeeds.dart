class CategoriesModelFeeds {
  String? status;
  List<Data>? data;

  CategoriesModelFeeds({this.status, this.data});

  CategoriesModelFeeds.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
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

  Data({this.projectId, this.title, this.mediaFiles, this.postedOn, this.likeCount, this.commentCount, this.viewCount, this.isSaved, this.isLiked, this.isFollowed, this.profile});

  Data.fromJson(Map<String, dynamic> json) {
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
