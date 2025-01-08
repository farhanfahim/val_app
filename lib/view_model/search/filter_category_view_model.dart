import 'package:flutter/material.dart';
import '../../Repository/search/search_api_repo.dart';
import '../../configs/utils.dart';
import '../../model/categories_model.dart';
import '../../model/filter_category_model.dart';

class FilterCategoryViewModel extends ChangeNotifier {
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode focusSearch = FocusNode();
  List<FilterCategoryData> preSelectedCategoriesList = [];
  List<int> selectedCategoryIds = [];


  void toggleCategorySelection(FilterCategoryData category) {
    if (selectedCategoryIds.contains(category.id)) {
      category.isSelected = false;
      selectedCategoryIds.remove(category.id);
    } else {
      category.isSelected = true;
      selectedCategoryIds.add(category.id!);
    }
    notifyListeners();
  }

  List<FilterCategoryData> getSelectedCategories(List<FilterCategoryData> allCategories) {
    return allCategories.where((cat) => selectedCategoryIds.contains(cat.id)).toList();
  }

   setPreSelectedCategories(List<FilterCategoryData> allCategories) {
     preSelectedCategoriesList = allCategories;
     notifyListeners();
  }

  bool isLoading = true;
  List<FilterCategoryData> commentsList = [];
  List<FilterCategoryData> filteredCommentsList = [];

  Future<void> getFilterCategory(BuildContext context, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await SearchHttpApiRepository().getFilterCategory(headers:headers);
      if (response['status'] == true) {
        final comments = FilterCategoryModel.fromJson(response);

        commentsList = comments.data ?? [];
        filteredCommentsList = comments.data ?? [];
        final selectedCategories = Set.from(preSelectedCategoriesList.map((item) => item.category));

        for (var item1 in commentsList) {
          if (selectedCategories.contains(item1.category)) {
            item1.isSelected = true;
            selectedCategoryIds.add(item1.id!);
          }else{
            item1.isSelected = false;
          }
        }

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


  void filterItems(String query) {
    if (query.isEmpty) {
      filteredCommentsList = commentsList;
    } else {
      filteredCommentsList = commentsList
          .where((item) => item.category!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }

}
