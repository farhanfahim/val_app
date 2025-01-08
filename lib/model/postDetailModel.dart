class PostDetailModel {
  String? status;
  Data? data;

  PostDetailModel({this.status, this.data});

  PostDetailModel.fromJson(Map<String, dynamic> json) {
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
  Profile? profile;
  int? id;
  String? title;
  String? description;
  bool? isDrafted;
  bool? isPosted;
  String? postedOn;
  List<Media>? media;
  List<Categories>? categories;
  List<Tools>? tools;
  List<Tags>? tags;
  Metrics? metrics;
  bool? isLiked;
  bool? isSaved;
  List<Comments>? comments;

  Data({this.profile, this.id, this.title, this.description, this.isDrafted, this.isPosted, this.postedOn, this.media, this.categories, this.tools, this.tags, this.metrics, this.isLiked, this.isSaved, this.comments});

  Data.fromJson(Map<String, dynamic> json) {
    profile = json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isDrafted = json['is_drafted'];
    isPosted = json['is_posted'];
    postedOn = json['posted_on'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    if (json['tools'] != null) {
      tools = <Tools>[];
      json['tools'].forEach((v) {
        tools!.add(new Tools.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    metrics = json['metrics'] != null ? new Metrics.fromJson(json['metrics']) : null;
    isLiked = json['is_liked'];
    isSaved = json['is_saved'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_drafted'] = this.isDrafted;
    data['is_posted'] = this.isPosted;
    data['posted_on'] = this.postedOn;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.tools != null) {
      data['tools'] = this.tools!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.metrics != null) {
      data['metrics'] = this.metrics!.toJson();
    }
    data['is_liked'] = this.isLiked;
    data['is_saved'] = this.isSaved;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Profile {
  String? username;
  String? mainImage;
  String? city;
  List<Occupations>? occupations;

  Profile({this.username, this.mainImage, this.city, this.occupations});

  Profile.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    mainImage = json['main_image'];
    city = json['city'];
    if (json['occupations'] != null) {
      occupations = <Occupations>[];
      json['occupations'].forEach((v) {
        occupations!.add(new Occupations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['city'] = this.city;
    if (this.occupations != null) {
      data['occupations'] = this.occupations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Occupations {
  String? occupation;

  Occupations({this.occupation});

  Occupations.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['occupation'] = this.occupation;
    return data;
  }
}

class Media {
  String? media;
  bool? isCover;

  Media({this.media, this.isCover});

  Media.fromJson(Map<String, dynamic> json) {
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

class Categories {
  int? id;
  String? categoryName;

  Categories({this.id, this.categoryName});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Tools {
  int? id;
  String? toolName;

  Tools({this.id, this.toolName});

  Tools.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toolName = json['tool_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool_name'] = this.toolName;
    return data;
  }
}

class Tags {
  String? tag;

  Tags({this.tag});

  Tags.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    return data;
  }
}

class Metrics {
  int? likeCount;
  int? commentCount;
  int? viewCount;
  double? averageRating;

  Metrics({this.likeCount, this.commentCount, this.viewCount, this.averageRating});

  Metrics.fromJson(Map<String, dynamic> json) {
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    viewCount = json['view_count'];
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['view_count'] = this.viewCount;
    data['average_rating'] = this.averageRating;
    return data;
  }
}

class Comments {
  String? comment;
  String? commentedAt;
  CommentedBy? commentedBy;

  Comments({this.comment, this.commentedAt, this.commentedBy});

  Comments.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    commentedAt = json['commented_at'];
    commentedBy = json['commented_by'] != null ? new CommentedBy.fromJson(json['commented_by']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['commented_at'] = this.commentedAt;
    if (this.commentedBy != null) {
      data['commented_by'] = this.commentedBy!.toJson();
    }
    return data;
  }
}

class CommentedBy {
  String? username;
  String? mainImage;

  CommentedBy({this.username, this.mainImage});

  CommentedBy.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    mainImage = json['main_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    return data;
  }
}
