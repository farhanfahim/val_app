import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import '../Repository/project_api/project_api_repo.dart';
import '../configs/routes/routes_name.dart';
import '../configs/utils.dart';
import '../model/AuthModels/MyProfileModel.dart';
import '../model/CategoriesModelFeeds.dart';
import '../model/feedModel.dart';
import '../model/otherUserProfileModel.dart';
import '../model/postDetailModel.dart';

class CategoriesDetailViewModel extends ChangeNotifier {
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

  Future<void> getCategoriesById(BuildContext context, {required String id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      CategoriesModelFeeds response = await homeRepo.getCategoriesById(headers: headers, data: data, id: id);

      if (response.status == "success") {
        Navigator.pop(context);
        print("feeds" + response.toString());
        categoriesProject = response;
        // to show isCover true first
        sortedcate();

        categoriesLoader = false;
        // Navigator.pushNamed(context, RoutesName.categoryDetail, arguments: {"title": feeds!.data!.categories![index].category.toString()});

        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      categoriesLoader = false;
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
    var profile = feeds?.data?.topProfiles?.firstWhere((profile) => profile.valProfileId.toString() == id);

    if (profile != null) {
      bool newSavedStatus = !profile.isSaved!;
      // Call the save/unsave method based on the new status
      await getSaveProfile(context, id: id, isSaved: newSavedStatus);

      // Update the saved status locally
      profile.isSaved = newSavedStatus;
      notifyListeners();
    }
  }

  Future<void> getSaveProfile(BuildContext context, {String? id, required bool isSaved}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await homeRepo.getSaveProfile(headers: headers, data: data, id: id);

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

  Future<void> getSaveProject(BuildContext context, {String? id, int? index}) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await projRepo.projectSave(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        feeds!.data!.projects![index!].isSaved = !feeds!.data!.projects![index].isSaved!;
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

  Future<void> getFollowProfile(BuildContext context, {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        categoriesProject!.data![index!].isFollowed = !categoriesProject!.data![index].isFollowed!;
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

  Future<void> getFollowProject(BuildContext context, {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        feeds?.data?.projects?[index!].isFollowed = !feeds!.data!.projects![index].isFollowed!;
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

  Future<void> getProjectLike(BuildContext context, {String? id, int? index}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await projRepo.projectLike(headers: headers, data: data, id: id); 
      if (response["status"] == "success") {
        if (categoriesProject!.data![index!].isLiked == true) {
          categoriesProject!.data![index].isLiked = false;
          categoriesProject!.data![index].likeCount = categoriesProject!.data![index].likeCount! - 1;
        } else if (categoriesProject!.data![index].isLiked == false) {
          categoriesProject!.data![index].isLiked = true;
          categoriesProject!.data![index].likeCount = categoriesProject!.data![index].likeCount! + 1;
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
      dynamic response = await projRepo.projectView(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        // var posting = Provider.of<UserPostDetailViewModel>(context);
        // posting.getUserPostDetail(context, id: id);
        Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {"id": id});

        notifyListeners();
      } else if (response['detail'].toString().toUpperCase().contains("VIEWED")) {
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
      PostDetailModel response = await homeRepo.getMyProfileDetail(headers, data, id: id);

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
      var response = await projRepo.projectView(data: data, headers: headers, id: id);

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
