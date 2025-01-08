import 'dart:convert';

import 'package:flutter/material.dart';
import '../../Repository/search/search_api_repo.dart';
import '../../configs/utils.dart';
import '../../model/filter_category_model.dart';

class FilterViewModel extends ChangeNotifier {
  TextEditingController categoryTextEditingController = TextEditingController();
  TextEditingController toolsTextEditingController = TextEditingController();
  FocusNode focusCategory = FocusNode();
  FocusNode focusTools = FocusNode();
  List<FilterCategoryData> selectedCategories = [];
  List<CatTools> tools = [];
  List<CatTools> selectedTools = [];

  bool isLoading = true;

  void updateSelectedCategories(List<FilterCategoryData> categories) {
    tools.clear();
    for(var item in selectedTools){
      tools.add(item);
    }
    selectedCategories = categories;
    for(var item1 in selectedCategories){
      for(var item2 in item1.tools!){
          if (!tools.any((tool) => tool.tool == item2.tool)) {
            item2.isSelected = false;
            tools.add(item2);
          }
        }
    }
    notifyListeners();
  }

  void removeSelectedCategory(FilterCategoryData category) {
    tools.clear();
    for(var item in selectedTools){
      tools.add(item);
    }
    selectedCategories.remove(category);
    for(var item1 in selectedCategories){
      for(var item2 in item1.tools!){
        if (!tools.any((tool) => tool.tool == item2.tool)) {
          tools.add(item2);
        }
      }
    }
    notifyListeners();
  }

  void updateSelectedTools(List<CatTools> tools) {
    selectedTools = tools;
    notifyListeners();
  }

  void removeSelectedTools(CatTools tool) {

    selectedTools.remove(tool);
    tools.clear();
    for(var item in selectedTools){
      tools.add(item);
    }
    for(var item1 in selectedCategories){
      for(var item2 in item1.tools!){
        if (!tools.any((tool) => tool.tool == item2.tool)) {
          item2.isSelected = false;
          tools.add(item2);
        }
      }
    }
    notifyListeners();
  }


Future<void> getFilterCategory(BuildContext context) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await SearchHttpApiRepository().getFilterCategory(headers:headers);
      if (response['status'] == true) {
        final comments = FilterCategoryModel.fromJson(response);

        for (var item1 in comments.data!) {
          if (item1.isSelected!) {
            selectedCategories.add(item1);
            for(var item2 in item1.tools!){
              tools.add(item2);
              if(item2.isSelected!) {
                selectedTools.add(item2);
              }
            }
          }

        }
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

  Future<void> saveFilter(BuildContext context,bool isEmpty) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    Map<String, dynamic> data = {};
    List<int> catId = [];
    List<int> toolId = [];

    for(var item in selectedCategories){
      catId.add(item.id!);
    }
    for(var item in selectedTools){
      toolId.add(item.id!);
    }
    if(isEmpty) {
      data['category_ids'] = [];
      data['tool_ids'] = [];
    }else{
      data['category_ids'] = catId;
      data['tool_ids'] = toolId;
    }

    print("data:" + data.toString());
    try {
      dynamic response = await SearchHttpApiRepository().saveFilter(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
  }
}
