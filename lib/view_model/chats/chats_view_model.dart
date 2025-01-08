import 'package:flutter/material.dart';
import 'package:val_app/model/chat_home_model.dart';

class ChatsViewModel extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();

  bool _isSearchActive = false;
  bool get isSearchActive => _isSearchActive;

  void toggleSearch() {
    _isSearchActive = !_isSearchActive;
    notifyListeners();
  }

  void hideSearch() {
    _isSearchActive = false;
    notifyListeners();
  }
}