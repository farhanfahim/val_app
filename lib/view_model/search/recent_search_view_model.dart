import 'package:flutter/material.dart';

import '../../Repository/search/search_api_repo.dart';
import '../../configs/utils.dart';
import '../../model/AuthModels/MyProfileModel.dart';
import '../../model/recent_search_model.dart';

class RecentSearchViewModel extends ChangeNotifier {
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode focusSearch = FocusNode();

  bool isLoading = true;
  List<RecentData> recentSearches = [];
  Future<void> getRecentSearches(context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await SearchHttpApiRepository().getRecentSearches(headers:headers );
      if (response['status'] == true) {
        var data = RecentSearchModel.fromJson(response);
        
        recentSearches = data.data!;
        print(response.toString());
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }
  Future<void> clearAllRecentSearches(context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await SearchHttpApiRepository().removeAllRecentSearches(headers:headers );
      if (response['status'] == true) {
        recentSearches.clear();
        print(response.toString());
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }
  Future<void> clearRecentSearches(context,index) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await SearchHttpApiRepository().removeRecentSearches(recentSearches[index].searchId!.toString() ,headers:headers );
      if (response['status'] == true) {
        recentSearches.removeAt(index);
        print(response.toString());
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }

}
