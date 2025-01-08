import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../view_model/accounts/blocked_user_view_model.dart';

class BlockedUserView extends StatefulWidget {
  BlockedUserView({Key? key}) : super(key: key);

  @override
  State<BlockedUserView> createState() => _BlockedUserViewState();
}

class _BlockedUserViewState extends State<BlockedUserView> {
  final BlockedUserViewModel controller = BlockedUserViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getBlockedUsers(context);

      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var _cp = Provider.of<BlockedUserViewModel>(context);
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          title: "Block Users",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        body: Consumer<BlockedUserViewModel>(builder: (context, _cp, child) {
          return _cp.isLoading
              ? Center(child: Utils().spinkit,)
              : _cp.blockedList.isEmpty
              ? Utils.noDataFoundMessage("No block user found.")
              : RefreshIndicator(
            backgroundColor: AppColors.whiteColor,
            color: AppColors.primaryColor,
            onRefresh: () async {
              await _cp.getBlockedUsers(context, isPullToRefresh: true);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24,),
                child: Column(
                  children: [
                    Divider(color: AppColors.grey2.withOpacity(.3)),
                    SizedBox(height: 20),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, cnt) {
                        return SizedBox(height: 18);
                      },
                      itemCount: _cp.blockedList.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return blockedWidget(_cp, index);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        })
      ),
    );
  }

  Widget blockedWidget(BlockedUserViewModel _cp, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Utils().customCachedNetworkImage(width: 46, height: 46, shape: BoxShape.circle, url: (AppUrl.baseUrl+_cp.blockedList[index].mainImage.toString())),

                ),
                SizedBox(width: 12),
                Flexible(
                  child: CustomTextWidget(
                    text: _cp.blockedList[index].username,
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
            onTap: () {
              showUnblockDialog(context, _cp, index);
            },
            radius: 40,
            width: 90,
            height: 35,
            fontWeight: FontWeight.w500,
            bgColor: null,
            borderColor: AppColors.grey3,
            title: "Unblock",
            fontSize: 12,
            fontColor: AppColors.grey3,
          ),
        ],
      ),
    );
  }

  void showUnblockDialog(BuildContext context, BlockedUserViewModel _cp, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                text: "Are you sure you want to unblock this user?",
                fontSize: 18,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 33),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      bgColor: Colors.transparent,
                      radius: 50,
                      title: "Cancel",
                      height: 40,
                      borderColor: AppColors.grey3,
                      fontColor: AppColors.grey3,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                        _cp.unBlockUser(context,_cp.blockedList[index].blockId!.toString());
                        _cp.blockedList.removeAt(index);
                      },
                      radius: 50,
                      bgColor: Colors.transparent,
                      title: "Unblock",
                      borderColor: AppColors.primaryColor,
                      fontColor: AppColors.primaryColor,
                      height: 40,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
