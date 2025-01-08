
import 'package:fluttertoast/fluttertoast.dart';
import 'package:val_app/configs/color/colors.dart';

class CustomSnackBar {
  static show(String message,
      {bool showOnTop = true, bool increaseDuration = false}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: increaseDuration ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: showOnTop ? ToastGravity.CENTER : ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.blackColor,
        textColor: AppColors.whiteColor,
        fontSize: 16.0);
  }
}
