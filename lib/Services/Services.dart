import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/model/AuthModels/SignUpModel.dart';

class Services {
  Future callSignupApi(context, Map<String, dynamic> postData) async {
    Utils().loadingDialog(context);
    SignupModel? data;
    var headers = {'Content-Type': 'application/json'};
    String jsonBody = json.encode(postData);
    final uri = Uri.parse(AppUrl.registerApiEndPoint);
    try {
      final response = await http.post(uri, headers: headers, body: jsonBody);
      var res_data = json.decode(response.body);
      if (res_data['status']) {
        Navigator.pop(context);
        final res_data = json.decode(response.body);
        data = SignupModel.fromJson(res_data); // Mapping json response to our data model
        Utils.toastMessage(data.message.toString());
        Navigator.pushNamed(context, RoutesName.createProfile, arguments: {'isEdit': false});
      } else {
        print('Error Occurred');
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error Occurred' + e.toString());
      Navigator.pop(context);
    }
    return data;
  }

  Future callSignInApi(context, Map<String, dynamic> postData) async {
    Utils().loadingDialog(context);
    SignInModel? data;
    var headers = {'Content-Type': 'application/json'};
    String jsonBody = json.encode(postData);
    final uri = Uri.parse(AppUrl.loginEndPint);
    try {
      final response = await http.post(uri, headers: headers, body: jsonBody);
      var res_data = json.decode(response.body);
      if (res_data['status']) {
        Navigator.pop(context);
        final res_data = json.decode(response.body);
        data = SignInModel.fromJson(res_data); // Mapping json response to our data model
        if (data.data != null) {
          final SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString("accessToken", data.data!.access.toString());
          _prefs.setString("refreshToken", data.data!.refresh.toString());
          _prefs.setString("userId", data.data!.pk.toString());
        }

        Utils.toastMessage(data.message.toString());
        Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
      } else {
        print('Error Occurred');
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error Occurred ' + e.toString());
      Navigator.pop(context);
    }
    return data;
  }

  Future callCreateProfileApi(context, Map<String, String> postData, File? profileImage, File? coverImg) async {
    Utils().loadingDialog(context);
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.getString("accessToken");

    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer ${_prefs.getString("accessToken")}'};

    final uri = Uri.parse(AppUrl.createProfileApiEndPoint);
    try {
      var request = http.MultipartRequest('POST', uri);

      request.fields.addAll(postData);
      request.headers.addAll(headers);

      if (profileImage != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'main_image',
          profileImage.path,
          filename: profileImage.path.split('/').last,
        );
        request.files.add(
          multipartFile,
        );
      }
      if (coverImg != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'cover_image',
          coverImg.path,
          filename: coverImg.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      var response = await request.send();

      final res = await http.Response.fromStream(response);
      var res_data = json.decode(res.body.toString());

      if (res_data['status']) {
        Navigator.pop(context);

        Utils.toastMessage("profile created successfully");
        // Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
      } else {
        print('Error Occurred');
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error Occurred ' + e.toString());
      Navigator.pop(context);
    }
  }
}
