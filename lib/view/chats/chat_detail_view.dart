import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/firestore/firebase_user_model.dart';
import 'package:val_app/view/chats/widgets/Skeleton.dart';
import 'package:val_app/view/chats/widgets/chat_tile_widget.dart';
import 'package:val_app/view/chats/widgets/chatting_date_tile.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/routes/routes_name.dart';
import '../../configs/sharedPerfs.dart';
import '../../firestore/chat_strings.dart';
import '../../firestore/chatting_model.dart';
import '../../view_model/chats/chat_detail_view_model.dart';

class ChatDetailView extends StatefulWidget {
  final String? userId;
  final String? documentId;

  const ChatDetailView({
    super.key,
    this.userId = "",
    this.documentId = "",
  });

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final ChatDetailViewModel controller = ChatDetailViewModel();

  @override
  void initState() {
    super.initState();

    if (widget.userId != null) {
      controller.userId = widget.userId!;
      controller.listenToUser(controller.userId);
    }

    if (widget.documentId != null) {
      controller.documentId = widget.documentId!;
    }

    String userID = SharedPrefs.instance.getString("userId") ?? "";
    controller.myUserId = userID;
    if (controller.documentId.isEmpty) {
      getDoc();
    } else {
      controller.getChatMessages();
      controller.observeChatData();
      controller.markMessagesRead();
    }


  }

  getDoc() async {
    await controller.getDocumentId(controller.userId,false);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        body: Consumer<ChatDetailViewModel>(
          builder: (context, _cd, child) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    headerSection(context,_cd.user??null,_cd),
                    const SizedBox(height: 18),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                              child: _cd.chatList.isNotEmpty? ListView(
                                controller: _cd.scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(4.0, 10, 4, 10),
                                children: List<Widget>.from(
                                    _cd.addDatesInNewList().map((data) {
                                      if (data is ChattingModel) {
                                        return ChatTileWidget(data);
                                      } else if (data is DateTime) {
                                        return ChattingDateTile(date: data,isDateToday: controller.isDateToday(data),);
                                      } else {
                                        return Container();
                                      }
                                    })),
                              ):SizedBox(
                                width: double.maxFinite,
                                child: Center(
                                  child: CustomTextWidget(
                                    text: "Start Conversation",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                          ),
                          _cd.isBlockedByMe || _cd.isBlockedByOther?Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: CustomTextWidget(
                                text: _cd.blockMessage,
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ):Expanded(
                            flex: 0,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(45),
                                boxShadow: [
                                  BoxShadow(color: AppColors.greyShadowColor.withOpacity(.1), offset: Offset(1, 1), blurRadius: 25, spreadRadius: 0),
                                ],
                              ),
                              child: CustomTextField(
                                onTap: () {},
                                maxLength: 1000,
                                maxLines: 6,
                                hintFontSize: 14,
                                cursorColor: AppColors.grey2,
                                fillColor: AppColors.whiteColor,
                                borderRadius: 45,
                                hint: "Write a message...",
                                hintColor: AppColors.grey2,
                                textInputType: TextInputType.name,
                                txtController: controller.msgTextController,
                                suffixIcon2: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        PopUpSheetPicker(context, controller);
                                      },
                                      child: SvgIconComponent(icon: "attach.svg"),
                                    ),
                                    SizedBox(width: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if(controller.msgTextController.value.text.trim().isNotEmpty) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            controller.sendMessage(
                                              controller.msgTextController.value.text,
                                              ChatStrings.messageTypeText,);
                                          }
                                        },
                                        child: SvgIconComponent(icon: "send.svg"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ),

                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<dynamic> PopUpSheetPicker(BuildContext context, ChatDetailViewModel controller) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromCamera();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                    const SizedBox(height: 10),
                    CustomTextWidget(
                      text: "Camera",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickMediaFromGallery();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.perm_media),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      text: "Photo | Video",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget headerSection(BuildContext context,FirebaseUserModel? model,ChatDetailViewModel cd) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 50,
                width: 50,
                child: model!=null?Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        model.image,
                      ),
                      radius: 25,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SvgIconComponent(icon: "online_icon.svg",color: model.online?null:AppColors.grey3,),
                    ),
                  ],
                ):Skeleton(height: 50,width: 50,cornerRadius: 25,),
              ),
              SizedBox(width: 11),
              model!=null?Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: model.name,
                      maxLines: 1,
                      overFlow: TextOverflow.ellipsis,
                      color: AppColors.blackColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 6),
                    CustomTextWidget(
                      text: model.online?"Online":"Offline",
                      color: AppColors.grey3,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ):Skeleton(height: 15,width: 150,cornerRadius: 5,),
            ],
          ),
        ),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {

              showCustomBottomSheet(context,cd);
            },
            child: Icon(Icons.more_vert)),
      ],
    );
  }

  void showCustomBottomSheet(BuildContext context,ChatDetailViewModel cd) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutesName.report);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgIconComponent(icon: "info.svg", width: 20, height: 20),
                        SizedBox(width: 15),
                        CustomTextWidget(text: "Report", fontSize: 16, fontWeight: FontWeight.w500),
                      ],
                    ),
                    SvgIconComponent(icon: "right_purple.svg", width: 20, height: 20)
                  ],
                ),
              ),
              SizedBox(height: 22),
              Divider(color: AppColors.grey2.withOpacity(.3)),
              SizedBox(height: 22),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  cd.blockUnBlockUser(context);
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgIconComponent(icon: "block-user.svg", width: 20, height: 20),
                        SizedBox(width: 15),
                        CustomTextWidget(text: cd.isBlockedByMe?"Unblock User":"Block user", fontSize: 16, fontWeight: FontWeight.w500),
                      ],
                    ),
                    SvgIconComponent(icon: "right_purple.svg", width: 20, height: 20)
                  ],
                ),
              ),
              SizedBox(height: 30)
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    debugPrint("dispose called");
    super.dispose();
  }
}
