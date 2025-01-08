import 'dart:io';

import 'package:val_app/Repository/project_api/project_repo.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/categories_model.dart';
import 'package:val_app/model/media_file_model.dart';
import 'package:val_app/model/tools_model.dart';
import 'package:val_app/view_model/project/create_project_view_model.dart';

class ProjectHttpApiRepository implements ProjectRepository {
  final BaseApiServices _apiServices = NetworkApiService();
  @override
  Future<dynamic> createProjectApi(data, headers, {File? coverImg, File? main_image, int? index, List<MediaFile>? media, String? multipartkey}) async {
    try {
      dynamic response = await _apiServices.getPostMultipartApiResponse(
        AppUrl.createProjectApiEndPoint,
        data,
        headers,
        multipartkey: multipartkey,
        media: media,
        index: index,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> editProject(
    data,
    headers, {
    File? coverImg,
    File? main_image,
    int? index,
    List<MediaFile>? media,
    String? multipartkey,
    String? id,
  }) async {
    try {
      dynamic response = await _apiServices.getPutMultipartApiResponse(
        AppUrl.editProjectApiEndPoint + "${id}/",
        data,
        headers,
        multipartkey: multipartkey,
        media: media,
        index: index,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoriesModel?> getCategories() async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.categoriesList);
      return CategoriesModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ToolsModel?> postCategory(var data, var headers) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.fillteredTools, data, headers);
      return ToolsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CreateProfileModel?> editProjectApi(data, headers, {File? coverImg, File? main_image, int? index, List<MediaFile>? media, String? multipartkey}) async {
    try {
      dynamic response = await _apiServices.getPostMultipartApiResponse(
        AppUrl.createProjectApiEndPoint,
        data,
        headers,
        multipartkey: multipartkey,
        media: media,
        index: index,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectComment({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.projectComment + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectLike({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.projectLike + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectRate({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.projectRate + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectView({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.projectView + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectSave({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.projectSave + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future projectDelete({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse(url: AppUrl.projectDelete + '$id/', data: data, headers: headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getComments(var headers, {String? id}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getComment + "$id", headers: headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
