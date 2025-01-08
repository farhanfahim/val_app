import 'dart:io';

import 'package:val_app/Repository/project_api/project_repo.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import 'package:val_app/model/AuthModels/CreateProfileModel.dart';
import 'package:val_app/model/categories_model.dart';
import 'package:val_app/model/tools_model.dart';
import 'package:val_app/view_model/project/create_project_view_model.dart';

import 'chat_repo.dart';

class ChatHttpApiRepository implements ChatRepository {

  final BaseApiServices _apiServices = NetworkApiService();
  @override
  Future<dynamic> sendAttachmentsApi(data, headers, List<File>? file, String? multipartkey) async {
    try {
      dynamic response = await _apiServices.getPostMultipartApiResponse(
        AppUrl.addMsg,
        data,
        headers,
        file: file,
        multipartkey: multipartkey,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future blockUser({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.blockUser, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future unblockUser({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.unblockUser, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendPush({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.sendPush, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

}
