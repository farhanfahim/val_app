import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/Repository/project_api/project_api_repo.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/SavedProjectModel.dart';
import 'package:val_app/model/otherUserProfileModel.dart';
import 'package:val_app/model/postDetailModel.dart';
import 'package:val_app/view_model/profiles/user_profile_view_model.dart';

enum tabs { creative, projects }

class SavedViewModel with ChangeNotifier {
  // SavedViewModel(BuildContext context) {
  //   Future.microtask(() => getAllSavedProjects(context));
  // }
  PageController? pageController = PageController();
  int currentPage = 0;
  tabs _selected = tabs.creative;
  tabs get selected => _selected;
  bool savedLoader = true;
  bool isProfileLoader = true;
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();
  ProjectHttpApiRepository projRepo = ProjectHttpApiRepository();
  void setSelected(tabs selection) {
    _selected = selection;
    notifyListeners();
  }

  SavedProjectModel? savedProjects;
  String formatDateTime(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    return DateFormat('h:mm a • MMM d, yyyy').format(dateTime);
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

        // feedPostDetail = response;
        // Provider.of<UserPostDetailViewModel>(context, listen: false).setPostDetailData(response);
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
    }
  }

  Future<void> postRate(BuildContext context, {String? id, required String rate}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {"rate": rate};
    try {
      var response = await projRepo.projectRate(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        Navigator.pop(context);
        print("postRate" + response.toString());
        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> getAllSavedProjects(BuildContext context, {bool isPullToRefresh = true}) async {
    // Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      SavedProjectModel response = await HomeHttpApiRepository().getAllSavedProjects(headers: headers, data: data);
      if (response.status == "success") {
        print("feeds" + response.toString());
        savedProjects = response;
        sorted();
        // Navigator.pop(context);
        savedLoader = false;
        notifyListeners();
      } else {
        // Navigator.pop(context);
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      savedLoader = false;
      isProfileLoader = false;
    }
  }

  Future<void> getSaveProfile(BuildContext context, {String? id}) async {
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
        getAllSavedProjects(context, isPullToRefresh: false);
        // loader = false;
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

  Future<void> getSaveProject(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await projRepo.projectSave(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        // saveLoader = false;
        // Utils.toastMessage("Project Saved");
        Navigator.pop(context);
        getAllSavedProjects(context, isPullToRefresh: false);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.handleTokenExpiration(context, response);
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
        // followLoader = false;
        getAllSavedProjects(context, isPullToRefresh: false);
        // Utils.toastMessage("Following");
        // savedProjects?.data?.savedProfiles?[index!].isFollowed = !savedProjects!.data!.savedProfiles![index].isFollowed!;
        notifyListeners();
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      // Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
    finally{
      Navigator.pop(context);
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
        Navigator.pop(context);
        print("farhan like");
        savedProjects!.data!.savedProjects![index!].isLiked = !savedProjects!.data!.savedProjects![index].isLiked!;
        int likeCount = 0;
        likeCount = savedProjects!.data!.savedProjects![index].likeCount!;
        if (savedProjects!.data!.savedProjects![index].isLiked!) {
          likeCount++;
          savedProjects!.data!.savedProjects![index].likeCount = likeCount;
          Utils.toastMessage("Post liked");
        } else {
          if (likeCount > 0) {
            likeCount--;
            savedProjects!.data!.savedProjects![index].likeCount = likeCount;
            Utils.toastMessage("Post disliked");
          }
        }



        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
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
        // likeLoader = false;
        // var posting = Provider.of<UserPostDetailViewModel>(context);
        // posting.getUserPostDetail(context, id: id);
        Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {"id": id});

        notifyListeners();
      } else if (response['detail'].toString().toUpperCase().contains("VIEWED")) {
        Navigator.pop(context);
        Navigator.pushNamed(context, RoutesName.userPostDetail);
      } else {
        Utils.handleTokenExpiration(context, response);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  updateData(v,index){
    int count = savedProjects!.data!.savedProfiles![index].followersCount!;
    if(v == true){
      savedProjects!.data!.savedProfiles![index].isFollowed = true;
      count++;
      savedProjects!.data!.savedProfiles![index].followersCount = count;
    }else{
      savedProjects!.data!.savedProfiles![index].isFollowed = false;
      count--;
      savedProjects!.data!.savedProfiles![index].followersCount = count;
    }
    notifyListeners();
  }

  sorted() {
    for (var project in savedProjects!.data!.savedProjects!) {
      project.mediaFiles!.sort((a, b) => b.isCover! ? 1 : -1);
    }
  }
}
