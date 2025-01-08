class AppUrl {
  // static String baseUrl = 'http://10.0.11.193:8000';
  static String baseUrl = 'https://dev5.cryscampus.com';
  //-------------------Auth------------------------------------------
  static String loginEndPint = '$baseUrl/user_management/signin/';
  static String socialLoginEndPint = '$baseUrl/user_management/social_auth/';
  static String registerApiEndPoint = '$baseUrl/user_management/signup/';
  static String forgetPass = '$baseUrl/auth/password_reset/request_otp/';
  static String confirmOtp = '$baseUrl/auth/password_reset/confirm_otp/';
  static String createPassword = '$baseUrl/user_management/update_password/';
  static String signOut = '$baseUrl/user_management/signout/';
  static String pingAPi = '$baseUrl/user_management/last_activity/';

  //-------------------Profile CRUD------------------------------------------
  static String createProfileApiEndPoint = '$baseUrl/user_management/val_profile/';
  static String getOccupationsApiEndPoint = '$baseUrl/user_management/occupations_list/';
  static String getSkillsApiEndPoint = '$baseUrl/user_management/tools_list/';
  //static String getSkillsApiEndPoint2 = '$baseUrl/user_management/filtered_tools/';
  static String getSkillsApiEndPoint2 = '$baseUrl/user_management/skills_check/';
  static String getPosFliteredSkillsApiEndPoint = '$baseUrl/user_management/flitered_skills/';
  static String getMyProfile = '$baseUrl/user_management/get_profile/';
  static String editMyProfile = '$baseUrl/user_management/update_valprofile/';
  static String profileSave = '$baseUrl/user_management/profile/saved/';
  static String profileFollow = '$baseUrl/user_management/profile/follow/';
  //-------------------Project CRUD------------------------------------------
  static String projectDetail = '$baseUrl/user_management/project/';
  static String createProjectApiEndPoint = '$baseUrl/user_management/project_create/';
  static String editProjectApiEndPoint = '$baseUrl/user_management/update_project/';
  static String categoriesList = '$baseUrl/user_management/category_list/';
  static String fillteredTools = '$baseUrl/user_management/filtered_tools/';

  static String projectLike = '$baseUrl/user_management/project/like/';
  static String projectComment = '$baseUrl/user_management/project/comment/';
  static String projectView = '$baseUrl/user_management/project/viewed/';
  static String projectRate = '$baseUrl/user_management/project/rate/';
  static String projectSave = '$baseUrl/user_management/project/saved/';
  static String projectDelete = '$baseUrl/user_management/project/delete/';
  static String getAllSavedProject = '$baseUrl/user_management/feed/saved/';
  //-------------------home------------------------------------------
  static String getFeeds = '$baseUrl/user_management/feed/view/';
  static String categoriesFeed = '$baseUrl/user_management/category_feed/view/';
  static String otherUser = '$baseUrl/user_management/get_profile/';
  static String notificationList = "$baseUrl/notification/usernotification/";
  static String getNotificationCount = "$baseUrl/notification/notificationlist/";

  //-------------------chat------------------------------------------
  static String get addMsg => "$baseUrl/chat/send_message_url/";

  //-------------------account------------------------------------------
  static String changePassword = '$baseUrl/user_management/change_password/';
  static String sendQuery = '$baseUrl/user_management/post_user_query/';
  static String deleteAccount = '$baseUrl/user_management/delete_account/';
  static String getFAQ = '$baseUrl/user_management/get_faq/';
  static String myFollowersFollowing = '$baseUrl/user_management/follower_following/';
  static String otherUserFollowersFollowing = '$baseUrl/user_management/follower_following_user/';
  static String blockUser = '$baseUrl/user_management/block/';
  static String unblockUser = '$baseUrl/user_management/unblock/';
  static String reportProfile = '$baseUrl/user_management/report_profile/';
  static String reportProject = '$baseUrl/user_management/project/reports/';
  static String getTerms = '$baseUrl/user_management/get_terms_conditions/';
  static String getPrivacy = '$baseUrl/user_management/get_privacy_policy/';
  static String getInterest = '$baseUrl/user_management/interest_list/';
  static String addInterest = '$baseUrl/user_management/val_profile_interest/';
  static String notificationToggle = '$baseUrl/notification/notification_setting/';
  static String getNotificationToggle = '$baseUrl/user_management/get_notification_toggle/';
  static String blockList = "$baseUrl/user_management/block_list/";

  static String get block => "$baseUrl/user_management/block/";
  static String get getComment => "$baseUrl/user_management/project/all_comments/";
  static String get getCategories => "$baseUrl/user_management/category_list/";
  static String get sendPush => "$baseUrl/user_management/send_push//";
  //-------------------account------------------------------------------

  static String get getFilterCategory => "$baseUrl/user_management/filter_category/";
  static String get filterSave => "$baseUrl/user_management/category_tools_filter_save/";
  static String get searchProjects => "$baseUrl/user_management/search_view/";
  static String get getRecentSearches => "$baseUrl/user_management/get_recent_search/";
  static String get removeAllRecentSearches => "$baseUrl/user_management/remove_all_recent_search/";
  static String get removeRecentSearches => "$baseUrl/user_management/remove_recent_search/";
}
