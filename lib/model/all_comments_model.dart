class AllCommentsModel {
  bool? status;
  int? statusCode;
  String? message;
  List<CommentsData>? data;

  AllCommentsModel({this.status, this.statusCode, this.message, this.data});

  AllCommentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommentsData>[];
      json['data'].forEach((v) {
        data!.add(new CommentsData.fromJson(v));
      });
    } 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentsData {
  String? username;
  String? mainImage;
  String? comment;
  String? commentedAt;

  CommentsData({this.username, this.mainImage, this.comment, this.commentedAt});

  CommentsData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    mainImage = json['main_image'];
    comment = json['comment'];
    commentedAt = json['commented_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['comment'] = this.comment;
    data['commented_at'] = this.commentedAt;
    return data;
  }
}
