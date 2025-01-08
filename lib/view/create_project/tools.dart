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

class ToolsView extends StatelessWidget {
  ToolsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _tp = Provider.of<CreateProjectViewModel>(context);
    return MainScaffold(
      appBar: CustomAppBar(
        title: "Select Tools",
        leading: true,
        onLeadingPress: (){
          _tp.searchTextEditingController.text = "";
          _tp.filterToolsItems("");
          Navigator.pop(context);
        },
        backButtonColor: AppColors.blackColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onTap:(){
            if(_tp.selectedTools.isNotEmpty){
              _tp.searchTextEditingController.text = "";
              _tp.filterToolsItems("");
              Navigator.pop(context);
            }else{
              if(_tp.filteredToolsList.isNotEmpty){
                Utils.toastMessage('Please Select Tool');
              }else{
                _tp.searchTextEditingController.text = "";
                _tp.filterToolsItems("");
                Navigator.pop(context);
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
            SizedBox(height: 20),
            Container(
              decoration: Utils.boxDecorationRounded,
              child: CustomTextField(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                maxLines: 1,
                onChangeFtn: (v) {
                  print(v!);
                  _tp.filterToolsItems(v);
                  return "";
                },
                cursorColor: AppColors.primaryColor,
                fillColor: _tp.focusSearch.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                focusColor: Colors.transparent,
                hint: "Search...",
                hintFontSize: 14,
                enableBorderColor: Colors.transparent,
                textInputType: TextInputType.visiblePassword,
                txtController: _tp.searchTextEditingController,
                textInputAction: TextInputAction.next,
                node: _tp.focusSearch,
                onTap: () {},
                borderRadius: 70,
                prefixIcon: SvgIconComponent(
                  icon: "search_icon.svg",
                  color: AppColors.grey3,
                ),
                suffixIcon: SvgIconComponent(
                  icon: "close_circle.svg",
                  onTap: (){
                    print("cleared");
                    _tp.searchTextEditingController.text = "";
                    _tp.filterToolsItems("");
                  },
                  height: 22,
                  width: 22,
                ),
              ),
            ),
            SizedBox(height: 32),
            _tp.filteredToolsList.isEmpty
                ? Expanded(child: Utils.noDataFoundMessage("No Tool found."))
                : Expanded(child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: MediaQuery.of(context).size.height * 34 / 812);
              },
              shrinkWrap: true,
              itemCount: _tp.filteredToolsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _tp.ToolsSelection(_tp.filteredToolsList[index],_tp.filteredToolsList[index].isSelected!);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: _tp.filteredToolsList[index].tool.toString(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      SvgIconComponent(icon: _tp.filteredToolsList[index].isSelected! ? "remember_me_green.svg" : "remember_me_not.svg"),
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
