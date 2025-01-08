// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';

import '../../configs/Global.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/post_detail_component.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/post/user_post_detail_view_model.dart';

class UserPostDetailView extends StatefulWidget {
  final String id;
  UserPostDetailView({Key? key, required this.id}) : super(key: key);

  @override
  State<UserPostDetailView> createState() => _UserPostDetailViewState();
}

class _UserPostDetailViewState extends State<UserPostDetailView> {
  final UserPostDetailViewModel controller = UserPostDetailViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getUserPostDetail(context, id: widget.id);
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
      child: Consumer<UserPostDetailViewModel>(
        builder: (context, provider, child) {
          return MainScaffold(
            appBar: CustomAppBar(
              leading: true,
              backButtonColor: AppColors.blackColor,
              title: "Post Detail",
              onLeadingPress:(){
                // Create a map with data to return
                Map<String, dynamic> returnData = {
                  'likeCount': provider.feedPostDetail?.data?.metrics?.likeCount?? 0,
                  'isLiked': provider.feedPostDetail?.data?.isLiked?? false,
                  'isSaved': provider.feedPostDetail?.data?.isSaved?? false,
                };

                // Pop the screen and return the data
                Navigator.pop(context, returnData);
              },
              trailing: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showCustomBottomSheet(context, provider);
                },
                child: Icon(Icons.more_vert),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, -10))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    provider.feedPostDetail != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              bottomIcons(() async {
                                print('${AppUrl.baseUrl}/${provider.feedPostDetail!.data!.id}');
                                final result = await Share.share('${AppUrl.baseUrl}/${provider.feedPostDetail!.data!.id}');
              
                                if (result.status == ShareResultStatus.success) {
                                  print('Thank you for sharing my website!');
                                }
                              }, "share_circle_unselected.svg", "Share"),
                              bottomIcons(() {
                                ratingMethod(context, provider);
                              }, "rate_circle_unselected.svg", "Rate"),
                              bottomIcons(() {
                                provider.postLike(context, id: provider.feedPostDetail?.data?.id?.toString() ?? "");
                              }, provider.feedPostDetail!.data!.isLiked! ? "like_circle_selected.svg" : "like_circle_unselected.svg", "Like"),
                              bottomIcons(() {
                                provider.postSave(context, id: provider.feedPostDetail?.data?.id?.toString() ?? "");
                              }, provider.feedPostDetail!.data!.isSaved! ? "saved_circle_selected.svg" : "saved_circle_unselected.svg", "Saved"),
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            body:
                // provider.loader == true
                //     ? Center(
                //         child: Utils().spinkit,
                //       )
                //     :
                Padding(
              padding: const EdgeInsets.only(top: 14),
              child: RefreshIndicator(
                backgroundColor: AppColors.whiteColor,
                color: AppColors.primaryColor,
                onRefresh: () async {
                  await provider.getUserPostDetail(context, id: widget.id, isShowLoader: false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            PostDetailComponent(
                              isFollow: provider.feedPostDetail?.data?.profile?.isFollow ?? false,
                              occupation: provider.feedPostDetail?.data?.profile?.occupations![0].occupation ?? "",
                              onTapUserProfile: () {
                                // Navigator.pushNamed(context, RoutesName.userProfileView);
                                Navigator.pushNamed(context, RoutesName.userProfileView,arguments: {"id":provider.feedPostDetail!.data!.profile!.id.toString()});
                              },
                              onProjectDetail: () {},
                              onFollow: () {
                                provider.getFollowProfile(context, id: provider.feedPostDetail!.data!.profile!.id.toString());
                              },
                              posts: SlicerMethod(context, provider),
                              location: provider.feedPostDetail?.data?.profile?.city?.toString() ?? "",
                              caption: provider.feedPostDetail?.data?.title?.toString() ?? "",
                              profileImage: provider.feedPostDetail?.data == null
                                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm-TruksPXPI5imDL_kfzEfFiAZwg5AzHtWg&s"
                                  : provider.feedPostDetail!.data!.profile!.mainImage.toString().toUpperCase().contains("null")
                                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm-TruksPXPI5imDL_kfzEfFiAZwg5AzHtWg&s"
                                      : AppUrl.baseUrl + provider.feedPostDetail!.data!.profile!.mainImage.toString(),
                              profileName: provider.feedPostDetail?.data?.profile?.username.toString() ?? "",
                              description: provider.feedPostDetail?.data?.description?.toString() ?? "",
                              isLike: provider.feedPostDetail?.data?.isLiked,
                              publish: Utils().formatDate2(provider.feedPostDetail?.data?.postedOn?.toString() ?? ""),
                              isSave: provider.feedPostDetail?.data?.isSaved,
                              showContent: provider.show,
                              commentCount: provider.feedPostDetail?.data?.metrics?.commentCount.toString() ?? "",
                              likeCount: provider.feedPostDetail?.data?.metrics?.likeCount.toString() ?? "",
                              viewCount: provider.feedPostDetail?.data?.metrics?.viewCount.toString() ?? "",
                              isMyPost: false,
                              rating: provider.feedPostDetail?.data?.metrics?.averageRating!.toStringAsFixed(1) ?? "",
                              onTapHide: () => provider.hideData(),
                              onTapShow: () => provider.showData(),
                              tools: ToolsMethod(provider),
                              tags: TagsMethod(provider),
                              category: CategoryMethod(provider),
                              onRate: () {
                                ratingMethod(context, provider);
                              },
                              onLike: () {
                                provider.postLike(context, id: provider.feedPostDetail!.data!.id!.toString());
                              },
                              onSave: () {
                                provider.feedPostDetail!.data!.isSaved = !provider.feedPostDetail!.data!.isSaved!;
                              },
                            ),
                            // Comments Section
                            provider.feedPostDetail?.data == null
                                ? SizedBox.shrink()
                                : provider.feedPostDetail!.data!.comments!.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20),
                                        child: Center(
                                          child: Text("No Comments yet"),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 15),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CustomTextWidget(
                                                  text: "Comments",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior.opaque,
                                                  onTap: () {
                                                    Navigator.pushNamed(context, RoutesName.allComments, arguments: {
                                                      "id": provider.feedPostDetail?.data?.id.toString(),
                                                    });
                                                  },
                                                  child: CustomTextWidget(
                                                    text: "View All",
                                                    fontSize: 16,
                                                    color: AppColors.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 19),
                                            ListView.separated(
                                              separatorBuilder: (context, index) {
                                                return SizedBox(height: MediaQuery.of(context).size.height * 16 / 812);
                                              },
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: provider.feedPostDetail!.data!.comments!.length,
                                              itemBuilder: (context, index) {
                                                return CommentSectionWidget(index, provider);
                                              },
                                            ),
                                            const SizedBox(height: 19),
                                          ],
                                        ),
                                      ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        margin: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                        decoration: Utils.boxDecorationRoundedBorder,
                        child: CustomTextField(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          maxLines: 1,
                          onChangeFtn: (v) {
                            return "";
                          },
                          cursorColor: AppColors.primaryColor,
                          fillColor: provider.focusComment.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                          focusColor: Colors.transparent,
                          hint: "Type your comment...",
                          hintFontSize: 14,
                          enableBorderColor: Colors.transparent,
                          textInputType: TextInputType.visiblePassword,
                          txtController: provider.commentTextEditingController,
                          textInputAction: TextInputAction.next,
                          node: provider.focusComment,
                          onTap: () {},
                          borderRadius: 70,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              provider.postComment(context, id: provider.feedPostDetail!.data!.id.toString()).then(
                                (value) {
                                  provider.getUserPostDetail(context, id: provider.feedPostDetail!.data!.id.toString());
                                },
                              );
                            },
                            child: SvgIconComponent(
                              icon: "share_purple.svg",
                              height: 22,
                              width: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }



  Future<dynamic> ratingMethod(BuildContext context, UserPostDetailViewModel provider) {
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
                  initialRating: provider.rate,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
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
                    provider.rate = rating;
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomButton(
                  onTap: () {
                    // Navigator.pop(context);
                    provider.feedPostDetail?.data?.metrics?.averageRating = provider.rate;
                    provider.postRate(context, id: provider.feedPostDetail!.data!.id.toString(), rate: provider.rate);
                    provider.notifyListeners();
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

  Widget CommentSectionWidget(int index, UserPostDetailViewModel userPostDetail) {
    return Container(
      padding: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.blackColor.withOpacity(.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(borderRadius: BorderRadius.circular(50), child: Utils().customCachedNetworkImage(height: 46, width: 46, shape: BoxShape.circle, url: AppUrl.baseUrl + userPostDetail.feedPostDetail!.data!.comments![index].commentedBy!.mainImage.toString())),
                    SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextWidget(
                                text: userPostDetail.feedPostDetail!.data!.comments![index].commentedBy!.username.toString(), //"Rayna Donin",
                                fontSize: 16,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomTextWidget(
                                text: getTimeAgo(commentDateTime: DateTime.parse(userPostDetail.feedPostDetail!.data!.comments![index].commentedAt.toString())),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey3,
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          CustomTextWidget(
                            text: userPostDetail.feedPostDetail!.data!.comments![index].comment!.toString(), //"Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.grey5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  GestureDetector bottomIcons(void Function()? onTap, String? icon, String title) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          SvgIconComponent(
            icon: icon!,
            height: 48,
            width: 48,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            text: title,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }

  Widget SlicerMethod(BuildContext context, UserPostDetailViewModel _pdp) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 375 / 375,
          height: MediaQuery.of(context).size.height * 365 / 812,
          child: PageView.builder(
            controller: _pdp.pageController,
            itemCount: (_pdp.feedPostDetail?.data?.media ?? []).length,
            itemBuilder: (context, i) {
              return _pdp.feedPostDetail!.data!.media?.isEmpty ?? false ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRm-TruksPXPI5imDL_kfzEfFiAZwg5AzHtWg&s" : Utils().customCachedNetworkImage(height: 29, width: MediaQuery.of(context).size.width, shape: BoxShape.rectangle, url: AppUrl.baseUrl + _pdp.feedPostDetail!.data!.media![i].media.toString());
            },
            onPageChanged: (index) {
              _pdp.currentPage = index;
              _pdp.notifyListeners();
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
                (_pdp.feedPostDetail?.data?.media ?? []).length,
                (index) => Container(
                  margin: EdgeInsets.all(2),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _pdp.currentPage == index ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        _pdp.feedPostDetail?.data == null
            ? SizedBox.shrink()
            : _pdp.feedPostDetail!.data!.media!.length == 0
                ? SizedBox.shrink()
                : Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.blackColor.withOpacity(.7),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: CustomTextWidget(
                        text: "${(_pdp.currentPage + 1).toString()}/${_pdp.feedPostDetail!.data!.media!.length}",
                        fontSize: 12,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
      ],
    );
  }

  Widget CategoryMethod(UserPostDetailViewModel _pdp) {
    return _pdp.feedPostDetail?.data == null
        ? SizedBox.shrink()
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_pdp.feedPostDetail?.data?.categories ?? [])
                .map(
                  (categories) => Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.blackColor,
                    ),
                    child: CustomTextWidget(
                      text: categories.categoryName.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
                .toList(),
          );
  }

  Widget TagsMethod(UserPostDetailViewModel _pdp) {
    return _pdp.feedPostDetail?.data == null
        ? SizedBox.shrink()
        : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (_pdp.feedPostDetail?.data?.tags ?? [])
                .map(
                  (tags) => Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.blackColor,
                    ),
                    child: CustomTextWidget(
                      text: tags.tag.toString(),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
                .toList(),
          );
  }

  Widget ToolsMethod(UserPostDetailViewModel _pdp) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: (_pdp.feedPostDetail?.data?.tools ?? [])
          .map(
            (tools) => Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.blackColor,
              ),
              child: CustomTextWidget(
                text: tools.toolName.toString(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          )
          .toList(),
    );
  }

  void showCustomBottomSheet(BuildContext context, UserPostDetailViewModel provider) {
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
                  Navigator.pushNamed(context, RoutesName.reportProject, arguments: {
                    "id": provider.feedPostDetail?.data?.id.toString(),
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
              SizedBox(height: 30)
            ],
          ),
        );
      },
    );
  }
}
