import 'package:flutter/material.dart';
import 'package:val_app/Response/status.dart';
import 'package:val_app/configs/components/NoDataFoundWidget.dart';
import 'package:val_app/configs/utils.dart';

class AppSetData extends StatelessWidget {
  final Status? status;
  final Widget child;
  const AppSetData({super.key, required this.status, required this.child});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.loading:
        return Utils().loadingDialog(context);
      // Center(
      //     child: Padding(
      //   padding: const EdgeInsets.only(bottom: 100),
      //   child: Lottie.asset(AppAssets.loadingAnimation3),
      // ));

      case Status.error:
        return Stack(
          children: [
            ListView(),
            const NoDataFoundWidget(),
          ],
        );
      case Status.completed:
        return child;
      default:
        return const SizedBox.shrink();
    }
  }
}
