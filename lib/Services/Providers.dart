import 'dart:io';

import 'package:flutter/material.dart'; 
import 'package:val_app/Services/Services.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/model/AuthModels/SignUpModel.dart';

class DataProvider with ChangeNotifier {
  SignupModel? data;
  SignInModel? signInData;
  bool loading = false;
  Services services = Services();

  postSignUpData(context, Map<String, dynamic> postData) async {
    loading = true;
    data = await services.callSignupApi(context, postData);
    loading = false;

    notifyListeners();
  }

  postSignInData(context, Map<String, dynamic> postData) async {
    loading = true;
    signInData = await services.callSignInApi(context, postData);
    loading = false;

    notifyListeners();
  }

  postCreateProfileData(context, Map<String, String> postData, File? profileImage, File? coverImg) async {
    loading = true;
    signInData = await services.callCreateProfileApi(context, postData, profileImage, coverImg);
    loading = false;

    notifyListeners();
  }
}
