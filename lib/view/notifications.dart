import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/utils.dart';

import '../configs/color/colors.dart';
import '../configs/components/custom_appbar.dart';
import '../configs/components/custom_text_widget.dart';
import '../configs/components/main_scaffold.dart';
import '../configs/components/rich_text_widget.dart';
import '../configs/components/svg_icons_component.dart';
import '../configs/routes/routes_name.dart';
import '../view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationViewModel controller = NotificationViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getNotifications(context);
      },
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      builder: (ctx, widget) {
        return MainScaffold(
          appBar: CustomAppBar(
            leading: true,
            title: "Notifications",
          ),
          body: SafeArea(
            child: Consumer<NotificationViewModel>(builder: (context, notificationController, child) {
              return notificationController.isLoading
                      ? Center(child: Utils().spinkit,)
                  : notificationController.notificationList.isEmpty
                  ? Utils.noDataFoundMessage("No notifications found.")
                  : RefreshIndicator(
                backgroundColor: AppColors.whiteColor,
                color: AppColors.primaryColor,
                onRefresh: () async {
                  await notificationController.getNotifications(context, isPullToRefresh: true);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24, top: 14),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Divider(color: AppColors.grey2.withOpacity(.3)),
                        SizedBox(height: 20),
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          separatorBuilder: (context, cnt) {
                            return SizedBox(height: 18);
                          },
                          itemCount: notificationController.notificationList.length ?? 0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return notificationWidget(
                              title: notificationController.notificationList[index].title ?? "",
                              desc: " ${notificationController.notificationList[index].notification ?? "N/A"}",
                              date: notificationController.notificationList[index].createdOn ?? "N/A",
                              onTap: () {
                                var type = notificationController.notificationList[index].content!.type;
                                var id;
                                if(notificationController.notificationList[index].content!.valProfile!="None"){
                                  id =notificationController.notificationList[index].content!.valProfile!;
                                }else{
                                  id =notificationController.notificationList[index].content!.projectId!;
                                }
                                if(type == "rate"){
                                  Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {"id": id});
                                }else if(type == "comment"){
                                  Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {"id": id});
                                }else if(type == "follow"){
                                  Navigator.pushNamed(context, RoutesName.userProfileView, arguments: {"id": id});
                                }else if(type == "like"){
                                  Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {"id": id});
                                }
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );

      },
    );
  }

  GestureDetector notificationWidget({String? title, String? desc, String? date, Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 1, color: AppColors.blackColor.withOpacity(.1)),
        )),
        child: Row(
          children: [
            SvgIconComponent(icon: "notification_icon_2.svg", height: 50, width: 50),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichTextWidget(
                    text: "${title} \n",
                    textFontSize: 14,
                    height: 2.5,
                    color: AppColors.blackColor,
                    textFontWeight: FontWeight.w600,
                    centerText: desc,
                    centerDecoration: TextDecoration.underline,
                    centerFontSize: 14,
                    centerFontWeight: FontWeight.w600,
                    onTapText: " ",
                    centerColor: AppColors.blackColor,
                  ),
                  SizedBox(height: 8),
                  CustomTextWidget(
                    text: date,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey2,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
