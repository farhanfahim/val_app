import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../../../../firestore/chat_strings.dart';
import '../../../../firestore/chatting_model.dart';
import '../../../configs/color/colors.dart';
import '../../../configs/components/custom_text_widget.dart';
import '../../../configs/routes/routes_name.dart';
import 'Skeleton.dart';
import 'common_image_view.dart';

// ignore: must_be_immutable
class ChatTileWidget extends StatelessWidget {
  ChatTileWidget(this.data);
  ChattingModel data;

  @override
  Widget build(BuildContext context) {
    bool isSender = false;
    isSender = data.userId == data.senderId;
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if (!isSender)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.start,
              textBaseline: TextBaseline.ideographic,
              children: [

                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        data.type==ChatStrings.messageTypeText?Material(
                          elevation: 0,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: AppColors.lightGrey.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            child:CustomTextWidget(
                              text: data.text,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: AppColors.grey3,
                            ),
                          ),
                        )
                            :data.type==ChatStrings.messageTypeImage || data.type==ChatStrings.messageTypeVideo?Column(
                          children: [
                            Visibility(
                              visible: data.text.isNotEmpty,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft:Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    color: AppColors.lightGrey.withOpacity(0.3),
                                ),

                                child: Container(
                                  width: MediaQuery.sizeOf(context).width*0.75,
                                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                                  child: CustomTextWidget(
                                    text: data.text,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.grey3,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                if(data.image != ""){
                                  if (data.type == ChatStrings.messageTypeImage) {
                                    if (data.image != "") {
                                      Navigator.pushNamed(context, RoutesName.imageView, arguments: {
                                        "image": data.image,
                                      });
                                    }
                                  } else if (data.type == ChatStrings.messageTypeVideo) {
                                    Navigator.pushNamed(context, RoutesName.videoView, arguments: {
                                      "video": data.video,
                                    });
                                  }
                                }
                              },
                              child:   data.image == "" ? ClipRRect(
                                borderRadius:
                                BorderRadius.only(
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(10),
                                    topLeft: Radius.circular(data.text.isNotEmpty?0:10),
                                    topRight: Radius.circular(data.text.isNotEmpty?0:10)),
                                child: Skeleton(
                                  width: MediaQuery.sizeOf(context).width*0.75,
                                  height: MediaQuery.sizeOf(context).width*0.35,
                                ),
                              ):Stack(
                                alignment: AlignmentDirectional.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.only(
                                        bottomLeft: const Radius.circular(10),
                                        bottomRight: const Radius.circular(10),
                                        topLeft: Radius.circular(data.text.isNotEmpty?0:10),
                                        topRight: Radius.circular(data.text.isNotEmpty?0:10)),
                                    child: CommonImageView(
                                        width: MediaQuery.sizeOf(context).width*0.75,
                                        height: MediaQuery.sizeOf(context).width*0.35,
                                        fit: BoxFit.cover,
                                        url: data.image),
                                  ),
                                  Visibility(
                                    visible: data.type==ChatStrings.messageTypeVideo,
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryColor.withOpacity(0.5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CommonImageView(
                                          svgPath: "assets/images/play_icon.svg",color: AppColors.whiteColor,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                            :Container(),
                        CustomTextWidget(
                          text: getTime(((data.time as Timestamp)).toDate()),
                          color: AppColors.grey3,
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          if (isSender)
            Row(
              mainAxisAlignment:MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        data.type == ChatStrings.messageTypeText?Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(0)),
                              color: AppColors.primaryColor
                          ),

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            child: CustomTextWidget(
                              text: data.text,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                            :data.type==ChatStrings.messageTypeImage || data.type==ChatStrings.messageTypeVideo?Column(
                          children: [
                            Visibility(
                              visible: data.text.isNotEmpty,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(0),
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(0)),
                                    color: AppColors.primaryColor
                                ),

                                child: Container(
                                  width: MediaQuery.sizeOf(context).width*0.75,
                                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                                  child: CustomTextWidget(
                                    text: data.text,
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                if(data.image != ""){
                                  if (data.type == ChatStrings.messageTypeImage) {
                                    if (data.image != "") {
                                      Navigator.pushNamed(context, RoutesName.imageView, arguments: {
                                        "image": data.image,
                                      });
                                    }
                                  } else if (data.type == ChatStrings.messageTypeVideo) {
                                    Navigator.pushNamed(context, RoutesName.videoView, arguments: {
                                      "video": data.video,
                                    });
                                  }
                                }
                              },
                              child:   data.image == "" ? ClipRRect(
                                    borderRadius:
                                    BorderRadius.only(
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(10),
                                    topLeft: Radius.circular(data.text.isNotEmpty?0:10),
                                    topRight: Radius.circular(data.text.isNotEmpty?0:10)),
                                    child: Skeleton(
                                      width: MediaQuery.sizeOf(context).width*0.75,
                                      height: MediaQuery.sizeOf(context).width*0.35,
                                    ),
                                  ):Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.only(
                                        bottomLeft: const Radius.circular(10),
                                        bottomRight: const Radius.circular(10),
                                        topLeft: Radius.circular(data.text.isNotEmpty?0:10),
                                        topRight: Radius.circular(data.text.isNotEmpty?0:10)),
                                        child: CommonImageView(
                                      width: MediaQuery.sizeOf(context).width*0.75,
                                      height: MediaQuery.sizeOf(context).width*0.35,
                                      fit: BoxFit.cover,
                                      url: data.image),
                                      ),
                                      Visibility(
                                        visible: data.type==ChatStrings.messageTypeVideo,
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primaryColor.withOpacity(0.5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: CommonImageView(
                                              svgPath: "assets/images/play_icon.svg",color: AppColors.whiteColor,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                          ],
                        )
                            :Container(),
                        Padding(
                          padding: const EdgeInsets.only(right:5,bottom: 10,top: 5),
                          child: CustomTextWidget(
                            text: data.time!=null?getTime(((data.time as Timestamp)).toDate()):"",
                            color: AppColors.grey3,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            )


        ],
      ),
    );
  }
  static String getTime(DateTime dateTime) {
    var xxx = DateFormat("hh:mm a").format(dateTime);
    return xxx.toString();
  }
}
