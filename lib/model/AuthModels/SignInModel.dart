class SignInModel {
  bool? status;
  Data? data;
  String? message;
  int? statusCode;

  SignInModel({this.status, this.data, this.message, this.statusCode});

  SignInModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    statusCode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['status_code'] = this.statusCode;
    return data;
  }
}

class Data {
  int? pk;
  int? userId;
  String? email;
  String? fullName;
  String? refresh;
  String? access;
  String? role;
  String? username;
  String? mainImage;
  String? city;
  bool? profileDone;
  String? firestoreId;



  Data({this.userId,this.pk, this.email, this.fullName, this.refresh, this.access, this.role, this.username, this.mainImage, this.profileDone,this.city, this.firestoreId});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    pk = json['pk'];
    email = json['email'];
    fullName = json['full_name'];
    refresh = json['refresh'];
    access = json['access'];
    profileDone = json['profile_done'];
    role = json['role'];
    username = json['username'];
    mainImage = json['main_image'];
    city = json['city'];
    firestoreId = json['firestore_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['pk'] = this.pk;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    data['role'] = this.role;
    data['profile_done'] = this.profileDone;
    data['username'] = this.username;
    data['main_image'] = this.mainImage;
    data['city'] = this.city;
    data['firestore_id'] = this.firestoreId;
    return data;
  }
}


class FirebaseToken {
  bool? status;
  String? message;

  FirebaseToken({this.status, this.message});

  FirebaseToken.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}