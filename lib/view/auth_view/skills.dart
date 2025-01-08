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

class SkillsView extends StatefulWidget {
  bool isEdit;

  SkillsView({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> {
  @override
  void initState() {
    if(widget.isEdit){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<CreateProfileViewModel>(context, listen: false).getSignupSkills(context, true);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var _sp = Provider.of<CreateProfileViewModel>(context);
    return Consumer<CreateProfileViewModel>(builder: (context, _sp, child) {
      return MainScaffold(
        appBar: CustomAppBar(
          title: "Select Skills",
          leading: true,
          onLeadingPress: (){
            _sp.filterSkills("");
            Navigator.pop(context);
        },
          backButtonColor: AppColors.blackColor,
        ),
        bottomNavigationBar: WillPopScope(
          onWillPop: () async{
            _sp.filterSkills("");
            Navigator.pop(context);
            return false;
          },child: Padding(
            padding: const EdgeInsets.all(24),
            child: CustomButton(
              onTap:(){
                if(_sp.selectedSignupSkillList.isNotEmpty){
                  _sp.filterSkills("");
                  Navigator.pop(context);
                }else{
                  if(_sp.filteredSkillsList.isNotEmpty){
                    Utils.toastMessage('Please Select Skill');
                  }else{
                    _sp.filterSkills("");
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
        ),
        body: _sp.skillLoading == true
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
                        _sp.filterSkills(v);
                        return "";
                      },
                      cursorColor: AppColors.primaryColor,
                      fillColor: _sp.focusSearch.hasFocus
                          ? AppColors.whiteColor
                          : AppColors.whiteColor,
                      focusColor: Colors.transparent,
                      hint: "Search...",
                      hintFontSize: 14,
                      enableBorderColor: Colors.transparent,
                      textInputType: TextInputType.visiblePassword,
                      txtController: _sp.searchTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: _sp.focusSearch,
                      onTap: () {},
                      borderRadius: 70,
                      prefixIcon: SvgIconComponent(
                        icon: "search_icon.svg",
                        color: AppColors.grey3,
                      ),
                      suffixIcon: SvgIconComponent(
                        icon: "close_circle.svg",
                        height: 22,
                        onTap: (){
                          _sp.searchTextEditingController.text = "";
                          _sp.filterSkills("");
                        },
                        width: 22,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  _sp.filteredSkillsList.isNotEmpty?Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      shrinkWrap: true,
                      itemCount: _sp.filteredSkillsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _sp.signupSkillsSelection(
                                _sp.filteredSkillsList[index]);
                            // print('Selected Skill ID: ${_sp.selectedSkills.firstWhere(
                            //   (element) => element == _sp.skillsList[index].id,
                            // )}');
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextWidget(
                                  text: _sp.filteredSkillsList[index].tool
                                      .toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                SvgIconComponent(
                                    icon: _sp.selectedSignupSkillList
                                            .contains(
                                                _sp.filteredSkillsList[index])
                                        ? "remember_me_green.svg"
                                        : "remember_me_not.svg"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ):Expanded(child: Center(child: const Text("No Skill Found"))),
                ],
              ),
            ),
      );
    });
  }
}
