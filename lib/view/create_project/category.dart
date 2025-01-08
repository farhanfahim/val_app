import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:val_app/view_model/project/create_project_view_model.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/main_scaffold.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/utils.dart';

class CategoryView extends StatefulWidget {
  CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateProjectViewModel>(context, listen: false).getCategory(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _cp = Provider.of<CreateProjectViewModel>(context);
    return MainScaffold(
      appBar: CustomAppBar(
        title: "Select Categories",
        leading: true,
        onLeadingPress: (){
          _cp.searchTextEditingController.text = "";
          _cp.filterItems("");
          Navigator.pop(context);
        },
        backButtonColor: AppColors.blackColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onTap: (){
            if(_cp.filteredCategoriesList.isNotEmpty) {
              if (_cp.selectedCategories.isNotEmpty) {
                List<int> selectedCatIds = [];
                for(var item in _cp.selectedCategories){
                  selectedCatIds.add(item.id!);
                }
                var data = {
                  "categories":  selectedCatIds,
                };
                _cp.postCategory(context, jsonEncode(data));
              } else {
                Utils.toastMessage('Please Select Category');
              }
            }
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
      body: Padding(
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
                  _cp.filterItems(v);
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
              height: 32,
            ),

            Expanded(
              child:  Visibility(
                visible: !_cp.catLoader,
                child: _cp.filteredCategoriesList.isEmpty
                    ? Utils.noDataFoundMessage("No categories found.")
                    : ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: MediaQuery.of(context).size.height * 34 / 812);
                  },
                  shrinkWrap: true,
                  itemCount: _cp.filteredCategoriesList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _cp.CategoriesSelection(_cp.filteredCategoriesList[index]);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: _cp.filteredCategoriesList[index].category.toString(),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          SvgIconComponent(
                            icon: _cp.filteredCategoriesList[index].isSelected! ? "remember_me_green.svg" : "remember_me_not.svg",
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}
