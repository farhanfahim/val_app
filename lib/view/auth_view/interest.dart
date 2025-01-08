import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/routes/routes_name.dart';
import '../../view_model/auth_view_model/interest_view_model.dart';

class InterestView extends StatefulWidget {
  @override
  State<InterestView> createState() => _InterestViewState();
}

class _InterestViewState extends State<InterestView> {
  final InterestViewModel cnt = InterestViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getInterest(context, isPullToRefresh: false);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var _ip = Provider.of<InterestViewModel>(context);
    return ChangeNotifierProvider.value(
      value: cnt,
      child: Consumer<InterestViewModel>(builder: (ctx, _ip, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.whiteColor,
            forceMaterialTransparency: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    text: "Select your interest",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 6),
                  CustomTextWidget(
                    text: "Select more than 5",
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height * 110 / 812,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
                  },
                  child: Container(
                    height: 49,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: CustomTextWidget(
                        text: "Skip",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                CustomButton(
                  width: MediaQuery.of(context).size.width * 242 / 375,
                  height: 49,
                  bgColor: AppColors.primaryColor,
                  onTap: () {
                    if (_ip.selectedIntresetIds.length < 5) {
                      Utils.toastMessage("Please select more than 5.");
                    } else {
                      _ip.addIntreset(context);
                    }
                  },
                  fontColor: AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  title: "Continue",
                  radius: 40,
                ),
              ],
            ),
          ),
          body: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 18,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            itemCount: _ip.interestList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _ip.interestSelection(_ip.interestList[index].id!);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: _ip.isSelected(_ip.interestList[index].id!) ? AppColors.primaryColor : Colors.transparent, width: _ip.isSelected(_ip.interestList[index].id!) ? 2 : 0),
                            borderRadius: BorderRadius.circular(17),
                            image: DecorationImage(
                              image: NetworkImage(AppUrl.baseUrl + _ip.interestList[index].image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: _ip.isSelected(_ip.interestList[index].id!)
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8, right: 6),
                                    child: SvgIconComponent(icon: "selection_icon.svg"),
                                  ))
                              : Container()),
                    ),
                    SizedBox(height: 5),
                    CustomTextWidget(
                      text: _ip.interestList[index].name,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
