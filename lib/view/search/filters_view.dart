// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/routes/routes_name.dart';
import '../../model/categories_model.dart';
import '../../model/filter_category_model.dart';
import '../../model/tools_model.dart';
import '../../view_model/search/filter_view_model.dart';

class FiltersView extends StatefulWidget {
  const FiltersView({super.key});

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  final FilterViewModel cnt = FilterViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        cnt.getFilterCategory(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cnt,
      child: MainScaffold(
        appBar: CustomAppBar(
          leading: true,
          title: "Filters",
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24.0,24,24,34),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    cnt.selectedCategories.clear();
                    cnt.selectedTools.clear();
                    cnt.saveFilter(context,true);
                    cnt.notifyListeners();
                  },
                  bgColor: Colors.transparent,
                  radius: 50,
                  title: "Reset",
                  height: 49,
                  borderColor: AppColors.grey3,
                  fontColor: AppColors.grey3,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    cnt.saveFilter(context,false);
                  },
                  radius: 50,
                  bgColor: AppColors.primaryColor,
                  title: "Apply",
                  fontColor: AppColors.whiteColor,
                  height: 49,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<FilterViewModel>(
          builder: (context, sController, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    CustomTextWidget(
                      text: "Category",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 6),
                    CustomTextField(
                      readOnly: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      maxLines: 1,
                      cursorColor: AppColors.primaryColor,
                      fillColor: sController.focusCategory.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: AppColors.borderColor.withOpacity(.4),
                      hint: "All",
                      hintFontSize: 16,
                      textInputType: TextInputType.visiblePassword,
                      txtController: sController.categoryTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: sController.focusCategory,
                      onTap: () async {
                        var selectedCategories = await Navigator.pushNamed(context, RoutesName.filterCategory, arguments: sController.selectedCategories);

                        if (selectedCategories != null) {
                          sController.updateSelectedCategories(selectedCategories as List<FilterCategoryData>);
                        }
                      },
                      borderRadius: 41,
                      suffixIcon: SvgIconComponent(icon: "right_purple.svg"),
                    ),
                    if (sController.selectedCategories.isNotEmpty) ...[
                      SizedBox(height: 10),
                      categoryChip(sController),
                    ],
                    SizedBox(height: 20),
                    CustomTextWidget(
                      text: "Tools",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: 6),
                    CustomTextField(
                      readOnly: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      maxLines: 1,
                      cursorColor: AppColors.primaryColor,
                      fillColor: sController.focusTools.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: AppColors.borderColor.withOpacity(.4),
                      hint: "All",
                      hintFontSize: 16,
                      textInputType: TextInputType.visiblePassword,
                      txtController: sController.toolsTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: sController.focusTools,
                      onTap: () async {

                        var selectedTools = await Navigator.pushNamed(context, RoutesName.filterTools, arguments: sController.tools);

                        if (selectedTools != null) {
                          sController.updateSelectedTools(selectedTools as List<CatTools>);
                        }else{
                          sController.updateSelectedTools([]);
                        }
                      },
                      borderRadius: 41,
                      suffixIcon: SvgIconComponent(icon: "right_purple.svg"),
                    ),
                    if (sController.selectedTools.isNotEmpty) ...[ 
                      SizedBox(height: 10),
                      toolsChip(sController),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget categoryChip(FilterViewModel sController) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: sController.selectedCategories.map((category) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6, bottom: 6, left: 12),
                child: CustomTextWidget(
                  text: category.category!,
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  sController.removeSelectedCategory(category);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgIconComponent(
                    icon: "white_circle.svg",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget toolsChip(FilterViewModel sController) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: sController.selectedTools.map((tool) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: AppColors.primaryColor.withOpacity(0.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6, bottom: 6, left: 12),
                child: CustomTextWidget(
                  text: tool.tool!,
                  color: AppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  sController.removeSelectedTools(tool);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgIconComponent(
                    icon: "white_circle.svg",
                    height: 25,
                    width: 25,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
