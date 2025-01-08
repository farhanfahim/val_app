import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/sharedPerfs.dart';
import 'package:val_app/view_model/my_account_view_model.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/utils.dart';
import '../../firestore/firestore_controller.dart';

class MyAccountView extends StatefulWidget {
  const MyAccountView({super.key});

  @override
  State<MyAccountView> createState() => _MyAccountViewState();
}

class _MyAccountViewState extends State<MyAccountView> {
  final MyAccountViewModel controller = MyAccountViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        controller.getMyProfile(context);
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
          title: "My Account",
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14, left: 24, right: 24),
          child: Column(
            children: [
              SizedBox(height: 10),
              Consumer<MyAccountViewModel>(builder: (context, provider, child) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.myProfileView).then((v){
                        provider.getMyProfile(context);
                      });
                    },
                    child: Consumer<MyAccountViewModel>(builder: (context, provider, child) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: AppColors.greyShadowColor.withOpacity(0.25), blurRadius: 15, offset: Offset(3, 10)),
                          ],
                        ),
                        child: provider.loader == true
                            ? CircularProgressIndicator()
                            : Row(
                                children: [
                                  provider.myProfile!.data!.valProfile!.mainImage != null
                                      ? Utils().customCachedNetworkImage(width: 70, height: 70, shape: BoxShape.circle, url: AppUrl.baseUrl + provider.myProfile!.data!.valProfile!.mainImage!.toString())
                                      : Image.asset(
                                          Utils.getIconImage("default_image.png"),
                                          height: 70,
                                          width: 70,
                                        ),
                                  SizedBox(width: 13),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          text: provider.myProfile?.data?.valProfile?.username ?? "---", // "Jakob Wilson ",
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          maxLines: 1,
                                          overFlow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: [
                                            SvgIconComponent(icon: "pin.svg"),
                                            const SizedBox(width: 4),
                                            CustomTextWidget(
                                              text: provider.myProfile?.data?.valProfile?.city ?? "", // "California, United States",
                                              color: AppColors.grey3,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SvgIconComponent(icon: "right_purple.svg", height: 20),
                                ],
                              ),
                      );
                    }),
                  );
                }
              ),
              SizedBox(height: 27),
              GoPremium(context, onTap: () {
                // Navigator.pushNamed(context, RoutesName.interest);
              }),
              SizedBox(height: 12),
              TileWidget(onTap: () {}, icon: "payment.svg", title: "Payment Method"),
              TileWidget(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.blockedUser);
                },
                icon: "block-user.svg",
                title: "Block Users",
              ),
              TileWidget(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.faq);
                },
                icon: "headphone.svg",
                title: "Help & FAQ’s",
              ),
              TileWidget(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.setting);
                },
                icon: "setting.svg",
                title: "Settings",
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 55 / 812),
              GestureDetector(
                onTap: () async {
                  logoutSheet(context,controller);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppColors.grey4.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: CustomTextWidget(
                      text: "Logout",
                      color: AppColors.grey3,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget TileWidget({void Function()? onTap, required String icon, required String title}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 23),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grey4.withOpacity(0.3), width: 1),
          ),
        ),
        child: Row(
          children: [
            SvgIconComponent(icon: icon),
            SizedBox(width: 13),
            CustomTextWidget(
              text: title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Spacer(),
            SvgIconComponent(icon: "right_purple.svg"),
          ],
        ),
      ),
    );
  }

  Widget GoPremium(BuildContext context, {void Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            stops: [0.1, 0.99],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF2F0267),
              Color(0xFFEF00A6),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Utils.getIconImage("gold_diamond.gif")),
            CustomTextWidget(
              text: "Go Premium",
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}

void logoutSheet(BuildContext context, MyAccountViewModel controller) {
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
              text: "Are you sure you want to logout?",
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
                    controller.logout(context);
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
