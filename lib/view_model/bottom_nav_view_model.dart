import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Repository/home_api/home_api_repo.dart';
import '../configs/utils.dart';
import '../model/AuthModels/MyProfileModel.dart';

class BottomNavBarViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  BottomNavigationItem _currentItem = BottomNavigationItem.home;


  MyProfileModel? myProfile;
  BottomNavigationItem get currentItem => _currentItem;

  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();
  Future<void> getMyProfile(BuildContext context) async {
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    try {
      MyProfileModel response = await homeRepo.getMyProfile(headers);

      if (response.status!) {
        myProfile = response;
        print("farhannnn");
        print(myProfile);
        notifyListeners();
      }
    } catch (error) {
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  }
  void changeCurrentItem(BottomNavigationItem item) {
    _currentItem = item;
    notifyListeners();
  }

  Future<bool> onWillPop() async {
    if (_currentItem == BottomNavigationItem.home) {
      SystemNavigator.pop();
    } else {
      changeCurrentItem(BottomNavigationItem.home);
    }
    return false;
  }

}

enum BottomNavigationItem { home, search, create, saved, profile }
