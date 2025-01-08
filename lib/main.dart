import 'dart:io';

//import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/firestore/firestore_controller.dart';
import 'package:val_app/view_model/accounts/blocked_user_view_model.dart';
import 'package:val_app/view_model/accounts/help_faq_view_model.dart';
import 'package:val_app/view_model/accounts/help_support_view_model.dart';
import 'package:val_app/view_model/accounts/privacy_view_model.dart';
import 'package:val_app/view_model/accounts/send_query_view_model.dart';
import 'package:val_app/view_model/accounts/setting_view_model.dart';
import 'package:val_app/view_model/accounts/terms_view_model.dart';
import 'package:val_app/view_model/chats/chats_view_model.dart';
import 'package:val_app/view_model/project/create_project_view_model.dart';
import 'package:val_app/view_model/post/my_post_detail_view_model.dart';
import 'package:val_app/view_model/report/project_report_view_model.dart';
import 'package:val_app/view_model/report/report_view_model.dart';
import 'package:val_app/view_model/profiles/user_profile_view_model.dart';
import 'package:val_app/view_model/saved_view_model.dart';
import 'package:val_app/view_model/search/filter_category_view_model.dart';
import 'package:val_app/view_model/search/filter_tools_view_model.dart';
import 'package:val_app/view_model/search/filter_view_model.dart';
import 'configs/color/colors.dart';
import 'configs/local_notification.dart';
import 'configs/routes/routes.dart';
import 'configs/routes/routes_name.dart';
import 'view_model/auth_view_model/code_view_model.dart';
import 'view_model/auth_view_model/create_password_view_model.dart';
import 'view_model/auth_view_model/create_profile_view_model.dart';
import 'view_model/auth_view_model/forgot_password_view_model.dart';
import 'view_model/auth_view_model/interest_view_model.dart';
import 'view_model/auth_view_model/login_view_model.dart';
import 'view_model/auth_view_model/signup_view_model.dart';
import 'view_model/bottom_nav_view_model.dart';
import 'view_model/categories_detail_view_model.dart';
import 'view_model/categories_view_model.dart';
import 'view_model/chats/chat_detail_view_model.dart';
import 'view_model/home_view_model.dart';
import 'view_model/my_account_view_model.dart';
import 'view_model/onboard_view_model.dart';
import 'view_model/post/user_post_detail_view_model.dart';
import 'view_model/profiles/my_profile_view_model.dart';
import 'view_model/search/search_view_model.dart';
import 'view_model/splash_view_model.dart';

GetIt getIt = GetIt.instance;


NotificationServices notificationServices = NotificationServices();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.notification != null && message.notification?.title != null && message.notification?.body != null) {
    await notificationServices.showNotification(message);
  } else {
    print('Notification details are missing.');
  }
  // notificationServices.showNotification(message);
  // notificationServices.requestNotificationPermission();
  // notificationServices.forgroundMessage();
  // notificationServices.setupInteractMessage(NavigationService.navigatorKey.currentContext!);
}


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCTZYqGYiLOVlLux8PjgCLA_aTjltL-FJo", // paste your api key here
        appId: "1:979773933033:android:442572d567d0cbdd903778", //paste your app id here
        messagingSenderId: "979773933033", //paste your messagingSenderId here
        projectId: "vall-app-f2528", //paste your project id here
      ),
    );
  }else{
    await Firebase.initializeApp();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _firebaseMessaging.requestPermission();
  await SharedPrefs.instance.init();
  // FirebaseMessagingHandler.initMessaging();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardViewModel()),
        ChangeNotifierProvider(create: (_) => CodeViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => CreatePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => CreateProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => InterestViewModel()),
        ChangeNotifierProvider(create: (_) => BottomNavBarViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesViewModel()),
        ChangeNotifierProvider(create: (_) => MyAccountViewModel()),
        ChangeNotifierProvider(create: (_) => MyProfileViewModel()),
        ChangeNotifierProvider(create: (_) => UserMyProfileViewModel()),
        ChangeNotifierProvider(create: (_) => CreateProjectViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
        ChangeNotifierProvider(create: (_) => MyPostDetailViewModel()),
        ChangeNotifierProvider(create: (_) => UserPostDetailViewModel()),
        ChangeNotifierProvider(create: (_) => BlockedUserViewModel()),
        ChangeNotifierProvider(create: (_) => SavedViewModel()),
        ChangeNotifierProvider(create: (_) => ChatsViewModel()),
        ChangeNotifierProvider(create: (_) => ChatDetailViewModel()),
        ChangeNotifierProvider(create: (_) => PrivacyViewModel()),
        ChangeNotifierProvider(create: (_) => TermsViewModel()),
        ChangeNotifierProvider(create: (_) => SettingViewModel()),
        ChangeNotifierProvider(create: (_) => SendQueryViewModel()),
        ChangeNotifierProvider(create: (_) => FaqViewModel()),
        ChangeNotifierProvider(create: (_) => HelpSupportViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => FilterViewModel()),
        ChangeNotifierProvider(create: (_) => FilterCategoryViewModel()),
        ChangeNotifierProvider(create: (_) => FilterToolsViewModel()),
        ChangeNotifierProvider(create: (_) => ProjectReportViewModel()),
        ChangeNotifierProvider(create: (_) => CategoriesDetailViewModel()),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget  {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  String id = "";
 // late AppLinks _appLinks;

  @override
  void initState() {
   // initDeepLinks();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Set user online status to true when app starts
    setState(() {
      id = SharedPrefs.instance.getString("userId") ?? "";
    });
    if(id.isNotEmpty){
      print("farhan id${id}");
      FirestoreController.chatStatus(onlineStatus: true,userID: id);
    }
  }
/*
  initDeepLinks() {
    _appLinks = AppLinks();
    print('----mmmm-----: ');
    // Handle links
    _appLinks.uriLinkStream.listen((uri) {
      print('----hhhhhhhhhh-----: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    print('onAppLink2: $uri');
    String formattedUri = uri.fragment.replaceAll('?', '');
    String routeName = formattedUri.split('/')[1];
    print('onAppLink3: $routeName');
    Map<String, dynamic> arguments = {
      'id': formattedUri.split('/').last,
      'route': 'home_job'
    };
    print('onAppLink4: $routeName');
    print('onAppLink5: $arguments');
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamed(context,
          RoutesName.userPostDetail,
          arguments: {"id":formattedUri.split('/').last,});

    });
  }*/


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      print("farhan id${id}");
      if(id.isNotEmpty){
        FirestoreController.chatStatus(onlineStatus: true,userID: id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Val',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.whiteColor),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}


initServices() async {
  FirebaseMessaging.
  onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  notificationServices.requestNotificationPermission();
  await SharedPrefs.instance.init();
}
