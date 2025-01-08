import 'package:val_app/Repository/home_api/home_repo.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import 'package:val_app/model/AuthModels/MyProfileModel.dart';
import 'package:val_app/model/SavedProjectModel.dart';
import 'package:val_app/model/feedModel.dart';
import 'package:val_app/model/otherUserProfileModel.dart';
import 'package:val_app/model/postDetailModel.dart';

import '../../model/CategoriesModelFeeds.dart';
import '../../model/ping_model.dart';
import '../../model/user_post_detail_model.dart';
import '../../model/notification_list_model.dart';
import '../../view_model/home_view_model.dart';

class HomeHttpApiRepository implements HomeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

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
  Future getMyProfileDetail(var headers, var data, {String? id}) async {
    try {
      print(data);
      dynamic response = await _apiServices.getGetApiResponse2(AppUrl.projectDetail + '$id/',data, headers: headers);
      // return UserPostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getSaveProfile({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.profileSave + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getFollowProfile({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.profileFollow + '$id/', data, headers);
      // return PostDetailModel.fromJson(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getAllFeeds({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse2(AppUrl.getFeeds,data, headers: headers);
      return FeedModel.fromJson(response);
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getNotificationCount({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getNotificationCount, headers: headers);
      return NotitficationCountModel.fromJson(response);
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getAllSavedProjects({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse2(AppUrl.getAllSavedProject,data, headers: headers);
      return SavedProjectModel.fromJson(response);
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getCategoriesById({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse2(AppUrl.categoriesFeed + '$id/',data, headers: headers);
      return CategoriesModelFeeds.fromJson(response);
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getOtherUser({data, headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.otherUser + '$id/', headers: headers);
      return OtherUserProfileModel.fromJson(response);
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getNotifications({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.notificationList, headers: headers);

      return response;

    } catch (e) {
      rethrow;
    }
  } 
    @override
  Future getCategories({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getCategories, headers: headers);
 
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future logout({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.signOut, data, headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future pingApi({data, headers}) async {
    try {
      PingModel response = await _apiServices.getGetApiResponse(AppUrl.pingAPi,  headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

}
