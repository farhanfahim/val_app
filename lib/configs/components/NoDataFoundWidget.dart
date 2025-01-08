import 'package:flutter/material.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // SizedBox(
        //   width: Get.width,
        // ),
        // Image.asset(
        //   AppAssets.emptyDataImage,
        //   height: 250,
        // ),
        const Text.rich(
          TextSpan(
            text: 'Oops...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: <InlineSpan>[
              TextSpan(text: '\n'),
              TextSpan(
                text: "There's nothing here, yet.",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 100)
      ],
    );
  }
}
