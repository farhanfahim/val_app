// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/main.dart';
import '../../configs/Global.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/post_detail_component.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/post/my_post_detail_view_model.dart';

class MyPostDetailView extends StatefulWidget {
  final String id;
  const MyPostDetailView({Key? key, required this.id}) : super(key: key);

  @override
  State<MyPostDetailView> createState() => _MyPostDetailViewState();
}

class _MyPostDetailViewState extends State<MyPostDetailView> {
  final MyPostDetailViewModel controller = MyPostDetailViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getMyProjectDetail(context, id: widget.id);
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
          leading: true,
          backButtonColor: AppColors.blackColor,
          title: "Post Detail",
          trailing: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              showCustomBottomSheet(context, controller);
            },
            child: Icon(Icons.more_vert),
          ),
        ),
        body: Consumer<MyPostDetailViewModel>(builder: (context, myPController, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 14,bottom: 24),
            child: myPController.myPostDetailModel == null
                ? SizedBox.shrink()
                : RefreshIndicator(
                    backgroundColor: AppColors.whiteColor,
                    color: AppColors.primaryColor,
                    onRefresh: () async {
                      await myPController.getMyProjectDetail(context, id: widget.id);
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
                                  rating: myPController.myPostDetailModel?.data?.metrics?.averageRating.toString() ?? "0.0",
                                  ratingOnTap: () {
                                    Navigator.pushNamed(context, RoutesName.rating);
                                  },
                                  isMyPost: true,
                                  onProjectDetail: () {
                                  },
                                  onFollow: () {},
                                  posts: SlicerMethod(context, myPController),
                                  location: myPController.myPostDetailModel!.data!.profile!.city ?? "",
                                  caption: myPController.myPostDetailModel!.data!.title ?? "",
                                  profileImage: AppUrl.baseUrl + myPController.myPostDetailModel!.data!.profile!.mainImage.toString(),
                                  profileName: myPController.myPostDetailModel!.data!.profile!.username.toString(),
                                  description: myPController.myPostDetailModel?.data?.description ?? "",
                                  occupation: myPController.myPostDetailModel!.data!.profile!.occupations![0].occupation.toString(),
                                  isLike: myPController.myPostDetailModel!.data!.isLiked,
                                  publish: Utils().formatDate(myPController.myPostDetailModel!.data!.postedOn.toString()),
                                  isSave: myPController.postDetail.isSave,
                                  showContent: myPController.show,
                                  commentCount: myPController.myPostDetailModel!.data!.metrics!.commentCount.toString(),
                                  likeCount: myPController.myPostDetailModel!.data!.metrics!.likeCount.toString(),
                                  viewCount: myPController.myPostDetailModel!.data!.metrics!.viewCount.toString(),
                                  onTapHide: () {
                                    myPController.hideData();
                                  },
                                  onTapShow: () {
                                    myPController.showData();
                                  },
                                  tools: ToolsMethod(myPController),
                                  tags: TagsMethod(myPController),
                                  category: CategoryMethod(myPController),
                                  onRate: () {
                                    RatingSheet(context);
                                  },
                                  onLike: () {
                                    myPController.postLike(context, id: myPController.myPostDetailModel!.data!.id!.toString() ?? "");
                                  },
                                  onSave: () {
                                    myPController.postDetail.isSave = !myPController.postDetail.isSave!;
                                    myPController.notifyListeners();
                                  },
                                ),
                                // Comments Section
                                myPController.myPostDetailModel!.data!.comments!.isEmpty
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
                                                      "id": myPController.myPostDetailModel?.data?.id.toString(),
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
                                            Consumer<MyPostDetailViewModel>(
                                              builder: (context, value, child) {
                                                return ListView.separated(
                                                  separatorBuilder: (context, index) {
                                                    return SizedBox(height: MediaQuery.of(context).size.height * 16 / 812);
                                                  },
                                                  shrinkWrap: true,
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: value.myPostDetailModel!.data!.comments!.length,
                                                  itemBuilder: (context, index) {
                                                    return CommentSectionWidget(index, value);
                                                  },
                                                );
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
                              fillColor: myPController.focusComment.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                              focusColor: Colors.transparent,
                              hint: "Type your comment...",
                              hintFontSize: 14,
                              enableBorderColor: Colors.transparent,
                              textInputType: TextInputType.visiblePassword,
                              txtController: myPController.commentTextEditingController,
                              textInputAction: TextInputAction.next,
                              node: myPController.focusComment,
                              onTap: () {},
                              borderRadius: 70,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  myPController.postComment(context, id: myPController.myPostDetailModel!.data!.id.toString()).then(
                                    (value) {
                                      myPController.getMyProjectDetail(context, id: myPController.myPostDetailModel!.data!.id.toString());
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
          );
        }),
      ),
    );
  }

  void deleteSheet(BuildContext context, MyPostDetailViewModel controller) {
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
                text: "Are you sure you want to delete this project?",
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
                      controller.ProjectDelete(
                        context,
                        id: controller.myPostDetailModel?.data?.id.toString(),
                      );
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

  Widget CommentSectionWidget(int index, MyPostDetailViewModel postDetail) {
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
                    ClipRRect(borderRadius: BorderRadius.circular(50), child: Utils().customCachedNetworkImage(height: 46, width: 46, shape: BoxShape.circle, url: AppUrl.baseUrl + postDetail.myPostDetailModel!.data!.comments![index].commentedBy!.mainImage.toString())),
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
                                text: postDetail.myPostDetailModel!.data!.comments![index].commentedBy!.username.toString(), //"Rayna Donin",
                                fontSize: 16,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomTextWidget(
                                text: getTimeAgo(commentDateTime: DateTime.parse(postDetail.myPostDetailModel!.data!.comments![index].commentedAt.toString())),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey3,
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          CustomTextWidget(
                            text: postDetail.myPostDetailModel!.data!.comments![index].comment!.toString(), //"Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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
                  itemPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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

  Widget SlicerMethod(BuildContext context, MyPostDetailViewModel cont) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 375 / 375,
          height: MediaQuery.of(context).size.height * 365 / 812,
          child: PageView.builder(
            controller: cont.pageController,
            itemCount: cont.myPostDetailModel?.data?.media?.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: (){
                  print("media clicked");
                },
                child: Utils().customCachedNetworkImage(height: 29, width: MediaQuery.of(context).size.width, shape: BoxShape.rectangle, url: AppUrl.baseUrl + cont.myPostDetailModel!.data!.media![i].media.toString()),
              );

            },
            onPageChanged: (index) {
              cont.currentPage = index;
              cont.notifyListeners();
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
                cont.myPostDetailModel!.data!.media!.length,
                (index) => Container(
                  margin: EdgeInsets.all(2),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cont.currentPage == index ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
        cont.myPostDetailModel!.data!.media!.length == 0
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
                    text: "${(cont.currentPage + 1).toString()}/${cont.myPostDetailModel!.data!.media!.length}",
                    fontSize: 12,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ],
    );
  }

  Widget CategoryMethod(MyPostDetailViewModel cc) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cc.myPostDetailModel!.data!.categories!
          .map(
            (categories) => Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.blackColor,
              ),
              child: CustomTextWidget(
                text: categories.categoryName,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget TagsMethod(MyPostDetailViewModel tc) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tc.myPostDetailModel!.data!.tags!
          .map(
            (tags) => Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.blackColor,
              ),
              child: CustomTextWidget(
                text: tags.tag,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          )
          .toList(),
    );
  }

  Wrap ToolsMethod(MyPostDetailViewModel cnt) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cnt.myPostDetailModel!.data!.tools!
          .map(
            (tools) => Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.blackColor,
              ),
              child: CustomTextWidget(
                text: tools.toolName,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.whiteColor,
              ),
            ),
          )
          .toList(),
    );
  }

  void showCustomBottomSheet(BuildContext context, MyPostDetailViewModel controller) {
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
                  Navigator.pushNamed(
                    context,
                    RoutesName.editProject,
                    arguments: {
                      "id": null,
                      "myPostDetailModel": controller.myPostDetailModel,
                    },
                  ).then((v){

                    if(v !=null){
                      controller.getMyProjectDetail(NavigationService.navigatorKey.currentState!.context, id: widget.id);
                    }

                  });
                },
                child: Row(
                  children: [
                    SvgIconComponent(
                      icon: "edit_purple.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 15),
                    CustomTextWidget(
                      text: "Edit",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                  deleteSheet(context, controller);
                },
                child: Row(
                  children: [
                    SvgIconComponent(
                      icon: "delete_purple.svg",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(width: 15),
                    CustomTextWidget(
                      text: "Delete",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
