import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/profiles/my_profile_view_model.dart';
import '../configs/color/colors.dart';
import '../configs/components/custom_appbar.dart';
import '../configs/components/custom_text_widget.dart';
import '../configs/components/main_scaffold.dart';

class LikesView extends StatelessWidget {
  LikesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _cp = Provider.of<MyProfileViewModel>(context);
    return MainScaffold(
      appBar: CustomAppBar(
        title: "Likes",
        leading: true,
        backButtonColor: AppColors.blackColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // SizedBox(height: 10),
                Divider(color: AppColors.grey2.withOpacity(.3)),
                SizedBox(height: 10),
                ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: MediaQuery.of(context).size.height * 20 / 812);
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _cp.likesList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _cp.likesSelection(_cp.likesList[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    Utils.getCommonImage(_cp.likesList[index].img.toString()),
                                    height: 46,
                                    width: 46,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Flexible(
                                  child: CustomTextWidget(
                                    text: _cp.likesList[index].name,
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
                            bgColor: _cp.liked.contains(_cp.likesList[index]) ? AppColors.primaryColor : null,
                            borderColor: _cp.liked.contains(_cp.likesList[index]) ? AppColors.primaryColor : AppColors.primaryColor,
                            borderWidth: _cp.liked.contains(_cp.likesList[index]) ? 2 : null,
                            title: _cp.liked.contains(_cp.likesList[index]) ? "Following" : "Follow",
                            fontSize: 12,
                            fontColor: _cp.liked.contains(_cp.likesList[index]) ? AppColors.whiteColor : AppColors.primaryColor,
                          ),
                        ],
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
