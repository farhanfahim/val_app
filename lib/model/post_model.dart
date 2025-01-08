// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  int? postId;
  List<ImageList>? imgList;
  String? caption;
  String? profileImage;
  String? profileName;
  String? description;
  bool? isLiked;
  bool? isSave;
  bool isFollow;
  User? user;
  String? published;
  String? about;
  List<Tools>? tools;
  List<Tags>? tags;
  List<Category>? categories;

  PostModel({
    this.postId,
    this.imgList,
    this.caption,
    this.profileImage,
    this.profileName,
    this.isLiked = false,
    this.isSave = false,
    this.isFollow = false,
    this.user,
    this.published,
    this.about,
    this.tools,
    this.tags,
    this.categories,
    this.description,
  });
}

class ImageList {
  int? id;
  String? img;

  ImageList({this.id, this.img});
}

class User {
  int? id;
  String? img;
  String? name;
  String? occupation;
  String? location;
  String? isFollow;
  User({
    this.id,
    this.img,
    this.name,
    this.occupation,
    this.location,
    this.isFollow,
  });
}

class Tools {
  int? id;
  String? name;
  Tools({this.id, this.name});
}

class Tags {
  int? id;
  String? name;
  Tags({this.id, this.name});
}

class Category {
  int? id;
  String? name;
  Category({this.id, this.name});
}
