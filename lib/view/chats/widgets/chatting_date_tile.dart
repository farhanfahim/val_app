import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_text_widget.dart';
import '../../../view_model/chats/chat_detail_view_model.dart';

class ChattingDateTile extends StatelessWidget {
  ChattingDateTile({
    Key? key,
    required this.date,
    required this.isDateToday,
  }) : super(key: key);

  final DateTime date;
  bool isDateToday;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: isDateToday?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CustomTextWidget(
            text: "Today, ",
            color: AppColors.grey3,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),

          CustomTextWidget(
            text: getTime(date),
            color: AppColors.grey3,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),
        ],
      ):Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextWidget(
            text: "${getDay(date)}, ",
            color: AppColors.grey3,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),

          CustomTextWidget(
            text: getTime(date),
            color: AppColors.grey3,
            fontSize: 13,
            fontWeight: FontWeight.normal,
          ),


        ],
      ),
    );
  }


  static String getTime(DateTime dateTime) {
    var xxx = DateFormat("hh:mm a").format(dateTime);
    return xxx.toString();
  }

  static String getDay(DateTime dateTime) {
    var xxx = DateFormat("MMM d").format(dateTime);
    return xxx.toString();
  }

}
