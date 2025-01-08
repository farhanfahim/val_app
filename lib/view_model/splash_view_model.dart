import 'package:flutter/material.dart';
import 'package:val_app/configs/sharedPerfs.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _isLoading = false;
    notifyListeners();
  }

  String token = SharedPrefs.instance.getString("accessToken") ?? "";
  bool isProfileDone = SharedPrefs.instance.getBool("isDone") ?? false;
}
