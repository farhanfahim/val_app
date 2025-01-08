import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';

import 'components/custom_text_widget.dart';

enum ImageSize { oneX, twoX, threeX }

class Utils {
  static BoxDecoration boxDecorationRounded = BoxDecoration(
    borderRadius: BorderRadius.circular(70),
    color: AppColors.whiteColor,
    border: Border.all(color: AppColors.grey2.withOpacity(0), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        offset: const Offset(8, 9),
        blurRadius: 22,
        spreadRadius: 0,
      ),
    ],
  );

  static BoxDecoration boxDecorationRoundedBorder = BoxDecoration(
    borderRadius: BorderRadius.circular(70),
    color: AppColors.whiteColor,
    border: Border.all(color: AppColors.grey6, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        offset: const Offset(8, 9),
        blurRadius: 22,
        spreadRadius: 0,
      ),
    ],
  );

  SpinKitPulsingGrid spinkit = SpinKitPulsingGrid(
    color: AppColors.primaryColor,
    size: 50.0,
  );
  static void handleTokenExpiration(BuildContext context, dynamic response) async {
    if (response["code"] == "token_not_valid" && response["messages"] != null) {
      for (var message in response["messages"]) {
        if (message["token_class"] == "AccessToken" && message["token_type"] == "access") {
          // Token is invalid or expired
          // await Utils.clearUserCredentials();
          await SharedPrefs.instance.clearPrefsSpecific('accessToken');
          await SharedPrefs.instance.clearPrefsSpecific('refreshToken');
          Navigator.pushReplacementNamed(context, RoutesName.login);
          Utils.toastMessage("Session expired. Please log in again.");
          return;
        }
      }
    }
  }

  customCachedNetworkImage({String placeholder = "placeholder.png",String? url, double? width, double? height, BoxShape? shape, BorderRadiusGeometry? borderRadius}) {
    print(url);
    return url != "" && url != "null" && url != null
        ? CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: width,
                height: height,
                decoration: BoxDecoration(shape: shape!, image: DecorationImage(image: imageProvider, fit: BoxFit.cover), borderRadius: borderRadius),
              );
            },
            placeholder: (context, url) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: shape!,
                  image: DecorationImage(image: AssetImage(Utils.getIconImage(placeholder)), fit: BoxFit.cover),
                )),
            errorWidget: (context, url, error) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  shape: shape!,
                  image: DecorationImage(image: AssetImage(Utils.getIconImage(placeholder)), fit: BoxFit.cover),
                )),
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: AssetImage(Utils.getIconImage(placeholder)), fit: BoxFit.cover),
            )); //AssetImage(placeholder)
  }

  String formatDate(String dateString) {
    // Parse the date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateString);

    // Define the output format
    DateFormat formatter = DateFormat('MMM dd, yyyy');

    // Format the DateTime object to the desired string format
    String formattedDate = formatter.format(dateTime);

    return formattedDate;
  }

  String formatDate2(String dateString) {
    try {
      // Parse the date string to a DateTime object
      DateTime dateTime = DateTime.parse(dateString);

      // Define the output format
      DateFormat formatter = DateFormat('MMM dd, yyyy');

      // Format the DateTime object to the desired string format
      String formattedDate = formatter.format(dateTime);

      return formattedDate;
    } catch (e) {
      // Handle the error, return an empty string or error message if needed
      print("Invalid date format: $e");
      return "";
    }
  }

  loadingDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(onWillPop: () async => false, child: spinkit);
        });
  }

  Future<bool> permissionCameraCheckMethod() async {
    // Check if photo permission is permanently denied
    if (await Permission.camera.isPermanentlyDenied) {
      print("permission permanent denied");
      // Open app settings for the user to manually enable the permission
      openAppSettings();
      return false;
    }
    // Check if photo permission is currently denied
    else if (await Permission.camera.isDenied) {
      // Request photo permission
      print("permission denied");
      final permissionRequest = await Permission.camera.request();

      // Check if permission is granted after the request
      if (permissionRequest.isGranted) {
        print("permission granted");
        return true;
      } else {
        print("permission not granted");
        // Permission is still not granted
        return false;
      }
    }
    // Photo permission is already granted
    else {
      print("permission granted");
      return true;
    }
  }

  Future<bool> permissionCheckMethod() async {
    // Check if photo permission is permanently denied
    if (await Permission.photos.isPermanentlyDenied) {
      // Open app settings for the user to manually enable the permission
      openAppSettings();
      return false;
    }
    // Check if photo permission is currently denied
    else if (await Permission.photos.isDenied) {
      // Request photo permission
      final permissionRequest = await Permission.storage.request();

      // Check if permission is granted after the request
      if (permissionRequest.isGranted) {
        return true;
      } else {
        if (Platform.isAndroid) {
          return true;
        }
        // Permission is still not granted
        return false;
      }
    }
    // Photo permission is already granted
    else {
      return true;
    }
  }

  static Future<void> clearUserCredentials() async {
    // await prefs.remove('email');
    // await prefs.remove('password');
    SharedPrefs.instance.clearPrefs();
  }

  // we will use this function to shift focus from one text field to another text field
  // we are using to avoid duplications of code
  static void fieldFocusChange(BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  //imported this from flush bar package
  // we will utilise this for showing errors or success messages
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 3),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static getCommonImage(String imageName, {ImageSize size = ImageSize.oneX}) {
    switch (size) {
      case ImageSize.oneX:
        return "assets/images/common/$imageName";
      case ImageSize.twoX:
        return "assets/images/common/2.0.x/$imageName";
      case ImageSize.threeX:
        return "assets/images/common/3.0.x/$imageName";
    }
  }

  static getIconImage(String imageName, {ImageSize size = ImageSize.oneX}) {
    switch (size) {
      case ImageSize.oneX:
        return "assets/images/icons/$imageName";
      case ImageSize.twoX:
        return "assets/images/icons/$imageName";
      case ImageSize.threeX:
        return "assets/images/icons/$imageName";
    }
  }

  static Future<Map<String, dynamic>> getUserCredentials() async {
    String? email = SharedPrefs.instance.getString('email');
    String? password = SharedPrefs.instance.getString('password');
    String? accessToken = SharedPrefs.instance.getString("accessToken");
    String? refreshToken = SharedPrefs.instance.getString("refreshToken");
    bool? isRememberMe = SharedPrefs.instance.getBool("isRememberMe") ?? false;
    return {'email': email, 'password': password, 'accessToken': accessToken, 'refreshToken': refreshToken, 'isRememberMe': isRememberMe};
  }

  static Future<void> saveUserCredentials({String? email, String? password, String? accessToken, String? refreshToken, bool rememberMe = false}) async {
    SharedPrefs.instance.setString('email', email ?? "");
    SharedPrefs.instance.setString('password', password ?? "");
    SharedPrefs.instance.setString('accessToken', accessToken ?? "");
    SharedPrefs.instance.setString('refreshToken', refreshToken ?? "");
    SharedPrefs.instance.setBool('isRememberMe', rememberMe);
  }

  // we will utilise this for showing errors or success messages
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: CustomTextWidget(text: message)));
  }

  // generic toast message imported from toast package
  // we will utilise this for showing errors or success messages
  static toastMessage(String message) {
    Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  static int calculateTimeDifference(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration difference = dateTime.difference(now);
    return difference.inSeconds.abs();
  }

  static String formatDateTime(DateTime dateTime) {
    final int timeDifferenceInSeconds = calculateTimeDifference(dateTime);

    if (timeDifferenceInSeconds <= 120) {
      // If within 2 minutes, return "Just now"
      return "Just now";
    } else if (timeDifferenceInSeconds < 86400) {
      // If within 24 hours (but more than 2 minutes), return the relative time like "X minutes ago" or "X hours ago"
      if (timeDifferenceInSeconds < 3600) {
        // Less than 1 hour, return "X minutes ago"
        final int minutesAgo = (timeDifferenceInSeconds / 60).floor();
        return "$minutesAgo mins";
      } else {
        // 1 hour or more, return "X hours ago"
        final int hoursAgo = (timeDifferenceInSeconds / 3600).floor();
        return "$hoursAgo hrs";
      }
    } else {
      // If more than 24 hours, return the formatted date-time
      final DateFormat formatter = DateFormat('MMM dd, hh:mm a');
      final String formattedDateTime = formatter.format(dateTime);
      return formattedDateTime;
    }
  }

  static Widget noDataFoundMessage(String? text) {
    return Container(
      alignment: Alignment.center,
      child: Align(
        alignment: Alignment.center,
        child: CustomTextWidget(
          text: text,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
    );
  }
}
