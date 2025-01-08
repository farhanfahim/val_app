import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/model/followers_model.dart';
import 'package:val_app/view_model/profiles/following_view_model.dart';
import '../../configs/app_urls.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';

class FollowingView extends StatefulWidget {
  FollowingView({Key? key}) : super(key: key);

  @override
  State<FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<FollowingView> {
  final FollowingViewModel controller = FollowingViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getFollowing(context, isPullToRefresh: false);
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
          title: "Following",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        body: Consumer<FollowingViewModel>(
          builder: (context, _cp, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 14),
              child: _cp.isLoading
                  ? const SizedBox.shrink()
                  : _cp.followingList.isEmpty
                      ? Utils.noDataFoundMessage("No following found.")
                      : RefreshIndicator(
                          backgroundColor: AppColors.whiteColor,
                          color: AppColors.primaryColor,
                          onRefresh: () async {
                            await controller.getFollowing(context, isPullToRefresh: true);
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                                    itemCount: _cp.followingList.length,
                                    itemBuilder: (context, index) {
                                      Following followingList = _cp.followingList[index];
                                      bool isFollowing = _cp.following.contains(followingList);
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Row(
                                              children: [
                                                followingList.mainImage == null
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
                                                          url: AppUrl.baseUrl + followingList.mainImage.toString(),
                                                          height: 46,
                                                          width: 46,
                                                        ),
                                                      ),
                                                SizedBox(width: 12),
                                                Flexible(
                                                  child: CustomTextWidget(
                                                    text: followingList.username,
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
                                            fontWeight: FontWeight.w500,
                                            bgColor: isFollowing ? null : AppColors.primaryColor,
                                            borderColor: isFollowing ? AppColors.primaryColor : AppColors.primaryColor,
                                            borderWidth: isFollowing ? null : 2,
                                            title: isFollowing ? "Follow" : "Following",
                                            fontSize: 14,
                                            onTap: () {
                                              _cp.followUnfollow(context, id: followingList.id.toString(), following: followingList);
                                            },
                                            fontColor: isFollowing ? AppColors.primaryColor : AppColors.whiteColor,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
            );
          },
        ),
      ),
    );
  }
}
