import 'package:val_app/data/Network/base_api_services.dart';
import 'package:val_app/data/Network/network_api_services.dart';
import '../../configs/app_urls.dart';
import 'search_repo.dart';

class SearchHttpApiRepository implements SearchRepository {

  final BaseApiServices _apiServices = NetworkApiService();

  @override
  Future getFilterCategory({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getFilterCategory, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future getRecentSearches({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.getRecentSearches, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future removeAllRecentSearches({data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.removeAllRecentSearches, headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future removeRecentSearches(id,{data, headers}) async {
    try {
      dynamic response = await _apiServices.getGetApiResponse(AppUrl.removeRecentSearches+"?search_id=$id", headers: headers);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  @override
  Future saveFilter({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.filterSave, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future searchProjects({data, headers}) async {
    try {
      dynamic response = await _apiServices.getPostApiResponse(AppUrl.searchProjects, data, headers);

      return response;
    } catch (e) {
      rethrow;
    }
  }


}
