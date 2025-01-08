// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/auth_view_model/create_profile_view_model.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';

class CityView extends StatelessWidget {
  CityView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<CreateProfileViewModel>(context);
    return MainScaffold(
      appBar: CustomAppBar(
        title: "Select City",
        leading: true,
        backButtonColor: AppColors.blackColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: CustomButton(
          onTap: () {
            controller.updateCity(controller.selectedCity!);
            Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Padding(
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
                    return "";
                  },
                  cursorColor: AppColors.primaryColor,
                  fillColor: controller.focusSearch.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                  focusColor: Colors.transparent,
                  hint: "Search...",
                  hintFontSize: 14,
                  enableBorderColor: Colors.transparent,
                  textInputType: TextInputType.visiblePassword,
                  txtController: controller.searchTextEditingController,
                  textInputAction: TextInputAction.next,
                  node: controller.focusSearch,
                  onTap: () {},
                  borderRadius: 70,
                  prefixIcon: SvgIconComponent(
                    icon: "search_icon.svg",
                    color: AppColors.grey3,
                  ),
                  suffixIcon: SvgIconComponent(
                    icon: "close_circle.svg",
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(height: MediaQuery.of(context).size.height * 34 / 812);
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.cities.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.selectCity(controller.cities[index]);
                      print('Selected country ID: ${controller.selectedCityId}');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: controller.cities[index].name,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        SvgIconComponent(
                            icon: controller.selectedCityId == controller.cities[index].id ? "selected_radio.svg" : "unselected_radio.svg"),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
