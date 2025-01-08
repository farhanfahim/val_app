import 'package:flutter/material.dart';
import '../../model/filter_category_model.dart';

class FilterToolsViewModel extends ChangeNotifier {
  TextEditingController searchTextEditingController = TextEditingController();
  FocusNode focusSearch = FocusNode();

  List<CatTools> filteredToolsList = [];
  List<CatTools> tempRemoveList = [];
  List<CatTools> tempList = [];
  List<CatTools> preSelectedToolsList = [];
  List<int> selectedToolsIds = [];

  void toggleToolsSelection(CatTools tool) {
    if (selectedToolsIds.contains(tool.id)) {
      tool.isSelected = false;
      selectedToolsIds.remove(tool.id);
      tempRemoveList.add(tool);
    } else {
      tool.isSelected = true;
      selectedToolsIds.add(tool.id!);
      tempList.add(tool);
    }
    notifyListeners();
  }

  List<CatTools> getSelectedTools(List<CatTools> tool) {
    return tool.where((cat) => selectedToolsIds.contains(cat.id)).toList();
  }

  setPreSelectedTools(List<CatTools> tool) {
    preSelectedToolsList = tool;
    filteredToolsList = tool;
    for(var item in preSelectedToolsList){
      if(item.isSelected!){
        selectedToolsIds.add(item.id!);
      }
    }
    notifyListeners();
  }

  onBackPress(context){
    for(var item in tempList){
      for(var item2 in filteredToolsList){
        if(item.id == item2.id){
          item.isSelected = false;
          selectedToolsIds.remove(item.id);
        }
      }
    }
    for(var item in tempRemoveList){
      for(var item2 in filteredToolsList){
        if(item.id == item2.id){
          item.isSelected = true;
          selectedToolsIds.add(item.id!);
        }
      }
    }
    notifyListeners();
    Navigator.pop(context, getSelectedTools(filteredToolsList));
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      filteredToolsList = preSelectedToolsList;
    } else {
      filteredToolsList = preSelectedToolsList
          .where((item) => item.tool!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    searchTextEditingController.text = query;
    notifyListeners();
  }

}