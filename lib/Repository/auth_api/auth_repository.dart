import 'dart:io';

import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/model/AuthModels/SignUpModel.dart';
import 'package:val_app/model/occupation_model.dart';
import 'package:val_app/model/skills_model.dart';

import '../../model/signup_skill_model.dart';

abstract class AuthRepository {
  Future<SignInModel?> socialLoginApi(dynamic data, var headers);
  Future<SignInModel?> loginApi(dynamic data, var headers);
  Future<SignupModel?> signUpApi(dynamic data, var headers);
  Future<dynamic> forgetPass({dynamic data, var headers});
  Future<dynamic> otp({dynamic data, var headers});
  Future<dynamic> createPassword({dynamic data, var headers});
  Future<OccupationModel?> getOccupation();
  Future<SkillsModel?> getSkills();
  Future<SignupSkillsModel?> getSignupSkills(dynamic data, var headers);
  Future<FilteredSkillsModel?> postOccupation(dynamic data, var headers);
  Future<CreateProfileModel?> createProfileApi(dynamic data, var headers, File? coverImg, File? main_image);
  Future<CreateProfileModel?> editProfileApi(dynamic data, var headers, File? coverImg, File? main_image);
}
