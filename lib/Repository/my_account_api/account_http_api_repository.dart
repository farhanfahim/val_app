import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import 'account_repository.dart';

class AccountHttpApiRepository implements AccountRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future changePassword({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.changePassword, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future sendQuery({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.sendQuery, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future deleteAccount({data, headers}) async {
    try {
      dynamic response = await _apiServices.getDeleteApiResponse(url: AppUrl.deleteAccount, data: data, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getFAQ({headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getFAQ, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getFollowersFollowing({headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.myFollowersFollowing, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getOtherUserFollowersFollowing({headers, String? id}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.otherUserFollowersFollowing + '$id/', headers: headers);

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
  Future reportProfile({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.reportProfile, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future reportProject({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.reportProject, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getTerms({headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getTerms, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getPrivacy({headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getPrivacy, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getInterest({headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getInterest, headers: headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future addInterest({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.addInterest, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future notificationToggle({ headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.notificationToggle, headers:  headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getNotificationToggle({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getNotificationToggle,headers:   headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future getBlockList({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.blockList, headers:headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
