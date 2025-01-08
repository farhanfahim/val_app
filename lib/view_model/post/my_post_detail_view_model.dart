import 'package:flutter/material.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/Repository/project_api/project_api_repo.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/postDetailModel.dart';

import '../../model/my_post_detail_model.dart';
import '../../model/post_model.dart';
import '../../view/bottom_nav_bar.dart';

class MyPostDetailViewModel with ChangeNotifier {
  TextEditingController commentTextEditingController = TextEditingController();

  FocusNode focusComment = FocusNode();
  PageController? pageController = PageController();
  int currentPage = 0;

  PostModel postDetail = PostModel(
    imgList: [
      ImageList(id: 1, img: "uncle.gif"),
      ImageList(id: 2, img: "man.gif"),
      ImageList(id: 3, img: "cat.gif"),
      ImageList(id: 4, img: "shoes.png"),
    ],
    published: "Apr 23, 2023",
    profileImage: "mira_gouse.png",
    profileName: "Mira Gouse",
    caption: "Blender Character Sculpting (vertex painting)",
    description: "Lorem ipsum dolor sit amet consectetur. Laoreet pharetra tortor auctor tortor consequat pulvinar porttitor facilisis. Nunc nec vivamus quis tincidunt nulla nunc maecenas facilisi sit.",
    isLiked: false,
    isSave: false,
    user: User(id: 1, img: "mira_gouse.png", name: "Mira Gouse", location: "California, United States"),
    tools: [
      // Tools(id: 1, name: "Blender 3D"),
    ],
    // tags: [
    //   Tags(id: 1, name: "Illustration"),
    //   Tags(id: 2, name: "Design"),
    //   Tags(id: 3, name: "ui"),
    //   Tags(id: 4, name: "model"),
    //   Tags(id: 5, name: "texture"),
    //   Tags(id: 6, name: "Illustration"),
    //   Tags(id: 7, name: "Design"),
    //   Tags(id: 8, name: "ui"),
    //   Tags(id: 9, name: "model"),
    //   Tags(id: 10, name: "texture"),
    // ],
    categories: [Category(id: 1, name: "Illustration")],
  );

  bool show = false;

  void showData() {
    show = true;
    notifyListeners();
  }

  void hideData() {
    show = false;
    notifyListeners();
  }

  PostDetailModel? myProfileDetail;
  MyPostDetailModel? myPostDetailModel;
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();
  Future<void> getMyProjectDetail(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    Map<String,dynamic> data = {
      'timezone' : DateTime.now().timeZoneOffset.toString()
    };
    try {
      var response = await homeRepo.getMyProfileDetail(headers, data, id: id);

      if (response['status'] == "success") {
        final post = MyPostDetailModel.fromJson(response);
        Navigator.pop(context);

        myPostDetailModel = post;

        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }

  ProjectHttpApiRepository projRepo = ProjectHttpApiRepository();

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
        myPostDetailModel!.data!.isLiked = !myPostDetailModel!.data!.isLiked!;
         int likeCount = 0;
         likeCount = myPostDetailModel!.data!.metrics!.likeCount!;
         if ( myPostDetailModel!.data!.isLiked!) {
           likeCount++;
           myPostDetailModel!.data!.metrics!.likeCount = likeCount;
         } else {
           if (likeCount > 0) {
             likeCount--;
             myPostDetailModel!.data!.metrics!.likeCount = likeCount;
           }
         }
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
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      var response = await projRepo.projectView(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        print("postView" + response.toString());
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

  Future<void> postRate(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {};
    try {
      var response = await projRepo.projectRate(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
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

  ProjectDelete(context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());

    Map<String, String> data = {};
    try {
      projRepo.projectDelete(data: data, headers: headers, id: id).then(
        (value) {
          if (value != null) {
            print('delete $value');
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Utils.toastMessage("Error deleting project");
            print('delete $value');

            Navigator.pop(context);
          }
        },
      ).onError(
        (error, stackTrace) {
          Utils.toastMessage("project cache ${error.toString()}");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      print("Profile Exception" + e.toString());
      Navigator.pop(context);
    }
  }
}
