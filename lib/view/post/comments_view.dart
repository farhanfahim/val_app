// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/utils.dart';

import '../../configs/Global.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/post/comments_view_model.dart';

class CommentsView extends StatefulWidget {
  String id;
  CommentsView({Key? key, required this.id}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final CommentsViewModel controller = CommentsViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getComments(context, widget.id, isPullToRefresh: false);
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
          title: "Comments",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        body: Consumer<CommentsViewModel>(builder: (context, _cc, child) {
          return _cc.isLoading
              ? const SizedBox.shrink()
              : _cc.commentsList.isEmpty
                  ? Utils.noDataFoundMessage("No comments found.")
                  : RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.primaryColor,
                      onRefresh: () async {
                        await _cc.getComments(context, widget.id, isPullToRefresh: true);
                      },
                      child: GestureDetector(
                        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    SizedBox(height: 35),
                                    ListView.separated(
                                      separatorBuilder: (context, _) {
                                        return const SizedBox(height: 0);
                                      },
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: _cc.commentsList.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            CommentSectionWidget(index, controller),
                                          ],
                                        );
                                      },
                                    ),
                                    SizedBox(height: 35),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: Utils.boxDecorationRoundedBorder,
                                  child: CustomTextField(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    maxLines: 1,
                                    onChangeFtn: (v) {
                                      return "";
                                    },
                                    cursorColor: AppColors.primaryColor,
                                    fillColor: _cc.focusComment.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                                    focusColor: Colors.transparent,
                                    hint: "Type your comment...",
                                    hintFontSize: 14,
                                    enableBorderColor: Colors.transparent,
                                    textInputType: TextInputType.visiblePassword,
                                    txtController: _cc.commentTextEditingController,
                                    textInputAction: TextInputAction.next,
                                    node: _cc.focusComment,
                                    onTap: () {},
                                    borderRadius: 70,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (_cc.commentTextEditingController.text != "") {
                                          _cc.postComment(context, id: widget.id).then(
                                            (value) {
                                              _cc.getComments(context, widget.id, isPullToRefresh: true);
                                            },
                                          );
                                        }
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
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    );
        }),
      ),
    );
  }

  Widget CommentSectionWidget(int index, CommentsViewModel controller) {
    return Container(
      padding: EdgeInsets.only(bottom: 16, top: 16),
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
                    controller.commentsList[index].mainImage == null ? SizedBox.shrink() : ClipRRect(borderRadius: BorderRadius.circular(50), child: Utils().customCachedNetworkImage(height: 46, width: 46, shape: BoxShape.circle, url: AppUrl.baseUrl + controller.commentsList[index].mainImage.toString())),
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
                                text: controller.commentsList[index].username.toString(), //"Rayna Donin",
                                fontSize: 16,
                                maxLines: 1,
                                overFlow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                              ),
                              CustomTextWidget(
                                text: getTimeAgo(commentDateTime: DateTime.parse(controller.commentsList[index].commentedAt.toString())),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey3,
                              ),
                            ],
                          ),
                          SizedBox(height: 7),
                          CustomTextWidget(
                            text: controller.commentsList[index].comment!.toString(),
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
}
