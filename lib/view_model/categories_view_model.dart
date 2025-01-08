import 'package:flutter/material.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/model/category_model.dart';

import '../configs/routes/routes_name.dart';
import '../configs/utils.dart';
import '../model/CategoriesModelFeeds.dart';

class CategoriesViewModel extends ChangeNotifier {
  bool isLoading = true;
  List<CategoryData> categoriesList = [];
  CategoriesModelFeeds? categoriesProject;
  bool categoriesLoader = true;

  Future<void> getCategories(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await HomeHttpApiRepository().getCategories(headers: headers);
      if (response['status'] == true) {
        final categories = CategoryModel.fromJson(response);
        categoriesList = categories.data ?? [];
        notifyListeners();
        print(response.toString());
        if (isPullToRefresh == false) Navigator.pop(context);
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

  sortedcate() {
    for (var project in categoriesProject!.data!) {
      project.mediaFiles!.sort((a, b) => b.isCover! ? 1 : -1);
    }
  }

  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> getCategoriesById(BuildContext context, {required String id, required int index}) async {
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
        Navigator.pushNamed(context, RoutesName.categoryDetail, arguments: {"title": categoriesList[index].name.toString()});

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
}
