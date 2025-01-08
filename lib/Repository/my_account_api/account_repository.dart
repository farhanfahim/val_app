abstract class AccountRepository {
  Future<dynamic> changePassword({dynamic data, var headers});
  Future<dynamic> sendQuery({dynamic data, var headers});
  Future<dynamic> deleteAccount({dynamic data, var headers});
  Future<dynamic> getFAQ({var headers});
  Future<dynamic> getFollowersFollowing({var headers});
  Future<dynamic> getOtherUserFollowersFollowing({var headers});
  Future<dynamic> blockUser({dynamic data, var headers});
  Future<dynamic> unblockUser({dynamic data, var headers});
  Future<dynamic> reportProfile({dynamic data, var headers});
  Future<dynamic> reportProject({dynamic data, var headers});
  Future<dynamic> getTerms({var headers});
  Future<dynamic> getPrivacy({var headers});
  Future<dynamic> getInterest({var headers});
  Future<dynamic> addInterest({dynamic data, var headers});
  Future<dynamic> notificationToggle({var headers});
  Future<dynamic> getNotificationToggle({var headers});
  Future<dynamic> getBlockList({var headers});
}
