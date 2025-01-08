// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import '../configs/components/designer_component.dart';
import '../configs/components/main_scaffold.dart';
import '../configs/routes/routes_name.dart';
import '../configs/utils.dart';
import '../model/feedModel.dart';
import '../view_model/home_view_model.dart';

class TopRatedView extends StatelessWidget {
  FeedModel? feed;
  TopRatedView({Key? key, required this.feed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: CustomAppBar(
        title: "Top Rated Designers",
        backButtonColor: AppColors.blackColor,
        leading: true,
        onLeadingPress: (){
          Navigator.pop(context,feed!.data!.topProfiles);
        },
      ),
      body: WillPopScope(
        onWillPop: () async{
          Navigator.pop(context,feed!.data!.topProfiles);
          return false;
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 14, bottom: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<HomeViewModel>(
                  builder: (context, _dp, child) {
                    return Expanded(
                      child: ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, cnt) {
                                return const SizedBox(height: 15);
                              },
                              itemCount: feed!.data!.topProfiles!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return feed!.data!.topProfiles![index].username == null
                                    ? SizedBox.shrink()
                                    : DesignerComponent(
                                        isSaved: feed!.data!.topProfiles![index].isSaved ?? false,
                                        onSave: () {
                                          print("trigger save");
                                          _dp.toggleSaveProfileFromTopDesigner(context, feed!.data!.topProfiles![index].valProfileId.toString(),feed!);
                                          // Navigator.pushNamed(context, RoutesName.userProfileView);
                                        },
                                        onProfile: () {
                                          // Navigator.pushNamed(context, RoutesName.userProfileView);
                                          Navigator.pushNamed(context, RoutesName.userProfileView,arguments: {"id":feed!.data!.topProfiles![index].valProfileId.toString()});

                                        },
                                        onFollow: () {
                                          _dp.getFollowProfileFromDesigner(context, id: feed!.data!.topProfiles![index].valProfileId.toString(),index: index,feed:feed);
                                        },
                                        img: feed!.data!.topProfiles![index].mainImage.toString().toUpperCase().contains("NULL") ? "" : AppUrl.baseUrl + feed!.data!.topProfiles![index].mainImage.toString(),
                                        profileName: feed!.data!.topProfiles![index].username.toString(),
                                        followCount: feed!.data!.topProfiles![index].followersCount.toString(),
                                        isFollowed: feed!.data!.topProfiles![index].isFollowed!,
                                        location: feed!.data!.topProfiles![index].city.toString(),
                                        projectViews: feed!.data!.topProfiles![index].viewsCount.toString(),
                                        reviewCount: feed!.data!.topProfiles![index].reviewCount.toString(),
                                      );
                              },
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
