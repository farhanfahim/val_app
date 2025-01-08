// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/utils.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../model/followers_model.dart';
import '../../view_model/profiles/user_followers_view_model.dart';

class UserFollowersView extends StatefulWidget {
  String id;
  UserFollowersView({Key? key, required this.id}) : super(key: key);

  @override
  State<UserFollowersView> createState() => _UserFollowersViewState();
}

class _UserFollowersViewState extends State<UserFollowersView> {
  final UserFollowersViewModel controller = UserFollowersViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getUserFollowers(context, widget.id, isPullToRefresh: false);
      },
    );
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          title: "Followers",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        body: Consumer<UserFollowersViewModel>(builder: (context, _cp, child) {
          return _cp.isLoading
              ? const SizedBox.shrink()
              : _cp.userfollowersList.isEmpty
                  ? Utils.noDataFoundMessage("No followers found.")
                  : RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        await controller.getUserFollowers(context, widget.id, isPullToRefresh: true);
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
                                separatorBuilder: (context, index) {
                                  return SizedBox(height: MediaQuery.of(context).size.height * 20 / 812);
                                },
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _cp.userfollowersList.length,
                                itemBuilder: (context, index) {
                                  Followers follower = _cp.userfollowersList[index];
                                  // bool isFollowing = _cp.followed.contains(follower);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            follower.mainImage == null
                                                ? Container(
                                                    height: 46,
                                                    width: 46,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(image: AssetImage(Utils.getIconImage("placeholder.png")), fit: BoxFit.cover),
                                                    ))
                                                : ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Utils().customCachedNetworkImage(
                                                      shape: BoxShape.circle,
                                                      url: AppUrl.baseUrl + follower.mainImage.toString(),
                                                      height: 46,
                                                      width: 46,
                                                    ),
                                                  ),
                                            SizedBox(width: 12),
                                            Flexible(
                                              child: CustomTextWidget(
                                                text: follower.username,
                                                fontSize: 16,
                                                maxLines: 1,
                                                overFlow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomButton(
                                        radius: 40,
                                        width: 90,
                                        height: 35,
                                        onTap: () {
                                          _cp.followUnfollow(context, id: follower.id.toString(), follow: follower, index: index);
                                        },
                                        fontWeight: FontWeight.w500,
                                        bgColor: follower.isFollow == true ? AppColors.primaryColor : null,
                                        borderColor: follower.isFollow == true ? AppColors.primaryColor : AppColors.primaryColor,
                                        borderWidth: follower.isFollow == true ? 2 : null,
                                        title: follower.isFollow == true ? "Following" : "Follow",
                                        fontSize: 12,
                                        fontColor: follower.isFollow == true ? AppColors.whiteColor : AppColors.primaryColor,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
        }),
      ),
    );
  }
}
