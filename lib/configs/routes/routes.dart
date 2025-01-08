import 'package:flutter/material.dart';
import 'package:val_app/view/accounts/help_support.dart';
import 'package:val_app/view/accounts/setting/change_password.dart';
import 'package:val_app/view/accounts/setting/privacy.dart';
import 'package:val_app/view/accounts/setting/setting.dart';
import 'package:val_app/view/accounts/setting/terms.dart';
import 'package:val_app/view/auth_view/city.dart';
import 'package:val_app/view/auth_view/code_screen.dart';
import 'package:val_app/view/auth_view/create_password.dart';
import 'package:val_app/view/auth_view/create_profile.dart';
import 'package:val_app/view/auth_view/forgot_password.dart';
import 'package:val_app/view/auth_view/interest.dart';
import 'package:val_app/view/auth_view/login.dart';
import 'package:val_app/view/category_view/category_detail_screen.dart';
import 'package:val_app/view/chats/chat_detail_view.dart';
import 'package:val_app/view/chats/video_view.dart';
import 'package:val_app/view/create_project/create_project_view.dart';
import 'package:val_app/view/create_project/edit_project_view.dart';
import 'package:val_app/view/create_project/tools.dart';
import 'package:val_app/view/post/comments_view.dart';
import 'package:val_app/view/profiles/followers.dart';
import 'package:val_app/view/profiles/following.dart';
import 'package:val_app/view/likes.dart';
import 'package:val_app/view/notifications.dart';
import 'package:val_app/view/post/my_post_detail.dart';
import 'package:val_app/view/profiles/my_profile_view.dart';
import 'package:val_app/view/auth_view/skills.dart';
import 'package:val_app/view/category_view/categories.dart';
import 'package:val_app/view/onboard.dart';
import 'package:val_app/view/auth_view/signup_view.dart';
import 'package:val_app/view/post/user_post_detail.dart';
import 'package:val_app/view/profiles/user_followers.dart';
import 'package:val_app/view/profiles/user_following.dart';
import 'package:val_app/view/rating_view.dart';
import 'package:val_app/view/report/project_report.dart';
import 'package:val_app/view/report/report.dart';
import 'package:val_app/view/profiles/user_profile_view.dart';
import 'package:val_app/view/saved_view.dart';
import 'package:val_app/view/search/filter_category_view.dart';
import 'package:val_app/view/search/filter_tools_view.dart';
import 'package:val_app/view/search/filters_view.dart';
import 'package:val_app/view/search/recent_search_view.dart';
import '../../model/categories_model.dart';
import '../../model/my_post_detail_model.dart';
import '../../model/filter_category_model.dart';
import '../../model/tools_model.dart';
import '../../view/auth_view/occupation.dart';
import '../../view/accounts/blocked_users.dart';
import '../../view/bottom_nav_bar.dart';
import '../../view/chats/chats_view.dart';
import '../../view/chats/image_view.dart';
import '../../view/create_project/category.dart';
import '../../view/home.dart';
import '../../view/splash.dart';
import '../../view/top_designer.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const SplashView());
      case RoutesName.onboard:
        return MaterialPageRoute(builder: (BuildContext context) => OnboardingView());
      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context) => LoginView());
      case RoutesName.signup:
        return MaterialPageRoute(builder: (BuildContext context) => const SignUpView());
      case RoutesName.home:
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RoutesName.forgotPassword:
        return MaterialPageRoute(builder: (BuildContext context) => const ForgotPasswordView());
      case RoutesName.code:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => CodeScreen(email: args['email']));
      case RoutesName.createPassword:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => CreatePasswordView(email: argumens['email']));
      case RoutesName.createProfile:
        final profileArg = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => CreateProfileView(isEdit: profileArg['isEdit']));
      case RoutesName.city:
        return MaterialPageRoute(builder: (BuildContext context) => CityView());
      case RoutesName.interest:
        return MaterialPageRoute(builder: (BuildContext context) => InterestView());
      case RoutesName.occupation:
        return MaterialPageRoute(builder: (BuildContext context) => OccupationView());
      case RoutesName.skill:
        final profileArg = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => SkillsView(isEdit: profileArg['isEdit']));
      case RoutesName.bottomNav:
        return MaterialPageRoute(builder: (BuildContext context) => BottomNavBarView());
      case RoutesName.userPostDetail:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => UserPostDetailView(id: argumens['id']));
      case RoutesName.categories:
        return MaterialPageRoute(builder: (BuildContext context) => CategoriesView());
      case RoutesName.myProfileView:
        return MaterialPageRoute(builder: (BuildContext context) => MyProfileView());
      case RoutesName.createProject:
        return MaterialPageRoute(builder: (BuildContext context) => CreateProject());
      case RoutesName.categoryList:
        return MaterialPageRoute(builder: (BuildContext context) => CategoryView());
      case RoutesName.toolsList:
        return MaterialPageRoute(builder: (BuildContext context) => ToolsView());
      case RoutesName.follower:
        return MaterialPageRoute(builder: (BuildContext context) => FollowersView());
      case RoutesName.following:
        return MaterialPageRoute(builder: (BuildContext context) => FollowingView());
      case RoutesName.report:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => ReportView(id: argumens['id']));
      case RoutesName.reportProject:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => ProjectReportView(id: argumens['id']));
      case RoutesName.userProfileView:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => UserProfileView(id: arguments['id']));
      case RoutesName.myPostDetail:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => MyPostDetailView(id: argumens['id']));
      case RoutesName.rating:
        return MaterialPageRoute(builder: (BuildContext context) => RatingView());
      case RoutesName.topRated:
        final feedArg = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => TopRatedView(feed: feedArg['feeds']));
      case RoutesName.blockedUser:
        return MaterialPageRoute(builder: (BuildContext context) => BlockedUserView());
      case RoutesName.likes:
        return MaterialPageRoute(builder: (BuildContext context) => LikesView());
      case RoutesName.saved:
        return MaterialPageRoute(builder: (BuildContext context) => SavedView());
      case RoutesName.categoryDetail:
        final categoryArg = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => CategoryDetailScreen(title: categoryArg['title'], id: categoryArg['id']));
      case RoutesName.chats:
        return MaterialPageRoute(builder: (BuildContext context) => ChatsView());
      case RoutesName.imageView:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => ImageView(image: arguments['image']));
      case RoutesName.videoView:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => VideoView(video: arguments['video']));
      case RoutesName.chatDetail:
        final arguments = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => ChatDetailView(userId: arguments['userId'], documentId: arguments['documentId']));
      case RoutesName.notification:
        return MaterialPageRoute(builder: (BuildContext context) => NotificationScreen());
      case RoutesName.faq:
        return MaterialPageRoute(builder: (BuildContext context) => HelpSupportScreen());
      case RoutesName.setting:
        return MaterialPageRoute(builder: (BuildContext context) => SettingScreen());
      case RoutesName.changePassword:
        return MaterialPageRoute(builder: (BuildContext context) => ChangePassword());
      case RoutesName.privacy:
        return MaterialPageRoute(builder: (BuildContext context) => Privacy());
      case RoutesName.terms:
        return MaterialPageRoute(builder: (BuildContext context) => Terms());
      case RoutesName.filter:
        return MaterialPageRoute(builder: (BuildContext context) => FiltersView());
      case RoutesName.filterCategory:
        final preSelectedCategories = settings.arguments as List<FilterCategoryData>? ?? [];
        return MaterialPageRoute(
          builder: (BuildContext context) => FilterCategoryView(preSelectedCategories: preSelectedCategories),
        );
      case RoutesName.filterTools:
        final preSelectedTools = settings.arguments as List<CatTools>? ?? [];
        return MaterialPageRoute(
          builder: (BuildContext context) => FilterToolsView(preSelectedTools: preSelectedTools),
        );
      case RoutesName.recentSearch:
        return MaterialPageRoute(builder: (BuildContext context) => RecentSearchView());
      case RoutesName.usersFollowing:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => UserFollowingView(id: argumens['id']));
      case RoutesName.usersFollowers:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => UserFollowersView(id: argumens['id']));
      case RoutesName.allComments:
        final argumens = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (BuildContext context) => CommentsView(id: argumens['id']));
      case RoutesName.editProject:
        final arguments = settings.arguments as Map<String, dynamic>;
        final preSelected = arguments['myPostDetailModel'];

        return MaterialPageRoute(
          builder: (BuildContext context) => EditProjectView(
            myPostDetailModel: arguments['myPostDetailModel'],
            id: arguments['id'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
