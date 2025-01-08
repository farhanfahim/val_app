import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/Repository/project_api/project_api_repo.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/MyProfileModel.dart';
import 'package:val_app/model/CategoriesModelFeeds.dart';
import 'package:val_app/model/feedModel.dart';
import 'package:val_app/model/otherUserProfileModel.dart';
import 'package:val_app/model/postDetailModel.dart';
import 'package:val_app/view_model/profiles/user_profile_view_model.dart';

import '../configs/app_urls.dart';
import '../configs/sharedPerfs.dart';
import '../firestore/firestore_controller.dart';

class HomeViewModel with ChangeNotifier {
  PageController? pageController = PageController();


  int currentPage = 0;
  bool? isFollow;

  bool loader = true;
  bool feedLoader = true;
  bool followLoader = true;
  bool categoriesLoader = true;
  bool otherUserLoader = true;

  MyProfileModel? myProfile;
  PostDetailModel? feedPostDetail;
  FeedModel? feeds;
  CategoriesModelFeeds? categoriesProject;
  OtherUserProfileModel? otherUSer;

  bool showNotificationDot = false;
  bool showChatDot = false;
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();
  ProjectHttpApiRepository projRepo = ProjectHttpApiRepository();

  String formatDateTime(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('h:mm a • MMM d, yyyy').format(dateTime);
  }


  sorted() {
    for (var project in feeds!.data!.projects!) {
      project.mediaFiles!.sort((a, b) => b.isCover! ? 1 : -1);
    }
  }

  sortedcate() {
    for (var project in categoriesProject!.data!) {
      project.mediaFiles!.sort((a, b) => b.isCover! ? 1 : -1);
    }
  }

  void toggleFollowing() {
    isFollow = !isFollow!;
    notifyListeners();
  }

  Future<void> getAllFeeds(BuildContext context) async {
    // Show loader before making the API call
    feedLoader = true;
    notifyListeners();

    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer $accessToken'};
    print("headers:" + headers.toString());

    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };

    try {
      // Make the API call
      FeedModel response =
          await homeRepo.getAllFeeds(headers: headers, data: data);

      if (response.status == "success") {
        print("feeds: " + response.toString());
        feeds = response;
        FirestoreController.instance.updateUserData(
            int.parse(SharedPrefs.instance.getString('userId').toString()),
            feeds?.data?.userProfile?[0].username,
            feeds?.data?.userProfile?[0].mainImage != null
                ? AppUrl.baseUrl + feeds!.data!.userProfile![0].mainImage!
                : "");
        // If sorting is necessary, perform it here
        sorted();

        // Success: hide the loader
        feedLoader = false;
        notifyListeners();
      } else {
        // Handle case where response status isn't "success"
        Utils.toastMessage("Failed to load feeds");
        feedLoader = false;
        notifyListeners();
      }
    } catch (error) {
      // Handle error and show toast message
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      // Ensure the loader is hidden even if an error occurs
      feedLoader = false;
      notifyListeners();
    }
  }
  Future<void> getNotificationCount(BuildContext context) async {
    // Show loader before making the API call
    feedLoader = true;
    notifyListeners();

    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer $accessToken'};
    print("headers:" + headers.toString());

    var data = {};

    try {
      NotitficationCountModel response = await homeRepo.getNotificationCount(headers: headers, data: data);

      if (response.status == true) {
        if(response.data!.notification!){
          showNotificationDot = true;
        }
      }
    } catch (error) {
      // Handle error and show toast message
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      notifyListeners();
    }
  }

  String getGreeting() {
    // Get the current hour
    int currentHour = DateTime.now().hour;

    // Determine the greeting based on the hour of the day
    if (currentHour >= 5 && currentHour < 12) {
      return 'Good Morning 🌞';
    } else if (currentHour >= 12 && currentHour < 18) {
      return 'Good Afternoon 🌻';
    } else if (currentHour >= 18 && currentHour < 21) {
      return 'Good Evening 🌇';
    } else {
      return 'Good Night 🌙';
    }
  }


  updateNotification(value){
    showNotificationDot = value;
    notifyListeners();
  }

  updateChatNotification(value){
    showChatDot = value;
    notifyListeners();
  }
  Future<void> getCategoriesById(BuildContext context,
      {required String id, required int index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      CategoriesModelFeeds response = await homeRepo.getCategoriesById(
          headers: headers, data: data, id: id);

      if (response.status == "success") {
        Navigator.pop(context);
        print("feeds" + response.toString());
        categoriesProject = response;
        // to show isCover true first
        sortedcate();

        categoriesLoader = false;
        Navigator.pushNamed(context, RoutesName.categoryDetail, arguments: {
          "title": feeds!.data!.categories![index].category.toString()
        });

        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getMyProfile(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      MyProfileModel response = await homeRepo.getMyProfile(headers);

      if (response.status == "success") {
        loader = false;
        myProfile = response;
        notifyListeners();
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());

      print("error: $error");
    }
  }

  void toggleSaveProfile(BuildContext context, String id) async {
    // Find the profile by id
    var profile = feeds?.data?.topProfiles
        ?.firstWhere((profile) => profile.valProfileId.toString() == id);

    if (profile != null) {
      bool newSavedStatus = !profile.isSaved!;
      // Call the save/unsave method based on the new status
      await getSaveProfile(context, id: id, isSaved: newSavedStatus);

      // Update the saved status locally
      profile.isSaved = newSavedStatus;
      notifyListeners();
    }
  }

  void toggleSaveProfileFromTopDesigner(BuildContext context, String id,FeedModel feed) async {
    // Find the profile by id
    var profile = feed.data?.topProfiles
        ?.firstWhere((profile) => profile.valProfileId.toString() == id);

    if (profile != null) {
      bool newSavedStatus = !profile.isSaved!;
      // Call the save/unsave method based on the new status
      await getSaveProfile(context, id: id, isSaved: newSavedStatus);

      // Update the saved status locally
      profile.isSaved = newSavedStatus;
      notifyListeners();
    }
  }

  notifyOnSavedDesigner(v){
    feeds!.data!.topProfiles = v as List<TopProfiles>;
    notifyListeners();
  }
  Future<void> getSaveProfile(BuildContext context,
      {String? id, required bool isSaved}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await homeRepo.getSaveProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        // Utils.toastMessage("Profile Saved");
        loader = false;

        notifyListeners();
      } else {
        Navigator.pop(context);
        // Check for token expiration error
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getSaveProject(BuildContext context,
      {String? id, int? index}) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await projRepo.projectSave(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        feeds!.data!.projects![index!].isSaved =
            !feeds!.data!.projects![index].isSaved!;
        if (feeds!.data!.projects![index].isSaved!) {
          // Utils.toastMessage("Project Saved");
        } else {
          // Utils.toastMessage("Project Unsaved");
        }
        notifyListeners();
      } else {
        // Navigator.pop(context);
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getFollowProfile(BuildContext context,
      {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        int count = feeds!.data!.topProfiles![index!].followersCount!;
        feeds?.data?.topProfiles?[index].isFollowed = !feeds!.data!.topProfiles![index].isFollowed!;
        if(feeds!.data!.topProfiles![index].isFollowed!){
          count++;
          feeds!.data!.topProfiles![index].followersCount = count;
        }else{
          count--;
          feeds!.data!.topProfiles![index].followersCount = count;
        }
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getFollowProfileFromDesigner(BuildContext context,
      {String? id, int? index,FeedModel? feed}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
      await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        feed!.data!.topProfiles?[index!].isFollowed = !feed.data!.topProfiles![index].isFollowed!;
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  updateData(v,index){
    int count = feeds!.data!.topProfiles![index].followersCount!;
    if(v == true){
      feeds!.data!.topProfiles![index].isFollowed = true;
      count++;
      feeds!.data!.topProfiles![index].followersCount = count;
    }else{
      feeds!.data!.topProfiles![index].isFollowed = false;
      count--;
      feeds!.data!.topProfiles![index].followersCount = count;
    }
    notifyListeners();
  }
  updatePostData(v,index){
    feeds!.data!.projects![index].isFollowed = v;
    notifyListeners();

  }

  Future<void> getFollowProject(BuildContext context,
      {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        feeds?.data?.projects?[index!].isFollowed =
            !feeds!.data!.projects![index].isFollowed!;
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getProjectLike(BuildContext context,
      {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await projRepo.projectLike(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        if (feeds!.data!.projects![index!].isLiked == true) {
          feeds!.data!.projects![index].isLiked = false;
          feeds!.data!.projects![index].likeCount =
              feeds!.data!.projects![index].likeCount! - 1;
        } else if (feeds!.data!.projects![index].isLiked == false) {
          feeds!.data!.projects![index].isLiked = true;
          feeds!.data!.projects![index].likeCount =
              feeds!.data!.projects![index].likeCount! + 1;
        }
      }
    } catch (error) {
      //Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      notifyListeners();
      Navigator.pop(context);
    }
  }

  Future<void> getProjectViewCount(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response =
          await projRepo.projectView(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        // var posting = Provider.of<UserPostDetailViewModel>(context);
        // posting.getUserPostDetail(context, id: id);
        Navigator.pushNamed(context, RoutesName.userPostDetail,
            arguments: {"id": id});

        notifyListeners();
      } else if (response['detail']
          .toString()
          .toUpperCase()
          .contains("VIEWED")) {
        Navigator.pop(context);
        Navigator.pushNamed(context, RoutesName.userPostDetail);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getUserPostDetail(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      PostDetailModel response =
          await homeRepo.getMyProfileDetail(headers, data, id: id);

      if (response.status == "success") {
        Navigator.pop(context);
        loader = false;
        feedPostDetail = response;
        sorted();
        Navigator.pushNamed(context, RoutesName.userPostDetail);
        postView(context, id: id);
        // Navigator.pushNamed(context, RoutesName.myPostDetail);
        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      loader = false;
    }
  }

  Future<void> postView(BuildContext context, {String? id}) async {
    // Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      var response =
          await projRepo.projectView(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        // Navigator.pop(context);
        print("postView" + response.toString());
        notifyListeners();
      } else {
        // Navigator.pop(context);
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  void pingApiRequest() async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      final response = await homeRepo.pingApi(headers:headers);
      print("2217 " + response.toString());
    } catch (e) {}
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


class NotitficationCountModel {
  bool? status;
  int? statusCode;
  String? message;
  NotitficationData? data;

  NotitficationCountModel(
      {this.status, this.statusCode, this.message, this.data});

  NotitficationCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new NotitficationData.fromJson(json['data']) : null;
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

class NotitficationData {
  bool? notification;
  int? totalMessageCount;

  NotitficationData({this.notification, this.totalMessageCount,});

  NotitficationData.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    totalMessageCount = json['total_message_count'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['total_message_count'] = this.totalMessageCount;

    return data;
  }
}