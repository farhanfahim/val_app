
abstract class HomeRepository {
  Future<dynamic> getMyProfile(var headers);
  Future<dynamic> getMyProfileDetail(var data, var headers);
  Future<dynamic> getSaveProfile({var data, var headers});
  Future<dynamic> getFollowProfile({var data, var headers});
  Future<dynamic> getAllFeeds({var data, var headers});
  Future<dynamic> getAllSavedProjects({var data, var headers});
  Future<dynamic> getCategoriesById({var data, var headers});
  Future<dynamic> getOtherUser({var data, var headers});
  Future<dynamic> getNotifications({var data, var headers});
  Future<dynamic> getCategories({var data, var headers});
  Future<dynamic> getNotificationCount({var data, var headers});
  Future<dynamic> logout({var data, var headers});
  Future<dynamic> pingApi({var data, var headers});
}
