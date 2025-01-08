import 'package:flutter/material.dart';

import 'custom_text_widget.dart';

class InterNetExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  const InterNetExceptionWidget({super.key, required this.onPress});

  @override
  State<InterNetExceptionWidget> createState() => _InterNetExceptionWidgetState();
}

class _InterNetExceptionWidgetState extends State<InterNetExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * .15),
          const Icon(
            Icons.cloud_off,
            color: Colors.red,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: CustomTextWidget(
                text: 'We’re unable to show results.\nPlease check your data\nconnection.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .15),
          ElevatedButton(
            onPressed: widget.onPress,
            child: Center(
              child: CustomTextWidget(
                text: 'RETRY',
              ),
            ),
          )
        ],
      ),
    );
  }
}
