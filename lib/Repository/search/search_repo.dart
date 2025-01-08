import 'dart:io';

import '../../view_model/chats/chat_detail_view_model.dart';
import '../../view_model/project/create_project_view_model.dart';

abstract class SearchRepository {
  Future<dynamic> getFilterCategory({dynamic data, var headers});
  Future<dynamic> saveFilter({dynamic data, var headers});
  Future<dynamic> searchProjects({dynamic data, var headers});
  Future<dynamic> getRecentSearches({dynamic data, var headers});
  Future<dynamic> removeAllRecentSearches({dynamic data, var headers});
  Future<dynamic> removeRecentSearches(String id,{dynamic data, var headers});

}
