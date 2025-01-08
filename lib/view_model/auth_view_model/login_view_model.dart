import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:val_app/Repository/auth_api/auth_http_api_repository.dart';
import 'package:val_app/Response/api_response.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/AuthModels/SignInModel.dart';
import 'package:val_app/view_model/profiles/my_profile_view_model.dart';

import '../../firebase/firebase_messaging.dart';
import '../../firestore/firestore_controller.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController otpFieldController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool isPasswordVisible = true;
  FocusNode focusPassword = FocusNode();
  FocusNode focusEmail = FocusNode();
  AuthHttpApiRepository authRepository = AuthHttpApiRepository();
  ApiResponse<SignInModel> singIn = ApiResponse.loading();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loadUserCredentials() async {
    final credentials = await Utils.getUserCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      emailTextEditingController.text = credentials['email']!;
      passwordTextEditingController.text = credentials['password']!;
      rememberMe = credentials['isRememberMe'];

      notifyListeners();
    }
  }

  void onRememberMeChanged(bool? newValue) {
    rememberMe = newValue ?? false;

    if (rememberMe) {
      Utils.saveUserCredentials(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      );
    } else {
      Utils.clearUserCredentials();
    }
  }

  setSignInApiResponse(ApiResponse<SignInModel> response) {
    singIn = response;
    notifyListeners();
  }

  LoginViewModel() {
    {
      focusEmail.addListener(notifyListeners);
      focusPassword.addListener(notifyListeners);

      loadUserCredentials();
    }
  }

  Future<void> login(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      // Show loading dialog
      Utils().loadingDialog(context);
      var fcmToken = await FirebaseMessagingHandler().getFcmToken();
      print("fcm token" + fcmToken);
      var headers = {'Content-Type': 'application/json'};
      dynamic signInData = {
        "username": emailTextEditingController.text.trim().toLowerCase(),
        "password": passwordTextEditingController.text.trim(),
        "registration_id": fcmToken,
        "type": Platform.isAndroid ? "android" : "ios"
      };

      try {
        SignInModel response =
            await authRepository.loginApi(jsonEncode(signInData), headers);

        if (response.status!) {
          // Set user data and navigate
          if (rememberMe) {
            Utils.saveUserCredentials(
              email: emailTextEditingController.text,
              password: passwordTextEditingController.text,
              rememberMe: rememberMe,
              accessToken: response.data!.access.toString(),
              refreshToken: response.data!.refresh.toString()
            );
          }
          Navigator.pop(context);
          Provider.of<MyProfileViewModel>(context, listen: false)
              .setuserdata(response);
          SharedPrefs.instance
              .setString("accessToken", response.data!.access.toString());
          SharedPrefs.instance.setBool("isDone", response.data!.profileDone!);
          SharedPrefs.instance
              .setString("refreshToken", response.data!.refresh.toString());
          SharedPrefs.instance
              .setString("userId", response.data!.userId.toString());
          FirestoreController.instance.saveUserData(
              response.data!.userId,
              response.data!.username,
              response.data!.email,
              response.data!.mainImage != null
                  ? AppUrl.baseUrl + response.data!.mainImage!
                  : "");
          FirestoreController.chatStatus(onlineStatus: true, userID: response.data!.userId.toString());
          if (response.data!.profileDone!) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.bottomNav, (Route<dynamic> route) => false);
          } else {
            // Navigator.pushNamed(context, RoutesName.createProfile,
            //     arguments: {'isEdit': false});
            Navigator.pushNamedAndRemoveUntil(
                context,
                RoutesName.createProfile,
                arguments: {'isEdit': false},
                (Route<dynamic> route) => false);
          }
        } else {
          Navigator.pop(context);
          Utils.toastMessage(response.message.toString());
        }
      } catch (error) {
        Navigator.pop(context);
        Utils.toastMessage(error.toString());
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe() {
    rememberMe = !rememberMe;
    notifyListeners();
  }

  remembersMe() {
    if (rememberMe) {}
  }

  void signInWithFacebook(BuildContext context) {
    // Perform Facebook sign-in logic here
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  Future<void> signInWithApple(BuildContext context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // // match the sha256 hash of `rawNonce`.
    // final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);
    var fcmToken = await FirebaseMessagingHandler().getFcmToken();
    try {
      // Request credential for the currently signed in Apple account.
      final rawNonce = generateNonce();

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // nonce: nonce,
      );
      print("fcm $fcmToken");

      // Create an `OAuthCredential` from the credentipal returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      final appleLogin =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      socialLogin(context,
          uid: appleLogin.user?.uid ?? '',
          email: appleLogin.additionalUserInfo?.profile!["email"] ?? '',
          name: appleLogin.additionalUserInfo?.profile!["email"]
                  .split("@")
                  .first ??
              '',
          provider: 'apple',
          fcmtoken: fcmToken);

    } catch (e) {
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        Utils.toastMessage('User cancelled login');
      } else {
        Utils.toastMessage(e.toString());
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    var fcmToken = await FirebaseMessagingHandler().getFcmToken();
    try {
      Utils().loadingDialog(context);
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        _googleSignIn.signOut();
        print('google login $user');
        socialLogin(context,
            uid: user?.uid ?? '',
            email: user?.email ?? '',
            name: user?.displayName ?? user?.email!.split("@").first ?? "",
            provider: 'google',
            fcmtoken: fcmToken);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Utils.toastMessage('User cancelled login');
      }
    } catch (e) {
      Navigator.pop(context);
      print('catch ${e.toString()}');
      Utils.toastMessage(e.toString());
    }
  }

  Future<void> socialLogin(
    BuildContext context, {
    required String uid,
    required String email,
    required String name,
    required String provider,
    required String fcmtoken,
  }) async {
    // Show loading dialog
    Utils().loadingDialog(context);

    var headers = {'Content-Type': 'application/json'};
    var signInData = {
      "uid": uid,
      "email": email,
      "full_name": name,
      "provider": provider,
      "type": provider == "apple" ? "ios" : "android",
      "registration_id": fcmtoken
    };

    try {
      SignInModel response =
          await authRepository.socialLoginApi(jsonEncode(signInData), headers);

      if (response.status!) {
        Navigator.pop(context);
        Provider.of<MyProfileViewModel>(context, listen: false)
            .setuserdata(response);
        SharedPrefs.instance
            .setString("accessToken", response.data!.access.toString());
        SharedPrefs.instance.setBool("isDone", response.data!.profileDone!);
        SharedPrefs.instance
            .setString("refreshToken", response.data!.refresh.toString());
        SharedPrefs.instance
            .setString("userId", response.data!.userId.toString());
        FirestoreController.instance.saveUserData(
            response.data!.userId,
            response.data!.username,
            response.data!.email,
            response.data!.mainImage != null
                ? AppUrl.baseUrl + response.data!.mainImage!
                : "");
        FirestoreController.chatStatus(onlineStatus: true, userID: response.data!.userId.toString());
        if (response.data!.profileDone!) {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.bottomNav, (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamed(context, RoutesName.createProfile,
              arguments: {'isEdit': false});
        }
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response.message.toString());
      }
    } catch (error) {
      Navigator.pop(context);
      print(error);
      Utils.toastMessage(error.toString());
    }
  }
}
