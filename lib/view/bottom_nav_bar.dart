// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view/home.dart';
import 'package:val_app/view/accounts/my_account.dart';
import 'package:val_app/view/saved_view.dart';
import 'package:val_app/view/search/search.dart';

import '../configs/app_urls.dart';
import '../configs/color/colors.dart';
import '../view_model/bottom_nav_view_model.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  final BottomNavBarViewModel controller = BottomNavBarViewModel();


  @override
  void initState() {
    super.initState();
    // Schedule the async method to run after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyProfile(context);
    });

  }

  @override
  Widget build(BuildContext context) {
    // var _bp = Provider.of<BottomNavBarViewModel>(context);
    // var loginViewModel = Provider.of<MyProfileViewModel>(context).singInData;

    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<BottomNavBarViewModel>(builder: (context, _bp, ch) {
        return Container(
          decoration: BoxDecoration(color: AppColors.whiteColor, gradient: AppColors.backgroundGradient),
          child: Scaffold(
            // key: _bp.scaffoldKey,
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: IndexedStack(index:BottomNavigationItem.values.indexOf(_bp.currentItem), children: list),//_buildScreen(_bp.currentItem),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 0),
            //   child: _buildScreen(_bp.currentItem),
            // ),
            bottomNavigationBar: WillPopScope(
              onWillPop: _bp.onWillPop,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: const Color(0xfff2f2f24).withOpacity(0.1), spreadRadius: 0, blurRadius: 20),
                  ],
                ),
                child: Theme(
                  data: ThemeData(splashColor: Colors.transparent),
                  child: BottomNavigationBar(
                    unselectedFontSize: 2,
                    showSelectedLabels: false,
                    unselectedItemColor: const Color(0xffdadada),
                    selectedFontSize: 2,
                    showUnselectedLabels: false,
                    backgroundColor: AppColors.whiteColor,
                    selectedItemColor: AppColors.primaryColor,
                    type: BottomNavigationBarType.fixed,
                    elevation: 10,
                    currentIndex: BottomNavigationItem.values.indexOf(_bp.currentItem),
                    onTap: (index) {
                      final item = BottomNavigationItem.values[index];
                      if (index == 2) {

                        Navigator.pushNamed(context, RoutesName.createProject);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          _bp.changeCurrentItem(BottomNavigationItem.values[0]);
                        });

                      } else {
                        _bp.changeCurrentItem(item);
                      }
                    },
                    items: [
                      BottomNavigationBarItem(
                        label: '',
                        icon: SvgPicture.asset(
                          "assets/images/icons/home_icon.svg",
                          height: 24,
                          width: 24,
                          color: _bp.currentItem == BottomNavigationItem.home ? AppColors.primaryColor : AppColors.blackColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '',
                        icon: SvgPicture.asset(
                          "assets/images/icons/search_icon.svg",
                          height: 24,
                          width: 24,
                          color: _bp.currentItem == BottomNavigationItem.search ? AppColors.primaryColor : AppColors.blackColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '',
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SvgPicture.asset(
                            "assets/images/icons/create_icon.svg",
                            height: 54,
                            width: 54,
                          ),
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '',
                        icon: SvgPicture.asset(
                          "assets/images/icons/save_icon.svg",
                          height: 24,
                          width: 24,
                          color: _bp.currentItem == BottomNavigationItem.saved ? AppColors.primaryColor : AppColors.blackColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        label: '',
                        icon:
                            // Utils().customCachedNetworkImage(
                            //     width: 20, height: 20, shape: BoxShape.circle, url: (AppUrl.baseUrl + loginViewModel!.data!.mainImage!).toString()),
                        _bp.myProfile != null?Utils().customCachedNetworkImage(placeholder:"default_image.png",width: 28, height: 28, shape: BoxShape.circle, url: (AppUrl.baseUrl + _bp.myProfile!.data!.valProfile!.mainImage.toString()))
                              :CircleAvatar(radius: 14.5, backgroundImage: AssetImage(Utils.getIconImage("default_image.png"),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  final list = [const HomeView(), const SearchView(),Container(), const SavedView(),const MyAccountView()];
}
