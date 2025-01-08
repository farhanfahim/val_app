// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/post_component.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/routes/routes_name.dart';
import '../../configs/utils.dart';
import '../../view_model/categories_detail_view_model.dart';

class CategoryDetailScreen extends StatefulWidget {
  String? id;
  String? title;
  CategoryDetailScreen({Key? key, required this.id, required this.title}) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final CategoriesDetailViewModel controller = CategoriesDetailViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getCategoriesById(context, id: widget.id!);
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
    // var controller = Provider.of<UserPostDetailViewModel>(context);
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          leading: true,
          title: widget.title ?? "",
        ),
        body: Consumer<CategoriesDetailViewModel>(builder: (context, _pp, child) {
          return _pp.categoriesLoader == true
              ? SizedBox.shrink()
              : _pp.categoriesProject!.data!.isEmpty
                  ? Utils.noDataFoundMessage("No projects found.")
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _pp.categoriesProject == null
                                ? SizedBox.shrink()
                                : ListView.separated(
                                    itemCount: (_pp.categoriesProject!.data ?? []).length,
                                    shrinkWrap: true,
                                    reverse: true,
                                    padding: EdgeInsets.symmetric(horizontal: 24),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return PostComponent(
                                        isMyPostDetail: false,
                                        key: UniqueKey(),
                                        onProjectDetail: () {
                                          Navigator.pushNamed(context, RoutesName.userPostDetail, arguments: {
                                            "id": _pp.categoriesProject!.data![index].projectId.toString(),
                                          });
                                          // controller.getUserPostDetail(context, id: _pp.categoriesProject!.data![index].projectId.toString());
                                          // _pp.getProjectViewCount(context, id: _pp.feeds!.data!.projects![index].projectId.toString());
                                          // Navigator.pushNamed(context, RoutesName.userPostDetail);
                                        },
                                        isFollow: _pp.categoriesProject!.data![index].isFollowed,
                                        onFollow: () {
                                          _pp.getFollowProfile(context, id: _pp.categoriesProject!.data![index].profile!.valProfileId.toString(), index: index);
                                          // _pp.posts[index].isFollow = !_pp.posts[index].isFollow;
                                          // _pp.notifyListeners();
                                        },
                                        posts: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width * 375 / 375,
                                              height: MediaQuery.of(context).size.height * 350 / 812,
                                              child: PageView.builder(
                                                controller: _pp.pageController,
                                                itemCount: _pp.categoriesProject!.data![index].mediaFiles!.length,
                                                itemBuilder: (context, i) {
                                                  return Utils().customCachedNetworkImage(height: 294, width: MediaQuery.of(context).size.width, shape: BoxShape.rectangle, url: _pp.categoriesProject!.data![index].mediaFiles![i].media!.toString().toUpperCase().contains("NULL") ? "" : AppUrl.baseUrl + _pp.categoriesProject!.data![index].mediaFiles![i].media!.toString());
                                                },
                                                onPageChanged: (index) {
                                                  _pp.currentPage = index;
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
                                                    _pp.categoriesProject!.data![index].mediaFiles!.length,
                                                    (ind) => Container(
                                                      margin: EdgeInsets.all(2),
                                                      width: 7,
                                                      height: 7,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: _pp.currentPage == ind ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        caption: _pp.categoriesProject?.data?[index].title.toString() ?? "",
                                        profileImage: _pp.categoriesProject!.data![index].profile!.mainImage.toString().toUpperCase().contains("NULL") ? "" : AppUrl.baseUrl + _pp.categoriesProject!.data![index].profile!.mainImage.toString(),
                                        profileName: _pp.categoriesProject?.data?[index].profile?.username.toString() ?? "",
                                        isLike: _pp.categoriesProject?.data?[index].isLiked,
                                        isSave: _pp.categoriesProject?.data?[index].isSaved,
                                        commentCount: _pp.categoriesProject?.data?[index].commentCount.toString() ?? "",
                                        viewCount: _pp.categoriesProject?.data?[index].viewCount.toString() ?? "",
                                        likecount: _pp.categoriesProject?.data?[index].likeCount.toString() ?? "",
                                        location: _pp.categoriesProject?.data?[index].profile?.city.toString() ?? "",
                                        postedDateTime: _pp.formatDateTime(_pp.categoriesProject!.data![index].postedOn.toString()),
                                        onRate: () {
                                          RatingSheet(context);
                                        },
                                        viewLiked: () {
                                          Navigator.pushNamed(context, RoutesName.likes);
                                        },
                                        onLike: () {
                                          _pp.getProjectLike(context, id: _pp.categoriesProject?.data?[index].projectId.toString());
                                        },
                                        onSave: () {
                                          _pp.getSaveProject(context, id: _pp.categoriesProject?.data?[index].projectId.toString());

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
                    );
        }),
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
}
