import 'dart:io';
import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/categories_model.dart';

abstract class ProjectRepository {
  Future<CategoriesModel?> getCategories();
  Future<dynamic> postCategory(var data, var headers);
  Future<dynamic> createProjectApi(dynamic data, var headers, {File? coverImg, File? main_image});
  Future<dynamic> editProject(dynamic data, var headers, {File? coverImg, File? main_image});
  Future<CreateProfileModel?> editProjectApi(dynamic data, var headers, {File? coverImg, File? main_image});
  Future<dynamic> projectLike({var data, var headers});
  Future<dynamic> projectView({var data, var headers});
  Future<dynamic> projectComment({var data, var headers});
  Future<dynamic> projectRate({var data, var headers});
  Future<dynamic> projectSave({var data, var headers});
  Future<dynamic> projectDelete({var data, var headers});
  Future<dynamic> getComments(headers);
 

}
