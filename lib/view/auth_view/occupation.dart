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

class OccupationView extends StatefulWidget {
  OccupationView({
    Key? key,
  }) : super(key: key);

  @override
  State<OccupationView> createState() => _OccupationViewState();
}

class _OccupationViewState extends State<OccupationView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<CreateProfileViewModel>(context, listen: false)
            .getOccupations(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileViewModel>(builder: (context, _op, _) {
      return MainScaffold(
        appBar: CustomAppBar(
          title: "Select Occupation",
          leading: true,
          onLeadingPress: (){
           _op.onBackPress(context);
          },
          backButtonColor: AppColors.blackColor,
        ),
        bottomNavigationBar: WillPopScope(
          onWillPop: () async{
            _op.onBackPress(context);
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: CustomButton(
              onTap: () {
                final controller = Provider.of<CreateProfileViewModel>(context, listen: false);
                if(controller.filteredOccupationList.isNotEmpty) {
                  if (controller.selectedOccupationIndex != -1) {
                    controller.selectOccupation(
                        controller.filteredOccupationList[controller
                            .selectedOccupationIndex].occupations.toString(),
                        controller.filteredOccupationList[controller
                            .selectedOccupationIndex].id.toString());
                    controller.updateOccupation(controller.selectedOccupation!);
                    controller.getSignupSkills(context, false);
                  }else{
                    Utils.toastMessage('Please Select Occupation');
                  }
                }else{
                  controller.onBackPress(context);
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
        ),
        body: _op.occupationLoading == true
            ? Center(
                child: Utils().spinkit,
              )
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: Utils.boxDecorationRounded,
                    child: CustomTextField(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      maxLines: 1,
                      onChangeFtn: (v) {
                        print(v!);
                        _op.filterOccupation(v);
                        return "";
                      },
                      cursorColor: AppColors.primaryColor,
                      fillColor: _op.focusSearch.hasFocus
                          ? AppColors.whiteColor
                          : AppColors.whiteColor,
                      focusColor: Colors.transparent,
                      hint: "Search...",
                      hintFontSize: 14,
                      enableBorderColor: Colors.transparent,
                      textInputType: TextInputType.visiblePassword,
                      txtController: _op.searchTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: _op.focusSearch,
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
                          _op.searchTextEditingController.text = "";
                          _op.filterOccupation("");
                        },
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ), 
                  _op.filteredOccupationList.isNotEmpty?Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      shrinkWrap: true, 
                      itemCount: _op.filteredOccupationList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // _op.selectOccupation(_op.occupationList[index].occupations.toString(), _op.occupationList[index].id.toString());
                            _op.selectedOccupationIndex = index;
                            _op.selectOccupationNew(
                                _op.filteredOccupationList[index].occupations
                                    .toString(),
                                _op.filteredOccupationList[index].id.toString());
                            print(
                                'Selected Occupation ID: ${_op.filteredOccupationList[index].occupations.toString()}');
                            print(
                                'Selected Occupation ID: ${_op.selectedOccupationId}');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextWidget(
                                  text: _op.filteredOccupationList[index].occupations,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                SvgIconComponent(
                                    icon: _op.selectedOccupationId ==
                                            _op.filteredOccupationList[index].id
                                                .toString()
                                        ? "selected_radio.svg"
                                        : "unselected_radio.svg"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ):Expanded(child: Center(child: const Text("No Occupation Found"))),
                ], 
              ),
            ),
      );
    });
  }
}
