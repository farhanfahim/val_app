// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/feedModel.dart';
import 'package:val_app/view_model/home_view_model.dart';
import '../configs/components/category_component.dart';
import '../configs/components/custom_button_widget.dart';
import '../configs/components/custom_text_widget.dart';
import '../configs/components/designer_component.dart';
import '../configs/components/main_scaffold.dart';
import '../configs/components/post_component.dart';
import '../configs/components/svg_icons_component.dart';
import '../configs/local_notification.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel controller_ = HomeViewModel();
  NotificationServices notificationServices = NotificationServices();
  Timer? timer;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        //Provider.of<HomeViewModel>(context, listen: false).checkSubscriptionStatus(context);
        print("CALLED");
        controller_.getAllFeeds(context);
        controller_.getNotificationCount(context);
      },
    );
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    controller_.pingApiRequest();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      print("PING API CALLED");
      controller_.pingApiRequest();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller_,
      child: Scaffold(
        body: Center(child: Consumer<HomeViewModel>(
          builder: (context, controller, child) {
            return controller.feedLoader == true
                ? Center(
                    child: Utils().spinkit,
                  )
                : MainScaffold(
                    body: RefreshIndicator(
                      onRefresh: () async {
                        await controller.getAllFeeds(context);
                      },
                      child: controller.feedLoader
                          ? const SizedBox.shrink()
                          : controller.feeds == null
                              ? Utils.noDataFoundMessage("No data found.")
                              : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 52),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Utils().customCachedNetworkImage(
                                                width: 46,
                                                height: 46,
                                                shape: BoxShape.circle,
                                                url: (AppUrl.baseUrl +
                                                    controller
                                                        .feeds!
                                                        .data!
                                                        .userProfile![0]
                                                        .mainImage
                                                        .toString())),
                                            // Image.asset(Utils.getCommonImage("profile_img.png"), height: 46, width: 46),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomTextWidget(
                                                      text: controller.getGreeting(),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  const SizedBox(height: 3),
                                                  FittedBox(
                                                    child: CustomTextWidget(
                                                        text: controller
                                                                .feeds
                                                                ?.data
                                                                ?.userProfile?[
                                                                    0]
                                                                .username
                                                                .toString() ??
                                                            "",
                                                        //"John",
                                                        color: AppColors
                                                            .blackColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 20,
                                                        maxLines: 1,
                                                        overFlow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      RoutesName.chats);
                                                },
                                                child: Stack(
                                                  children: [
                                                    SvgIconComponent(
                                                        icon: "msg_icon.svg"),
                                                    controller.showChatDot?Container(
                                                      width: 8,height: 8,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),):Container(),
                                                  ],
                                                )),
                                            const SizedBox(width: 28),
                                            GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  controller.updateNotification(false);
                                                  Navigator.pushNamed(context,
                                                      RoutesName.notification);

                                                },
                                                child: Stack(
                                                  children: [
                                                    SvgIconComponent(
                                                        icon:
                                                            "no_notification_icon.svg"),
                                                    controller_.showNotificationDot?Container(
                                                        width: 8,height: 8,
                                                        decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle,
                                                        ),):Container(),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 34),
                                      // Categories
                                      SizedBox(
                                        height: 115,
                                        child: ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24),
                                          separatorBuilder: (context, cnt) {
                                            return const SizedBox(width: 15);
                                          },
                                          itemCount: (controller.feeds!.data!
                                                          .categories ??
                                                      [])
                                                  .length +
                                              1,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                controller.feeds!.data!
                                                    .categories!.length) {
                                              return CategoryComponent(
                                                onTap: () {
                                                  Navigator.pushNamed(context,
                                                      RoutesName.categories);
                                                },
                                                title: "View All",
                                                img: "view_all_icon.png",
                                              );
                                            } else {
                                              return CategoryComponent(
                                                onTap: () {
                                                  Navigator.pushNamed(context, RoutesName.categoryDetail, arguments: {
                                                    'title': controller.feeds?.data?.categories?[index].category,
                                                    'id': controller.feeds?.data?.categories?[index].id.toString(),
                                                  });
                                                },
                                                title: controller
                                                    .feeds!
                                                    .data!
                                                    .categories![index]
                                                    .category!
                                                    .toString(),
                                                img: AppUrl.baseUrl +
                                                    controller
                                                        .feeds!
                                                        .data!
                                                        .categories![index]
                                                        .categoryImage!
                                                        .toString(),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: AppColors.grey,
                                          indent: 24,
                                          endIndent: 24),
                                      const SizedBox(height: 17),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: Row(
                                          children: [
                                            CustomTextWidget(
                                              text: "Top Rated Designers",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            const Expanded(
                                                child: const SizedBox()),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                print(controller.feeds!.data!.topProfiles!.length);
                                                Navigator.pushNamed(context,
                                                    RoutesName.topRated,arguments: {"feeds": controller.feeds!,}).then((v){
                                                      if(v!=null){
                                                        controller.notifyOnSavedDesigner(v);
                                                      }
                                                });
                                              },
                                              child: CustomTextWidget(
                                                text: "View All",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Designers
                                      SizedBox(
                                        ///mediaquery
                                        height: 250,
                                        child: ListView.separated(
                                          padding: EdgeInsets.only(
                                              left: 24,
                                              right: 24,
                                              top: 16,
                                              bottom: 22),
                                          separatorBuilder: (context, cnt) {
                                            return const SizedBox(width: 15);
                                          },
                                          itemCount: (controller.feeds!.data!.topProfiles ?? []).length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return controller.feeds!.data!.topProfiles![index].username == null
                                                ? SizedBox.shrink()
                                                : DesignerComponent(
                                                    key: UniqueKey(),
                                                    isSaved: controller.feeds!.data!.topProfiles![index].isSaved ?? false,
                                                    onSave: () {
                                                      controller.toggleSaveProfile(
                                                        context,
                                                        controller.feeds!.data!.topProfiles![index].valProfileId.toString(),
                                                      );
                                                    },
                                                    onProfile: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutesName.userProfileView,
                                                          arguments: {"id": controller.feeds!.data!.topProfiles![index].valProfileId.toString()}).then((v){
                                                            controller.updateData(v,index);
                                                      });
                                                    },
                                                    onFollow: () {
                                                      controller.getFollowProfile(
                                                              context,
                                                              id: controller.feeds?.data?.topProfiles![index].valProfileId.toString(),
                                                              index: index);
                                                    },
                                                    img: AppUrl.baseUrl + controller.feeds!.data!.topProfiles![index].mainImage.toString(),
                                                    profileName: controller.feeds!.data!.topProfiles![index].username ?? "",
                                                    followCount: controller.feeds!.data!.topProfiles![index].followersCount.toString(),
                                                    isFollowed: controller.feeds!.data!.topProfiles![index].isFollowed ??false,
                                                    location: controller.feeds!.data!.topProfiles![index].city ?? "",
                                                    projectViews: controller.feeds!.data!.topProfiles![index].viewsCount.toString(),
                                                    reviewCount: controller.feeds!.data!.topProfiles![index].reviewCount.toString(),
                                                  );
                                          },
                                        ),
                                      ),

                                      Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: AppColors.grey,
                                          indent: 24,
                                          endIndent: 24),
                                      const SizedBox(height: 17),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: CustomTextWidget(
                                          text: "Latest Projects",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 17),
                                      // Projects
                                      Selector<HomeViewModel, List<Projects>>(
                                        selector: (ctx, homeprovider) =>
                                            homeprovider.feeds!.data!.projects!,
                                        builder: (context, projects, child) {
                                          return ListView.separated(
                                            itemCount: projects.length,
                                            shrinkWrap: true,
                                            reverse: true,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return PostComponent(
                                                onTapUserProfile: () {

                                                  Navigator.pushNamed(
                                                      context,
                                                      RoutesName.userProfileView,
                                                      arguments: {"id": controller.feeds!.data!.projects![index].profile!.valProfileId.toString()}).then((v){
                                                    controller.updatePostData(v,index);
                                                  });

                                                },
                                                isMyPostDetail: false,
                                                key: UniqueKey(),
                                                onProjectDetail: () {
                                                  Navigator.pushNamed(context,
                                                      RoutesName.userPostDetail,
                                                      arguments: {"id": projects[index].projectId.toString(),}).then((result) {
                                                    if (result != null) {
                                                      // Handle the returned data
                                                      Map<String, dynamic>data = result as Map<String, dynamic>;
                                                      print("return data $data");
                                                      projects[index].likeCount = data['likeCount'];
                                                      projects[index].isSaved = data['isSaved'];
                                                      projects[index].isLiked = data['isLiked'];
                                                      controller.notifyListeners();
                                                    }
                                                  });
                                                },
                                                isFollow: projects[index].isFollowed,
                                                onFollow: () {
                                                  Provider.of<HomeViewModel>(
                                                      context, listen: false).getFollowProject(context,
                                                      id: projects[index].profile!.valProfileId.toString(),
                                                      index: index);
                                                },
                                                posts: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Container(

                                                      height: 300,
                                                      child: PageView.builder(
                                                        controller: controller.pageController,
                                                        itemCount: projects[index].mediaFiles!.length,
                                                        itemBuilder: (context, i) {
                                                          return Utils().customCachedNetworkImage(
                                                              height: 294,
                                                              width: 100,
                                                              shape: BoxShape.rectangle,
                                                              url: AppUrl.baseUrl +
                                                                  projects[index].mediaFiles![i].media!.toString());
                                                        },
                                                        onPageChanged: (index) {
                                                          controller.currentPage = index;
                                                          controller.notifyListeners();
                                                        },
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: 10,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: AppColors.blackColor.withOpacity(0.5),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children:
                                                              List.generate(projects[index].mediaFiles!.length,
                                                            (ind) => Container(
                                                              margin: EdgeInsets.all(2),
                                                              width: 7,
                                                              height: 7,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: controller.currentPage == ind
                                                                    ? AppColors.whiteColor
                                                                    : AppColors.whiteColor.withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                caption: projects[index].title.toString() ??
                                                    "",
                                                profileImage: AppUrl.baseUrl + projects[index].profile!.mainImage.toString(),
                                                profileName: projects[index].profile?.username.toString() ?? "",
                                                isLike: projects[index].isLiked,
                                                isSave: projects[index].isSaved,
                                                commentCount: projects[index]
                                                        .commentCount
                                                        .toString() ??
                                                    "",
                                                viewCount: projects[index]
                                                        .viewCount
                                                        .toString() ??
                                                    "",
                                                likecount: projects[index]
                                                        .likeCount
                                                        .toString() ??
                                                    "",
                                                location: projects[index]
                                                        .profile
                                                        ?.city
                                                        .toString() ??
                                                    "",
                                                postedDateTime:
                                                    controller.formatDateTime(
                                                        projects[index]
                                                            .postedOn
                                                            .toString()),
                                                onRate: () {
                                                  RatingSheet(context);
                                                },
                                                viewLiked: () {
                                                  // Navigator.pushNamed(context, RoutesName.likes);
                                                },
                                                onLike: () {
                                                  controller.getProjectLike(
                                                      context,
                                                      id: projects[index]
                                                          .projectId
                                                          .toString(),
                                                      index: index);
                                                },
                                                onSave: () {
                                                  controller.getSaveProject(
                                                      context,
                                                      id: projects[index]
                                                          .projectId
                                                          .toString(),
                                                      index: index);

                                                  // _pp.posts[index].isSave = !_pp.posts[index].isSave!;
                                                  // _pp.notifyListeners();
                                                },
                                              );
                                            },
                                            separatorBuilder: (context, cnt) {
                                              return SizedBox(height: 17);
                                            },
                                          );
                                        },
                                      ),

                                      const SizedBox(height: 100),
                                    ],
                                  ),
                                ),
                    ),
                  );
          },
        )),
      ),
    );
  }

  Future<dynamic> RatingSheet(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 25,
                ),
                CustomTextWidget(
                  text: "Rate this Project",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 20,
                ),
                RatingBar(
                  initialRating: 4,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  ignoreGestures: false,
                  itemCount: 5,
                  itemSize: 30,
                  ratingWidget: RatingWidget(
                    full: const SvgIconComponent(icon: 'star_yellow_icon.svg'),
                    half: const SvgIconComponent(icon: 'star_yellow_icon.svg'),
                    empty: const SvgIconComponent(icon: 'star_grey_icon.svg'),
                  ),
                  itemPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  height: 40,
                  width: 137,
                  radius: 26,
                  title: "Submit",
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontColor: AppColors.purple2,
                  borderColor: AppColors.purple2,
                  bgColor: AppColors.whiteColor,
                ),
                const SizedBox(
                  height: 27,
                )
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
