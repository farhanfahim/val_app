import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/Repository/project_api/project_api_repo.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/routes/routes_name.dart';
import '../../model/otherUserProfileModel.dart';
import '../../model/user_post_detail_model.dart';
import '../profiles/user_profile_view_model.dart';

class UserPostDetailViewModel with ChangeNotifier {
  OtherUserProfileModel? otherUSer;
  bool otherUserLoader = true;
  String? userID;
  PageController? pageController = PageController();
  int currentPage = 0;
  TextEditingController commentTextEditingController = TextEditingController();
  double rate = 0.0;
  FocusNode focusComment = FocusNode();
  UserPostDetailModel? feedPostDetail;
  bool loader = true;
  // PostModel postDetail = PostModel(
  //   imgList: [
  //     ImageList(id: 1, img: "uncle.gif"),
  //     ImageList(id: 2, img: "man.gif"),
  //     ImageList(id: 3, img: "cat.gif"),
  //     ImageList(id: 4, img: "shoes.png"),
  //   ],
  //   published: "Apr 23, 2023",
  //   profileImage: "mira_gouse.png",
  //   profileName: "Mira Gouse",
  //   caption: "Blender Character Sculpting (vertex painting)",
  //   description:
  //       "Lorem ipsum dolor sit amet consectetur. Laoreet pharetra tortor auctor tortor consequat pulvinar porttitor facilisis. Nunc nec vivamus quis tincidunt nulla nunc maecenas facilisi sit.",
  //   isLiked: false,
  //   isSave: false,
  //   user: User(id: 1, img: "mira_gouse.png", name: "Mira Gouse", location: "California, United States"),
  //   tools: [
  //     Tools(id: 1, name: "Blender 3D"),
  //   ],
  //   tags: [
  //     Tags(id: 1, name: "Illustration"),
  //     Tags(id: 2, name: "Design"),
  //     Tags(id: 3, name: "ui"),
  //     Tags(id: 4, name: "model"),
  //     Tags(id: 5, name: "texture"),
  //     Tags(id: 6, name: "Illustration"),
  //     Tags(id: 7, name: "Design"),
  //     Tags(id: 8, name: "ui"),
  //     Tags(id: 9, name: "model"),
  //     Tags(id: 10, name: "texture"),
  //   ],
  //   categories: [Category(id: 1, name: "Illustration")],
  // );

  bool show = false;

  // setPostDetailData(UserPostDetailModel response) {
  //   feedPostDetail = response;
  //   notifyListeners();
  // }

  void showData() {
    show = true;
    notifyListeners();
  }

  void hideData() {
    show = false;
    notifyListeners();
  }

  sorted() {
    for (var project in feedPostDetail!.data!.media!) {
      if (project.isCover == true) {
        feedPostDetail!.data!.media!.sort(
          (a, b) => b.isCover! ? 1 : -1,
        );
      }
    }
  }

  ProjectHttpApiRepository projRepo = ProjectHttpApiRepository();
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> postComment(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      "comment": commentTextEditingController.text.trim().toString(),
    };
    try {
      var response = await projRepo.projectComment(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        focusComment.unfocus();
        commentTextEditingController.clear();
        print("comment" + response.toString());

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

  Future<void> postLike(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      var response = await projRepo.projectLike(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        feedPostDetail!.data!.isLiked = !feedPostDetail!.data!.isLiked!;
        int likeCount = 0;
        likeCount = feedPostDetail!.data!.metrics!.likeCount!;
        if (feedPostDetail!.data!.isLiked!) {
          likeCount++;
          feedPostDetail!.data!.metrics!.likeCount = likeCount;
        } else {
          if (likeCount > 0) {
            likeCount--;
            feedPostDetail!.data!.metrics!.likeCount = likeCount;
          }
        }

        print("postLike" + response.toString());
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

  Future<void> postRate(BuildContext context, {String? id, required double rate}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {"rate": rate.toString()};
    try {
      var response = await projRepo.projectRate(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  Future<void> postSave(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      var response = await projRepo.projectSave(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        print("postSave" + response.toString());
        feedPostDetail!.data!.isSaved = !feedPostDetail!.data!.isSaved!;
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

  Future<void> getUserPostDetail(BuildContext context, {String? id, bool isShowLoader = true}) async {
    if (isShowLoader) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      var response = await homeRepo.getMyProfileDetail(headers, data, id: id);

      if (response['status'] == "success") {
        final post = UserPostDetailModel.fromJson(response);

        if (isShowLoader) Navigator.pop(context);
        feedPostDetail = post;
        rate = post.data?.metrics?.averageRating?.toDouble()??0.0;
        sorted();
        // Navigator.pushNamed(context, RoutesName.userPostDetail);
        postView(context, id: id);
        // Navigator.pushNamed(context, RoutesName.myPostDetail);
        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    } finally {
      loader = false;
    }
  }

  Future<void> getFollowProfile(BuildContext context, {String? id, int? index, bool? isLoadingShow = false}) async {
    if (isLoadingShow == true) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      dynamic response = await homeRepo.getFollowProfile(headers: headers, data: data, id: id);

      if (response["status"] == "success") {
        if (isLoadingShow == true) Navigator.pop(context);
        feedPostDetail?.data?.profile?.isFollow = !feedPostDetail!.data!.profile!.isFollow!;
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

}
