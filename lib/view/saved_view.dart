// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import '../configs/components/custom_text_widget.dart';
import '../configs/components/designer_component.dart';
import '../configs/components/main_scaffold.dart';
import '../configs/components/post_component.dart';
import '../configs/components/svg_icons_component.dart';
import '../configs/routes/routes_name.dart';
import '../configs/utils.dart';
import '../view_model/saved_view_model.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> with TickerProviderStateMixin {
  final SavedViewModel controller = SavedViewModel();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getAllSavedProjects(context, isPullToRefresh: false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          title: "Saved",
          backButtonColor: AppColors.blackColor,
          leading: false,
        ),
        body: Consumer<SavedViewModel>(
          builder: (context, provider, child) {
            return provider.savedLoader == true
                ? Center(
                    child: Utils().spinkit,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.82,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Card(
                            elevation: 6,
                            color: AppColors.whiteColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                automaticIndicatorColorAdjustment: true,
                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                unselectedLabelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                labelColor: AppColors.blackColor,
                                dividerColor: Colors.transparent,
                                dividerHeight: 0,
                                unselectedLabelColor: AppColors.grey2,
                                labelPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                                controller: tabController,
                                indicator: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                tabs: [
                                  Text(
                                    "Creative",
                                  ),
                                  Text(
                                    "Projects",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Consumer<SavedViewModel>(
                          builder: (context, _sp, child) {
                            return Expanded(
                              child: TabBarView(
                                controller: tabController,
                                children: [
                                  //creative
                                  _sp.isProfileLoader
                                      ? const SizedBox.shrink()
                                      : RefreshIndicator(
                                              backgroundColor: AppColors.whiteColor,
                                              color: AppColors.primaryColor,
                                              onRefresh: () async {
                                                await controller.getAllSavedProjects(context, isPullToRefresh: true);
                                              },
                                              child: SingleChildScrollView(
                                                physics: AlwaysScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    _sp.savedProjects!.data!.savedProfiles!.isEmpty
                                                        ? Container(height:500,child: Utils.noDataFoundMessage("No profiles found."))
                                                        :ListView.separated(

                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      separatorBuilder: (context, cnt) {
                                                        return const SizedBox(height: 15);
                                                      },
                                                      itemCount: (_sp.savedProjects!.data!.savedProfiles ?? []).length,
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      scrollDirection: Axis.vertical,
                                                      itemBuilder: (context, index) {
                                                        return DesignerComponent(
                                                          onSave: () {
                                                            _sp.getSaveProfile(context, id: _sp.savedProjects!.data!.savedProfiles![index].valProfileId.toString());
                                                          },
                                                          onProfile: () {
                                                            Navigator.pushNamed(context, RoutesName.userProfileView,arguments: {"id":_sp.savedProjects!.data!.savedProfiles![index].valProfileId.toString()}).then((v){
                                                              _sp.updateData(v,index);
                                                            });
                                                          },
                                                          onFollow: () {
                                                            _sp.getFollowProfile(context, id: _sp.savedProjects!.data!.savedProfiles![index].valProfileId.toString());
                                                          },
                                                          img: _sp.savedProjects!.data!.savedProfiles![index].mainImage == null
                                                              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm-TruksPXPI5imDL_kfzEfFiAZwg5AzHtWg&s"
                                                              : _sp.savedProjects!.data!.savedProfiles![index].mainImage!.toString().toUpperCase().contains("NULL")
                                                              ? ""
                                                              : AppUrl.baseUrl + _sp.savedProjects!.data!.savedProfiles![index].mainImage!.toString(),
                                                          profileName: _sp.savedProjects?.data?.savedProfiles?[index].username.toString() ?? "",
                                                          followCount: _sp.savedProjects?.data?.savedProfiles?[index].followersCount.toString() ?? "",
                                                          isFollowed: _sp.savedProjects?.data?.savedProfiles?[index].isFollowed ?? false,
                                                          isSaved: _sp.savedProjects?.data?.savedProfiles?[index].isSaved ?? false,
                                                          location: _sp.savedProjects?.data?.savedProfiles?[index].city.toString() ?? "",
                                                          projectViews: _sp.savedProjects?.data?.savedProfiles?[index].viewsCount.toString() ?? "",
                                                          reviewCount: _sp.savedProjects?.data?.savedProfiles?[index].reviewCount.toString() ?? "",
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                  //Projects
                                  _sp.savedLoader
                                      ? const SizedBox.shrink()
                                      : RefreshIndicator(
                                              backgroundColor: AppColors.whiteColor,
                                              color: AppColors.primaryColor,
                                              onRefresh: () async {
                                                await controller.getAllSavedProjects(context, isPullToRefresh: true);
                                              },
                                              child: SingleChildScrollView(
                                                physics: AlwaysScrollableScrollPhysics(),
                                                child: Column(
                                                  children: [
                                                    _sp.savedProjects!.data!.savedProjects!.isEmpty
                                                        ? Container(height:500,child: Utils.noDataFoundMessage("No projects found."))
                                                        : ListView.separated(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                                      scrollDirection: Axis.vertical,
                                                      itemCount: _sp.savedProjects!.data!.savedProjects!.length,
                                                      itemBuilder: (context, index) {
                                                        return PostComponent(
                                                          key: UniqueKey(),
                                                          isMyPostDetail: false,
                                                          onProjectDetail: () {
                                                            // _sp.getUserPostDetail(context, id: _sp.savedProjects!.data!.savedProjects![index].projectId.toString());
                                                            Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {
                                                              "id": _sp.savedProjects!.data!.savedProjects![index].projectId.toString(),
                                                            });
                                                            // _pp.getProjectViewCount(context, id: _pp.feeds!.data!.projects![index].projectId.toString());
                                                            // Navigator.pushNamed(context, RoutesName.userPostDetail);
                                                          },
                                                          isFollow: _sp.savedProjects!.data!.savedProjects![index].profile?.isFollowed ?? false,
                                                          onFollow: () {
                                                            provider.getFollowProfile(context, id: _sp.savedProjects!.data!.savedProjects![index].profile!.valProfileId.toString());
                                                          },
                                                          posts: Stack(
                                                            alignment: Alignment.center,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * 375 / 375,
                                                                height: MediaQuery.of(context).size.height * 350 / 812,
                                                                child: PageView.builder(
                                                                  controller: _sp.pageController,
                                                                  itemCount: _sp.savedProjects!.data!.savedProjects![index].mediaFiles!.length,
                                                                  itemBuilder: (context, i) {
                                                                    return Utils().customCachedNetworkImage(height: 294, width: MediaQuery.of(context).size.width, shape: BoxShape.rectangle, url: AppUrl.baseUrl + _sp.savedProjects!.data!.savedProjects![index].mediaFiles![i].media!.toString());
                                                                  },
                                                                  onPageChanged: (index) {
                                                                    _sp.currentPage = index;
                                                                    _sp.notifyListeners();
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
                                                                    children: List.generate(
                                                                      _sp.savedProjects!.data!.savedProjects![index].mediaFiles!.length,
                                                                      (ind) => Container(
                                                                        margin: EdgeInsets.all(2),
                                                                        width: 7,
                                                                        height: 7,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.circle,
                                                                          color: _sp.currentPage == ind ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          caption: _sp.savedProjects?.data?.savedProjects?[index].title.toString() ?? "",
                                                          profileImage: AppUrl.baseUrl + _sp.savedProjects!.data!.savedProjects![index].profile!.mainImage.toString(),
                                                          profileName: _sp.savedProjects?.data?.savedProjects?[index].profile?.username.toString() ?? "",
                                                          isLike: _sp.savedProjects?.data?.savedProjects?[index].isLiked,
                                                          isSave: _sp.savedProjects?.data?.savedProjects?[index].isSaved,
                                                          commentCount: _sp.savedProjects?.data?.savedProjects?[index].commentCount.toString() ?? "",
                                                          viewCount: _sp.savedProjects?.data?.savedProjects?[index].viewCount.toString() ?? "",
                                                          likecount: _sp.savedProjects?.data?.savedProjects?[index].likeCount.toString() ?? "",
                                                          location: _sp.savedProjects?.data?.savedProjects?[index].profile?.city.toString() ?? "",
                                                          postedDateTime: _sp.formatDateTime(_sp.savedProjects!.data!.savedProjects![index].postedOn.toString()),
                                                          onRate: () {
                                                            RatingSheet(context, provider, index);
                                                          },
                                                          viewLiked: () {
                                                            Navigator.pushNamed(context, RoutesName.likes);
                                                          },
                                                          onLike: () {
                                                            provider.getProjectLike(context, id: _sp.savedProjects?.data?.savedProjects?[index].projectId.toString(), index: index);
                                                          },
                                                          onSave: () {
                                                            provider.getSaveProject(context, id: _sp.savedProjects?.data?.savedProjects?[index].projectId.toString());

                                                            // _pp.posts[index].isSave = !_pp.posts[index].isSave!;
                                                            // _pp.notifyListeners();
                                                          },
                                                        );
                                                      },
                                                      separatorBuilder: (context, cnt) {
                                                        return SizedBox(height: 17);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  String rate = "";
  Future<dynamic> RatingSheet(BuildContext context, SavedViewModel provider, int index) {
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
                  initialRating: 0,
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
                  itemPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  onRatingUpdate: (rating) {
                    print(rating);
                    rate = rating.toString();
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                  onTap: () {
                    // Navigator.pop(context);
                    provider.postRate(context, rate: rate, id: provider.savedProjects!.data!.savedProjects![index].projectId.toString());
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
}
