import 'dart:io';

import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/model/AuthModels/SignUpModel.dart';
import 'package:val_app/model/occupation_model.dart';
import 'package:val_app/model/skills_model.dart';
import '../../model/AuthModels/MyProfileModel.dart';
import '../../model/signup_skill_model.dart';
import 'auth_repository.dart';

class AuthHttpApiRepository implements AuthRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future<SignInModel> loginApi(dynamic data, var headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPint, data, headers);
      return SignInModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getMyProfile(var headers) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getMyProfile, headers: headers);
      return MyProfileModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SignInModel> socialLoginApi(dynamic data, var headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.socialLoginEndPint, data, headers);
      return SignInModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SignupModel> signUpApi(dynamic data, var headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.registerApiEndPoint, data, headers);
      return SignupModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateProfileModel?> createProfileApi(data, headers, File? coverImg, File? main_image) async {
    try {
      dynamic response = await _apiServices.getPostMultipartApiResponse(
        AppUrl.createProfileApiEndPoint,
        data,
        headers,
        coverImg: coverImg,
        mainImg: main_image,
      );
      return CreateProfileModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OccupationModel?> getOccupation() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getOccupationsApiEndPoint);
      return OccupationModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SkillsModel?> getSkills() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getSkillsApiEndPoint);
      return SkillsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SignupSkillsModel?> getSignupSkills(data, headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.getSkillsApiEndPoint2, data, headers);
      return SignupSkillsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FilteredSkillsModel?> postOccupation(data, headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.getPosFliteredSkillsApiEndPoint, data, headers);
      print("asd" + response.toString());
      return FilteredSkillsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateProfileModel?> editProfileApi(data, headers, File? coverImg, File? main_image) async {
    try {
      dynamic response = await _apiServices.getPostMultipartApiResponse(AppUrl.createProfileApiEndPoint, data, headers, coverImg: coverImg, mainImg: main_image);
      return CreateProfileModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> forgetPass({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.forgetPass, data, headers);
      // return SignInModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> otp({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.confirmOtp, data, headers);
      // return SignInModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future createPassword({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.createPassword, data, headers);
      // return SignInModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
