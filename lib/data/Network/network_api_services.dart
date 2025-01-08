import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:val_app/configs/utils.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/app_exceptions.dart';
import 'package:val_app/view/auth_view/login.dart';
import '../../configs/sharedPerfs.dart';
import '../../firestore/firestore_controller.dart';
import '../../main.dart';
import '../../model/media_file_model.dart';

class NetworkApiService implements BaseApiServices {
  @override
  Future getGetApiResponse(String url, {var headers}) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 60));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }
  @override
  Future getGetApiResponse2(String url, dynamic params,{var headers}) async {
    if (kDebugMode) {
      print(url);
      print(params);
    }
    dynamic responseJson;
    try {
      var stringUrl = Uri.parse(url!);
      Uri uri = Uri.https(stringUrl.authority, stringUrl.path, params);
      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 60));
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data, var headers) async {
    if (kDebugMode) {
      print(url);
      print(data);
      print("headers: " + headers.toString());
    }

    dynamic responseJson;
    try {
      Response response = await post(Uri.parse(url), body: data, headers: headers).timeout(const Duration(seconds: 60));

      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } catch (e) {
      Utils.toastMessage(e.toString());
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getPutApiResponse(String url, data, headers) async {
    if (kDebugMode) {
      print(url);
      print(data);
      print("headers: " + headers.toString());
    }

    dynamic responseJson;
    try {
      Response response = await put(Uri.parse(url), body: data, headers: headers).timeout(const Duration(seconds:60));

      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } catch (e) {
      Utils.toastMessage(e.toString());
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  @override
  Future getPostMultipartApiResponse(String url, Map<String, String> Fields, headers, {File? mainImg, File? coverImg, List<MediaFile>? media, List<File>? file, String? multipartkey, int? index}) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields to the request
      request.fields.addAll(Fields);

      // Add headers to the request
      request.headers.addAll(headers);

      // Add main image if provided
      if (mainImg != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'main_image',
          mainImg.path,
          filename: mainImg.path.split('/').last,
        );
        request.files.add(
          multipartFile,
        );
      }
      // Add cover image if provided
      if (coverImg != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'cover_image',
          coverImg.path,
          filename: coverImg.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      // Add media files if provided
      if (media != null) {
        for (var i = 0; i < media.length; i++) {
          var multipartFile = await http.MultipartFile.fromPath(
            multipartkey!,
            media[i].path,
            filename: media[i].path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Add media files if provided
      if (file != null) {
        for (var i = 0; i < file.length; i++) {
          var multipartFile = await http.MultipartFile.fromPath(
            multipartkey!,
            file[i].path,
            filename: file[i].path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Send the request
      StreamedResponse streamedResponse = await request.send();

      Response response = await http.Response.fromStream(streamedResponse);
      // Handle the response

      responseJson = returnResponse(response);
      return responseJson;
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }
  
  @override
  Future getPutMultipartApiResponse(String url, Map<String, String> Fields, headers, {File? mainImg, File? coverImg, List<MediaFile>? media, List<File>? file, String? multipartkey, int? index}) async {
    dynamic responseJson;
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(url));

      // Add fields to the request
      request.fields.addAll(Fields);

      // Add headers to the request
      request.headers.addAll(headers);

      // Add main image if provided
      if (mainImg != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'main_image',
          mainImg.path,
          filename: mainImg.path.split('/').last,
        );
        request.files.add(
          multipartFile,
        );
      }
      // Add cover image if provided
      if (coverImg != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'cover_image',
          coverImg.path,
          filename: coverImg.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
      // Add media files if provided
      if (media != null) {
        for (var i = 0; i < media.length; i++) {
          var multipartFile = await http.MultipartFile.fromPath(
            multipartkey!,
            media[i].path,
            filename: media[i].path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Add media files if provided
      if (file != null) {
        for (var i = 0; i < file.length; i++) {
          var multipartFile = await http.MultipartFile.fromPath(
            multipartkey!,
            file[i].path,
            filename: file[i].path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      // Send the request
      StreamedResponse streamedResponse = await request.send();

      Response response = await http.Response.fromStream(streamedResponse);
      // Handle the response

      responseJson = returnResponse(response);
      return responseJson;
    } catch (e) {
      Utils.toastMessage(e.toString());
    }
  }

  dynamic returnResponse(http.Response response) {
    if (kDebugMode) {
      print(response.statusCode);
    }

    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 201:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        String id = SharedPrefs.instance.getString("userId") ?? "";
        SharedPrefs.instance.clearPrefsSpecific('accessToken');
        SharedPrefs.instance.clearPrefsSpecific('refreshToken');
        SharedPrefs.instance.clearPrefsSpecific('userId');
        dynamic responseJson = jsonDecode(response.body);
        Utils.toastMessage('Token Expired, Login to continue');
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (c) => const LoginView()));
        });
        return responseJson;

      case 500:
        throw FetchDataException('Error occured while communicating with server');
      case 404:
        throw UnauthorisedException(response.body.toString());

      default:
        throw FetchDataException('Error occured while communicating with server');
    }
  }

  @override
  Future getDeleteApiResponse({required String url, data, required headers}) async {
    dynamic responseJson;
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);
      responseJson = returnResponse(response);
      return responseJson;
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    } catch (e) {
      Utils.toastMessage(e.toString());
      rethrow;
    }
  }
}
