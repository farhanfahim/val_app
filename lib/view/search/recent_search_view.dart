import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/utils.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../view_model/search/recent_search_view_model.dart';

class RecentSearchView extends StatefulWidget {
  const RecentSearchView({super.key});

  @override
  State<RecentSearchView> createState() => _RecentSearchViewState();
}

class _RecentSearchViewState extends State<RecentSearchView> {
  final RecentSearchViewModel cnt = RecentSearchViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getRecentSearches(context);
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
    return ChangeNotifierProvider.value(
      value: cnt,
      child: MainScaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(24),
          child: CustomButton(
            bgColor: AppColors.primaryColor,
            radius: 100,
            onTap: (){
              Navigator.pop(context,cnt.searchTextEditingController.text );
            },
            fontWeight: FontWeight.w700,
            fontSize: 14,
            fontColor: AppColors.whiteColor,
            title: "Search",
          ),
        ),
        appBar: CustomAppBar(
          leading: true,
          onLeadingPress: (){
            Navigator.pop(context,cnt.searchTextEditingController.text );
          },
          title: "Search",
        ),
        body: Consumer<RecentSearchViewModel>(
          builder: (context, sController, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: Utils.boxDecorationRounded,
                    child: CustomTextField(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      maxLines: 1,
                      onChangeFtn: (v) {
                        return "";
                      },
                      cursorColor: AppColors.primaryColor,
                      fillColor: sController.focusSearch.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: Colors.transparent,
                      hint: "Search...",
                      hintFontSize: 14,
                      enableBorderColor: Colors.transparent,
                      textInputType: TextInputType.visiblePassword,
                      txtController: sController.searchTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: sController.focusSearch,
                      onTap: () {},
                      borderRadius: 70,
                      prefixIcon: SvgIconComponent(
                        icon: "search_icon.svg",
                        color: AppColors.grey3,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: sController.recentSearches.isNotEmpty,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: "Recent searches",
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        GestureDetector(
                          onTap: (){
                            sController.clearAllRecentSearches(context);
                          },
                          child: CustomTextWidget(
                            text: "Clear All",
                            fontSize: 16,

                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  sController.recentSearches.isNotEmpty?Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: MediaQuery.of(context).size.height * 25 / 812);
                      },
                      shrinkWrap: true,
                      itemCount: sController.recentSearches.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap:(){
                                Navigator.pop(context,sController.recentSearches[index].searchTag);
                              },
                              child: CustomTextWidget(
                                text: sController.recentSearches[index].searchTag,
                                fontSize: 18,
                                color: AppColors.grey3,
                              ),
                            ),
                            SvgIconComponent(icon: "close_circle.svg",onTap: (){
                              sController.clearRecentSearches(context, index);
                            },),
                          ],
                        );
                      },
                    ),
                  )
                  :!sController.isLoading?Expanded(child: Utils.noDataFoundMessage("No search history found.")):SizedBox.shrink()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
