// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/profiles/user_profile_view_model.dart';

class UserProfileView extends StatefulWidget {
  final String id;

  const UserProfileView({Key? key, required this.id}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final UserMyProfileViewModel controller = UserMyProfileViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getOtherUserProfile(context, id: widget.id);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var cn = Provider.of<UserMyProfileViewModel>(context);
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "Profile",
          leading: true,
          onLeadingPress: (){
            Navigator.pop(context,controller.otherUSer!.data!.isFollowing);
          },
          bgColor: Colors.transparent,
          backButtonColor: AppColors.blackColor,
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              ReportSheet(context, controller);
            },
            child: Icon(Icons.more_vert),
          ),
        ),
        body: SafeArea(
          child: Consumer<UserMyProfileViewModel>(builder: (context, provider, child) {
            return provider.otherUSer == null
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 14, left: 24, right: 24),
                    child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            TopImagesWidget(context, provider),
                            CustomTextWidget(
                              text: provider.otherUSer?.data?.username?.toString() ?? "",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(height: 3),
                            provider.otherUSer?.data?.occupations?.isEmpty ?? false
                                ? SizedBox.shrink()
                                : CustomTextWidget(
                                    text: provider.otherUSer?.data?.occupations?[0].occupations.toString() ?? "", //"3D Artist",
                                    color: AppColors.grey3,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                            SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgIconComponent(icon: "pin.svg"),
                                const SizedBox(width: 4),
                                CustomTextWidget(
                                  text: provider.otherUSer?.data?.city?.toString() ?? "",
                                  //"California, United States",
                                  color: AppColors.grey3,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    onTap: () {
                                      provider.getFollowProfile(context, id: provider.otherUSer?.data?.id.toString());
                                    },
                                    bgColor: provider.otherUSer!.data!.isFollowing! ? AppColors.primaryColor : AppColors.whiteColor,
                                    height: 40,
                                    title: provider.otherUSer!.data!.isFollowing! ? "Following" : "Follow",
                                    fontColor: provider.otherUSer!.data!.isFollowing! ? AppColors.whiteColor : AppColors.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    radius: 40,
                                    borderColor: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: CustomButton(
                                    onTap: () {
                                      Navigator.pushNamed(context, RoutesName.chatDetail, arguments: {
                                        "userId": provider.otherUSer?.data!.userId.toString(),
                                      });
                                    },
                                    bgColor: AppColors.primaryColor,
                                    height: 40,
                                    title: "Message",
                                    fontColor: AppColors.whiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    radius: 40,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                Divider(color: AppColors.grey2.withOpacity(.3)),
                                SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                Consumer<UserMyProfileViewModel>(
                                  builder: (context, _tp, child) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => _tp.setSelected(TabsEnum.work),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: _tp.selected == TabsEnum.work ? AppColors.green : null,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: CustomTextWidget(
                                              text: "Work",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () => _tp.setSelected(TabsEnum.about),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                            decoration: BoxDecoration(
                                              color: _tp.selected == TabsEnum.about ? AppColors.green : null,
                                              borderRadius: BorderRadius.circular(40),
                                            ),
                                            child: CustomTextWidget(
                                              text: "About",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 23),
                                //work
                                Consumer<UserMyProfileViewModel>(
                                  builder: (context, _sp, child) {
                                    switch (_sp.selected) {
                                      case TabsEnum.work:
                                        return _sp.otherUSer!.data!.projects!.isEmpty
                                            ? Utils.noDataFoundMessage("No work found.")
                                            : GridView.builder(
                                                padding: EdgeInsets.zero,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                ),
                                                shrinkWrap: true,
                                                itemCount: _sp.otherUSer!.data!.projects!.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {
                                                        "id": _sp.otherUSer!.data!.projects![index].projectId.toString(),
                                                      });
                                                      // _sp.getMyProfiledetail(context, id: _sp.otherUSer!.data!.projects![index].projectId.toString());
                                                    },
                                                    child: Container(
                                                      // height: 147,
                                                      decoration: BoxDecoration(
                                                        color: AppColors.whiteColor,
                                                        borderRadius: BorderRadius.circular(12),
                                                        boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Stack(
                                                            clipBehavior: Clip.none,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                                child: Container(
                                                                  height: MediaQuery.of(context).size.height * 127 / 812,
                                                                  width: MediaQuery.of(context).size.width,
                                                                  child: _sp.otherUSer!.data!.projects![index].coverMedia == null
                                                                      ? Image.asset(
                                                                          Utils.getIconImage("placeholder.png"),
                                                                          fit: BoxFit.cover,
                                                                        )
                                                                      : Utils().customCachedNetworkImage(
                                                                          height: 294,
                                                                          width: MediaQuery.of(context).size.width,
                                                                          shape: BoxShape.rectangle,
                                                                          url: AppUrl.baseUrl + _sp.otherUSer!.data!.projects![index].coverMedia.toString(),
                                                                        ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5),
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            child: CustomTextWidget(
                                                              text: _sp.otherUSer!.data!.projects![index].title.toString(),
                                                              // "3d rendering of house model",
                                                              fontSize: 12,
                                                              maxLines: 2,
                                                              fontWeight: FontWeight.w800,
                                                              overFlow: TextOverflow.ellipsis,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                      case TabsEnum.about:
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            BoxesWidget(context, _sp),
                                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                            Divider(color: AppColors.grey2.withOpacity(.3)),
                                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                            CustomTextWidget(text: "Description", fontSize: 16, fontWeight: FontWeight.w700),
                                            SizedBox(height: MediaQuery.of(context).size.height * 7 / 812),
                                            CustomTextWidget(
                                              text: _sp.otherUSer?.data?.about.toString() ?? "",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grey3,
                                            ),
                                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                            Divider(color: AppColors.grey2.withOpacity(.3)),
                                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                            CustomTextWidget(text: "Skills", fontSize: 16, fontWeight: FontWeight.w700),
                                            SizedBox(height: MediaQuery.of(context).size.height * 10 / 812),
                                            Consumer<UserMyProfileViewModel>(builder: (context, _skp, child) {
                                              return SkillsMethod(_skp);
                                            }),
                                          ],
                                        );
                                      default:
                                        return Container();
                                    }
                                  },
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          }),
        ),
      ),
    );
  }

  Widget SkillsMethod(UserMyProfileViewModel _skp) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _skp.otherUSer!.data!.skills!
          .map(
            (skills) => Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.blackColor,
              ),
              child: CustomTextWidget(
                text: skills.tool.toString(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          )
          .toList(),
    );
  }

  Column BoxesWidget(BuildContext context, UserMyProfileViewModel provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 77 / 812,
              width: MediaQuery.of(context).size.width * 158 / 375,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor.withOpacity(.1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    text: provider.otherUSer?.data?.totalProjectViews.toString(), //"649",
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  CustomTextWidget(
                    text: "Project Views",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
            SizedBox(width: 5),
            Container(
              height: MediaQuery.of(context).size.height * 77 / 812,
              width: MediaQuery.of(context).size.width * 158 / 375,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor.withOpacity(.1)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    text: provider.otherUSer?.data?.totalProjectLikes.toString(),
                    //"436",
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  CustomTextWidget(
                    text: "Project Likes",
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, RoutesName.usersFollowers, arguments: {
                  "id": provider.otherUSer?.data!.id.toString(),
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 77 / 812,
                width: MediaQuery.of(context).size.width * 158 / 375,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor.withOpacity(.1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: provider.otherUSer?.data?.totalFollowers.toString(),
                      //"20",
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    CustomTextWidget(
                      text: "Followers",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pushNamed(context, RoutesName.usersFollowing, arguments: {
                  "id": provider.otherUSer?.data!.id.toString(),
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 77 / 812,
                width: MediaQuery.of(context).size.width * 158 / 375,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primaryColor.withOpacity(.1)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: provider.otherUSer?.data?.totalFollowing.toString(),
                      //"18",
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                    CustomTextWidget(
                      text: "Following",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<dynamic> ReportSheet(BuildContext context, UserMyProfileViewModel provider) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutesName.report, arguments: {
                    "id": controller.otherUSer?.data!.id.toString(),
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgIconComponent(
                          icon: "info.svg",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 15),
                        CustomTextWidget(
                          text: "Report",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SvgIconComponent(
                      icon: "right_purple.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(height: 22),
              Divider(color: AppColors.grey2.withOpacity(.3)),
              SizedBox(height: 22),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  blockSheet(context, provider);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgIconComponent(
                          icon: "block-user.svg",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 15),
                        CustomTextWidget(
                          text: "Block user",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SvgIconComponent(
                      icon: "right_purple.svg",
                      width: 20,
                      height: 20,
                    )
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Stack TopImagesWidget(BuildContext context, UserMyProfileViewModel provider) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 205 / 812,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: provider.otherUSer?.data?.coverImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Utils().customCachedNetworkImage(
                    shape: BoxShape.rectangle,
                    width: MediaQuery.of(context).size.width * 327 / 375,
                    height: MediaQuery.of(context).size.height * 130 / 812,
                    url: AppUrl.baseUrl + provider.otherUSer!.data!.coverImage.toString(),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width * 327 / 375,
                  height: MediaQuery.of(context).size.height * 130 / 812,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(image: AssetImage(Utils.getIconImage("placeholder.png")), fit: BoxFit.cover),
                  ),
                ),
          // ClipRRect(
          //     borderRadius: BorderRadius.circular(10),
          //     child: Utils().customCachedNetworkImage(
          //       shape: BoxShape.rectangle,
          //       width: MediaQuery.of(context).size.width * 327 / 375,
          //       height: MediaQuery.of(context).size.height * 130 / 812,
          //       url: "",
          //     ),
          //   ),
        ),
        provider.otherUSer == null
            ? SizedBox.shrink()
            : Positioned(
                top: 80,
                child: provider.otherUSer!.data!.mainImage != null
                    ? Utils().customCachedNetworkImage(
                        shape: BoxShape.circle,
                        width: 110,
                        height: 110,
                        url: AppUrl.baseUrl + provider.otherUSer!.data!.mainImage.toString(),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(Utils.getIconImage("placeholder.png")),
                      ),
              )
      ],
    );
  }

  void blockSheet(BuildContext context, UserMyProfileViewModel controllerA) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                text: "Are you sure you want to block this user?",
                fontSize: 18,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 33),
              Row(
                children: [
                  CustomButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    bgColor: Colors.transparent,
                    radius: 50,
                    title: "No",
                    height: 49,
                    borderColor: AppColors.grey3,
                    fontColor: AppColors.grey3,
                    width: 156,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(width: 15),
                  CustomButton(
                    onTap: () {
                      //print(controller.otherUSer?.data);
                      controller.blockUser(context, "${controller.otherUSer?.data!.userId}");
                    },
                    radius: 50,
                    bgColor: Colors.transparent,
                    title: "Yes",
                    borderColor: AppColors.primaryColor,
                    fontColor: AppColors.primaryColor,
                    height: 49,
                    width: 156,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
