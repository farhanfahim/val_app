import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/utils.dart';
import '../../model/filter_category_model.dart';
import '../../view_model/search/filter_category_view_model.dart';

class FilterCategoryView extends StatefulWidget {
  final List<FilterCategoryData> preSelectedCategories;
  FilterCategoryView({Key? key, required this.preSelectedCategories}) : super(key: key);

  @override
  State<FilterCategoryView> createState() => _FilterCategoryViewState();
}

class _FilterCategoryViewState extends State<FilterCategoryView> {
  final FilterCategoryViewModel controller = FilterCategoryViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFilterCategory(context, isPullToRefresh: false);
      controller.setPreSelectedCategories(widget.preSelectedCategories);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MainScaffold(
        appBar: CustomAppBar(
          title: "Select Categories",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            onTap: () {
              Navigator.pop(context, controller.getSelectedCategories(controller.commentsList));
            },
            radius: 26,
            height: MediaQuery.of(context).size.height * 49 / 812,
            fontWeight: FontWeight.w600,
            bgColor: AppColors.primaryColor,
            fontColor: AppColors.whiteColor,
            fontSize: 15,
            title: "Done",
          ),
        ),
        body: Consumer<FilterCategoryViewModel>(
          builder: (context, _cp, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: Utils.boxDecorationRounded,
                    child: CustomTextField(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      maxLines: 1,
                      onChangeFtn: (v) {
                        print(v!);
                        controller.filterItems(v);
                        return "";
                      },
                      cursorColor: AppColors.primaryColor,
                      fillColor: _cp.focusSearch.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: Colors.transparent,
                      hint: "Search...",
                      hintFontSize: 14,
                      enableBorderColor: Colors.transparent,
                      textInputType: TextInputType.visiblePassword,
                      txtController: _cp.searchTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: _cp.focusSearch,
                      onTap: () {},
                      borderRadius: 70,
                      prefixIcon: SvgIconComponent(
                        icon: "search_icon.svg",
                        color: AppColors.grey3,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                 Expanded(
                   child: _cp.isLoading
                       ? const SizedBox.shrink()
                       : _cp.filteredCommentsList.isEmpty
                       ? Utils.noDataFoundMessage("No categories found.")
                       : RefreshIndicator(
                     backgroundColor: AppColors.whiteColor,
                     color: AppColors.primaryColor,
                     onRefresh: () async {
                       await _cp.getFilterCategory(context, isPullToRefresh: true);
                     },
                     child: ListView.separated(
                       separatorBuilder: (context, _) {
                         return SizedBox(height: 10);
                       },
                       shrinkWrap: true,
                       padding: EdgeInsets.zero,
                       itemCount: _cp.filteredCommentsList.length,
                       itemBuilder: (context, index) {
                         return GestureDetector(
                           behavior: HitTestBehavior.opaque,
                           onTap: () {
                             _cp.toggleCategorySelection( _cp.filteredCommentsList[index]);
                           },
                           child: Container(
                             padding: EdgeInsets.symmetric(vertical: 15),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 CustomTextWidget(
                                   text: _cp.filteredCommentsList[index].category.toString(),
                                   fontSize: 16,
                                   fontWeight: FontWeight.w600,
                                 ),
                                 SvgIconComponent(
                                   icon:  _cp.filteredCommentsList[index].isSelected! ? "remember_me_green.svg" : "remember_me_not.svg",
                                 ),
                               ],
                             ),
                           ),
                         );
                       },
                     ),
                   ),
                 )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
