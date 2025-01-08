import 'package:flutter/material.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/MyProfileModel.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/model/likes_model.dart';
import 'package:val_app/model/postDetailModel.dart';
import 'package:val_app/model/skills_model.dart';

import '../../model/AuthModels/CreateProfileModel.dart';

enum TabsEnum { work, about, draft }

class MyProfileViewModel extends ChangeNotifier {
  TabsEnum _selected = TabsEnum.work;

  bool loader = true;

  TabsEnum get selected => _selected;
  MyProfileModel? myProfile;
  PostDetailModel? myProfileDetail;
  SignInModel? singInData;

  void setSelected(TabsEnum selection) {
    _selected = selection;
    notifyListeners();
  }

  setuserdata(SignInModel response) {
    singInData = response;
    notifyListeners();
  }

  setPostDetailData(PostDetailModel response) {
    myProfileDetail = response;
    notifyListeners();
  }

  updateListOnDeleteDraft(index){
    print("delete");
    myProfile!.data?.draftedProjects!.removeAt(index);
    notifyListeners();
  }

  List<SkillsModel> skills = [
    // SkillsModel(id: 1, name: "illustration"),
    // SkillsModel(id: 2, name: "animation"),
    // SkillsModel(id: 3, name: "3d modeling"),
    // SkillsModel(id: 4, name: "3d animation"),
  ];

  List<LikesModel> likesList = [
    LikesModel(id: 1, name: 'Mira Gouse', img: "cater_lewin.png"),
    LikesModel(id: 2, name: 'Lydia Kenter', img: "emerson_carder.png"),
    LikesModel(id: 3, name: 'Carter Levin', img: "profile_img.png"),
    LikesModel(id: 4, name: 'Rayna Donin', img: "graphics_design.png"),
    LikesModel(id: 5, name: 'Jaylon Rosser', img: "photography.png"),
    LikesModel(id: 6, name: 'Jakob Lipshutz', img: "mira_gouse2.png"),
    LikesModel(id: 7, name: 'Brandon Workman', img: "cater_lewin.png"),
    LikesModel(id: 8, name: 'Ann Franci', img: "cater_lewin.png"),
    LikesModel(id: 9, name: 'Abram Dias ', img: "profile_img.png"),
    LikesModel(id: 10, name: 'Carla Vetrovs', img: "cater_lewin.png"),
    LikesModel(id: 11, name: 'Orlando Septimus', img: "ryan_workman.png"),
    LikesModel(id: 12, name: 'Jordyn Aminoff', img: "cater_lewin.png"),
    LikesModel(id: 13, name: 'Jordyn Aminoff', img: "mira_gouse.png"),
    LikesModel(id: 14, name: 'Jordyn Aminoff', img: "cater_lewin.png"),
  ];
  List<LikesModel> liked = [];

  void likesSelection(LikesModel like) {
    if (liked.contains(like)) {
      liked.remove(like);
    } else {
      liked.add(like);
    }
    notifyListeners();
  }

  void removelikes(LikesModel like) {
    liked.remove(like);
    notifyListeners();
  }


  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> getMyProfile(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      MyProfileModel response = await homeRepo.getMyProfile(headers);

      if (response.status == true) {
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

  Future<void> getMyProfileNew(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      Utils().loadingDialog(context);
      MyProfileModel response = await homeRepo.getMyProfile(headers);

      if (response.status == true) {
        myProfile = response;
        Navigator.pop(context);
        Navigator.pushNamed(context, RoutesName.createProfile, arguments: {
          'isEdit': true,
        }).then((v){
          if(v!=null){
            getMyProfile(context);
          }

        });
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());

      print("error: $error");
    }
  }

  updateFollowerUser(v){
    myProfile!.data!.totalFollowers = v as int;
    notifyListeners();
  }
  updateFollowingUser(v){
    myProfile!.data!.totalFollowing = v as int;
    notifyListeners();
  }
}
