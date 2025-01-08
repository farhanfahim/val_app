import 'package:flutter/material.dart';
import 'package:val_app/model/search_project_model.dart';

import '../../Repository/search/search_api_repo.dart';
import '../../configs/utils.dart';
import '../../model/AuthModels/MyProfileModel.dart';

class SearchViewModel extends ChangeNotifier {
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode focusSearch = FocusNode();

  bool isLoading = false;
  List<Projects> searchResults = [];
  Future<void> searchProjects(BuildContext context,query) async {
    isLoading = true;
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    var data = {
      "search_tag": query.trim(),
    };
    try {
      var response = await SearchHttpApiRepository().searchProjects(headers:headers,data: data);
      if (response['status'] == true) {
        var data = SearchProjectModel.fromJson(response);
        searchResults = data.data!.projects!;
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

  onTapSearch(context,query){
    if(query.isNotEmpty) {
      searchTextEditingController.text = query.toString();
      searchProjects(context, query);
    }else{
      searchTextEditingController.text ="";
      searchResults.clear();
    }
    notifyListeners();
  }


}
