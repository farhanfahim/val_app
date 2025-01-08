// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/Repository/home_api/home_api_repo.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/profiles/my_profile_view_model.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../model/my_post_detail_model.dart';

class MyProfileView extends StatelessWidget {
  HomeHttpApiRepository projectRepository = HomeHttpApiRepository();

  MyProfileView({Key? key}) : super(key: key);

  Column BoxesWidget(BuildContext context, MyProfileViewModel profileProvider) {
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
                    text: profileProvider.myProfile!.data!.totalViews.toString(), //"649",
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
                    text: profileProvider.myProfile!.data!.totalLikes.toString(),
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
                Navigator.pushNamed(context, RoutesName.follower).then((v){
                  context.read<MyProfileViewModel>().getMyProfile(context);
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
                      text: profileProvider.myProfile!.data!.totalFollowers.toString(), //"20",
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
                Navigator.pushNamed(context, RoutesName.following).then((v){
                  context.read<MyProfileViewModel>().getMyProfile(context);
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
                      text: profileProvider.myProfile!.data!.totalFollowing.toString(), //"18",
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

  @override
  Widget build(BuildContext context) {
    context.read<MyProfileViewModel>().getMyProfile(context);

    return Consumer<MyProfileViewModel>(builder: (context, provider, child) {
      return MainScaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: "My Profile",
          leading: true,
          bgColor: Colors.transparent,
          backButtonColor: AppColors.blackColor,
          trailing: SvgIconComponent(
            icon: "edit.svg",
            onTap: () {
              provider.getMyProfileNew(context);
              // Navigator.pushNamed(context, RoutesName.createProfile, arguments: {
              //   'isEdit': true,
              // });
            },
          ),
        ),
        floatingActionButton: SvgIconComponent(
          icon: "add_purple_circle.svg",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.createProject).then((v){
              context.read<MyProfileViewModel>().getMyProfile(context);
            });
          },
        ),
        body: provider.loader == true
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 14, left: 24, right: 24,bottom: 24),
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
                          text: provider.myProfile?.data?.valProfile?.username.toString(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 3),
                        CustomTextWidget(
                          text: provider.myProfile?.data?.occupations?[0].occupations.toString() ?? "", //"3D Artist",
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
                              text: provider.myProfile?.data?.valProfile?.city.toString() ?? "", //"California, United States",
                              color: AppColors.grey3,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                            Divider(color: AppColors.grey2.withOpacity(.3)),
                            SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                            Consumer<MyProfileViewModel>(
                              builder: (context, _tp, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _tp.setSelected(TabsEnum.draft),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: _tp.selected == TabsEnum.draft ? AppColors.green : null,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                        child: CustomTextWidget(
                                          text: "Draft",
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
                            Consumer<MyProfileViewModel>(
                              builder: (context, _sp, child) {
                                switch (_sp.selected) {
                                  case TabsEnum.work:
                                    return provider.myProfile!.data!.postedProjects!.isNotEmpty
                                        ?GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: provider.myProfile!.data?.postedProjects?.length,
                                      // reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Navigator.pushNamed(context, RoutesName.myPostDetail, arguments: {
                                              "id": _sp.myProfile?.data?.postedProjects?[index].projectId.toString(),
                                            }).then((v){
                                              context.read<MyProfileViewModel>().getMyProfile(context);
                                            });
                                            // _sp.getMyProfiledetail(context, id: _sp.myProfile?.data?.postedProjects?[index].projectId.toString());
                                            // Navigator.pushNamed(context, RoutesName.myPostDetail);
                                          },
                                          child: Container(
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
                                                        decoration: BoxDecoration(
                                                          image: provider.myProfile!.data!.postedProjects![index].media != null
                                                              ? DecorationImage(
                                                                  image: NetworkImage(
                                                                    AppUrl.baseUrl + provider.myProfile!.data!.postedProjects![index].media.toString(),
                                                                  ),
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : DecorationImage(
                                                                  image: AssetImage(Utils.getIconImage("placeholder.png")),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 10,
                                                      top: 10,
                                                      child: Container(
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(color: AppColors.blackColor.withOpacity(.6), borderRadius: BorderRadius.circular(50)),
                                                        child: Row(
                                                          children: [
                                                            SvgIconComponent(
                                                              icon: "star_yellow_icon.svg",
                                                              width: 11,
                                                              height: 11,
                                                            ),
                                                            SizedBox(width: 3),
                                                            CustomTextWidget(
                                                              text: _sp.myProfile?.data?.postedProjects?[index].rating.toString(),
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: AppColors.whiteColor,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: CustomTextWidget(
                                                    textAlign: TextAlign.left,
                                                    text: provider.myProfile!.data!.postedProjects![index].title.toString(), //"3d rendering of house model",
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
                                    ):Container(
                                        height:300,
                                        child: Utils.noDataFoundMessage("No data found."));

                                  case TabsEnum.about:
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BoxesWidget(context, provider),
                                        SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                        Divider(color: AppColors.grey2.withOpacity(.3)),
                                        SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                        CustomTextWidget(text: "Description", fontSize: 16, fontWeight: FontWeight.w700),
                                        SizedBox(height: MediaQuery.of(context).size.height * 7 / 812),
                                        CustomTextWidget(
                                          text: provider.myProfile!.data!.valProfile!.about.toString(),
                                          //  "Lorem ipsum dolor sit amet consectetur. Velit nunc massa sit diam turpis id maecenas vulputate. Morb tristique eget nisl donec fames. Laoreet interdum ipsum viverra diam venenatis venenatis. Iaculis a neque varius etiam ut.",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.grey3,
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                        Divider(color: AppColors.grey2.withOpacity(.3)),
                                        SizedBox(height: MediaQuery.of(context).size.height * 15 / 812),
                                        CustomTextWidget(text: "Skills", fontSize: 16, fontWeight: FontWeight.w700),
                                        SizedBox(height: MediaQuery.of(context).size.height * 10 / 812),
                                        Consumer<MyProfileViewModel>(builder: (context, _skp, child) {
                                          return SkillsMethod(_skp);
                                        }),
                                      ],
                                    );
                                  case TabsEnum.draft:
                                    return provider.myProfile!.data!.draftedProjects!.isNotEmpty?
                                    GridView.builder(
                                      padding: EdgeInsets.zero,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      shrinkWrap: true,
                                      itemCount: provider.myProfile!.data?.draftedProjects?.length,
                                      // reverse: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            // _sp.getMyProfiledetail(context, id: _sp.myProfile?.data?.draftedProjects?[index].projectId.toString());
                                            // Navigator.pushNamed(
                                            //   context,
                                            //   RoutesName.editProject,
                                            //   arguments: provider.myProfile!.data?.draftedProjects![index],
                                            // );
                                            Navigator.pushNamed(
                                              context,
                                              RoutesName.editProject,
                                              arguments: {
                                                "id": provider.myProfile!.data?.draftedProjects![index].projectId.toString(),
                                                "myPostDetailModel": null,
                                              },
                                            ).then((v){
                                              if(v!=null){
                                                print("inside draft");
                                                provider.updateListOnDeleteDraft(index);
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10))],
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Utils().customCachedNetworkImage(
                                                //     url: AppUrl.baseUrl + provider.myProfile!.data!.draftedProjects![index].media.toString(),
                                                //     shape: BoxShape.rectangle,
                                                //     height: MediaQuery.of(context).size.height * 120 / 812,
                                                //     width: MediaQuery.of(context).size.width,
                                                //     borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                                                Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * 127 / 812,
                                                        width: MediaQuery.of(context).size.width,
                                                        decoration: BoxDecoration(
                                                          image: provider.myProfile!.data!.draftedProjects![index].media != null
                                                              ? DecorationImage(
                                                                  image: NetworkImage(
                                                                    AppUrl.baseUrl + provider.myProfile!.data!.draftedProjects![index].media.toString(),
                                                                  ),
                                                                  fit: BoxFit.cover,
                                                                )
                                                              : DecorationImage(
                                                                  image: AssetImage(Utils.getIconImage("placeholder.png")),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: CustomTextWidget(
                                                    textAlign: TextAlign.left,
                                                    text: provider.myProfile!.data!.draftedProjects![index].title ?? "----", //"3d rendering of house model",
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
                                    ):Container(
                                        height:300,
                                        child: Utils.noDataFoundMessage("No data found."));

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
              ),
      );
    });
  }

  Widget SkillsMethod(MyProfileViewModel _skp) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _skp.myProfile!.data!.skills!
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

  Stack TopImagesWidget(BuildContext context, MyProfileViewModel Provider) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 205 / 812,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Utils().customCachedNetworkImage(shape: BoxShape.rectangle, width: MediaQuery.of(context).size.width * 327 / 375, height: MediaQuery.of(context).size.height * 130 / 812, url: AppUrl.baseUrl + Provider.myProfile!.data!.valProfile!.coverImage.toString())),
        ),
        Positioned(
            top: 80,
            child: Utils().customCachedNetworkImage(
              shape: BoxShape.circle,
              width: 110,
              height: 110,
              url: AppUrl.baseUrl + Provider.myProfile!.data!.valProfile!.mainImage.toString(),
            )),
      ],
    );
  }
}
