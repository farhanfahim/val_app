// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/app_urls.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/configs/utils.dart';
import 'package:val_app/view_model/profiles/my_profile_view_model.dart';

import '../../configs/app_constants.dart';
import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/components/custom_text_widget.dart';
import '../../configs/components/svg_icons_component.dart';
import '../../configs/validator/app_validator.dart';
import '../../model/signup_skill_model.dart';
import '../../view_model/auth_view_model/create_profile_view_model.dart';

class CreateProfileView extends StatefulWidget {
  bool isEdit;

  CreateProfileView({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeControllerValues();
  }

  void _initializeControllerValues() {
    var controller =
        Provider.of<CreateProfileViewModel>(context, listen: false);
    var profiledata =
        Provider.of<MyProfileViewModel>(context, listen: false).myProfile;

    if (widget.isEdit && profiledata != null) {
      controller.myProfile = profiledata;
      controller.usernameTextEditingController.text =
          profiledata.data!.valProfile!.username.toString();
      controller.occupationTextEditingController.text =
          profiledata.data!.occupations![0].occupations.toString();
      controller.aboutTextEditingController.text =
          profiledata.data!.valProfile!.about.toString();
      controller.skillsTextEditingController.text =
          profiledata.data!.skills!.isEmpty
              ? ""
              : profiledata.data!.skills![0].tool.toString();
      controller.selectedFileEdit =
          profiledata.data!.valProfile!.mainImage.toString();
      controller.selectedBackgroundFileEdit =
          profiledata.data!.valProfile!.coverImage.toString();
      controller.cityValue = profiledata.data!.valProfile!.city.toString();
      controller.countryValue =
          profiledata.data!.valProfile!.country.toString();
      controller.stateValue = profiledata.data!.valProfile!.state.toString();
      controller.selectedOccupationId =
          profiledata.data!.occupations![0].id.toString();
      controller.selectedSignupSkillList.clear();

      for (var skill in profiledata.data!.skills!) {
        controller.selectedSignupSkillList.add(
          SignupSkillsData(
            id: skill.id,
            tool: skill.tool,
            iCategory: null,
          ),
        );
      }
      //controller.getMyProfile(context);
    }
    // controller.notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileViewModel>(
        builder: (context, controller, child) {
      return MainScaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CustomAppBar(
          title: widget.isEdit == false ? "Create Profile" : "Edit Profile",
          leading: widget.isEdit == false ? false : true,
          bgColor: Colors.transparent,
          onLeadingPress: (){
            controller.clearData();
            Navigator.pop(context);
          },
          backButtonColor: AppColors.blackColor,
        ),
        body: WillPopScope(
          onWillPop: ()async{
            controller.clearData();
            Navigator.pop(context);
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 210 / 812),
                      Align(
                        alignment: Alignment.topCenter,
                        child: widget.isEdit
                            ? controller.selectedBackgroundFile == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Utils().customCachedNetworkImage(
                                      shape: BoxShape.rectangle,
                                      width: MediaQuery.of(context).size.width *
                                          327 /
                                          375,
                                      height: MediaQuery.of(context).size.height *
                                          130 /
                                          812,
                                      url: AppUrl.baseUrl +
                                          controller.selectedBackgroundFileEdit
                                              .toString(),
                                    ))
                                : controller.selectedBackgroundFile != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image(
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  327 /
                                                  375,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  130 /
                                                  812,
                                          image: FileImage(File(controller
                                              .selectedBackgroundFile!.path)),
                                        ))
                                    : SvgIconComponent(
                                        icon: "background.svg",
                                        width: MediaQuery.of(context).size.width *
                                            327 /
                                            375,
                                      )
                            : controller.selectedBackgroundFile != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          327 /
                                          375,
                                      height: MediaQuery.of(context).size.height *
                                          130 /
                                          812,
                                      image: FileImage(File(controller
                                          .selectedBackgroundFile!.path)),
                                    ))
                                : SvgIconComponent(
                                    icon: "background.svg",
                                    width: MediaQuery.of(context).size.width *
                                        327 /
                                        375,
                                  ),
                      ),
                      Positioned(
                        top: 10,
                        right: 35,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.backgroundPick();
                          },
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: widget.isEdit == false
                                  ? AppColors.primaryColor
                                  : AppColors.blackColor.withOpacity(.6),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: CustomTextWidget(
                              text: widget.isEdit == false
                                  ? "Upload Cover"
                                  : "Change Cover",
                              color: AppColors.whiteColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        child: Container(
                          height: 110,
                          width: 110,
                          child: badges.Badge(
                            position: badges.BadgePosition.bottomEnd(
                              end: 2,
                              bottom: -3,
                            ),
                            badgeContent: SvgIconComponent(
                              onTap: () {
                                print("object");

                                showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Select Image'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.photo, size: 20),
                                              const SizedBox(width: 20),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  controller.galleryPick();
                                                },
                                                child: Text(
                                                  'Gallery',
                                                  style: TextStyle(
                                                    color: AppColors.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.camera_alt,
                                                  size: 20),
                                              const SizedBox(width: 20),
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(context).pop();
                                                  controller.camPick();
                                                },
                                                child: Text(
                                                  'Camera',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: "pick_camera.svg",
                              width: 38,
                              height: 38,
                            ),
                            badgeStyle: const badges.BadgeStyle(
                              shape: badges.BadgeShape.circle,
                              badgeColor: Colors.transparent,
                              padding: EdgeInsets.all(1),
                            ),
                            child: controller.selectedFile == null
                                ? Container(
                                    width: 110,
                                    transformAlignment: Alignment.bottomCenter,
                                    height: 110,
                                    decoration: ShapeDecoration(
                                      color: Colors.transparent,
                                      image: controller.selectedFile != null
                                          ? DecorationImage(
                                              image: FileImage(File(
                                                  controller.selectedFile!.path)),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: AssetImage(
                                                  Utils.getIconImage(
                                                      "create_profile_icon.png")),
                                              fit: BoxFit.cover),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              color: Colors.transparent,
                                              width: 2)),
                                    ),
                                    child: widget.isEdit
                                        ? Utils().customCachedNetworkImage(
                                            shape: BoxShape.circle,
                                            width: 110,
                                            height: 110,
                                            url: AppUrl.baseUrl +
                                                controller.selectedFileEdit
                                                    .toString())
                                        : controller.selectedFile == null
                                            ? const Center(
                                                child: SvgIconComponent(
                                                    icon:
                                                        "create_profile_icon.svg"))
                                            : null,
                                  )
                                : Container(
                                    width: 110,
                                    transformAlignment: Alignment.bottomCenter,
                                    height: 110,
                                    decoration: ShapeDecoration(
                                      color: Colors.transparent,
                                      image: controller.selectedFile != null
                                          ? DecorationImage(
                                              image: FileImage(File(
                                                  controller.selectedFile!.path)),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: AssetImage(
                                                  Utils.getIconImage(
                                                      "create_profile_icon.png")),
                                              fit: BoxFit.cover),
                                      shape: CircleBorder(
                                          side: BorderSide(
                                              color: Colors.transparent,
                                              width: 2)),
                                    ),
                                    child: controller.selectedFile == null
                                        ? const Center(
                                            child: SvgIconComponent(
                                                icon: "create_profile_icon.svg"))
                                        : null,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 10 / 812,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Form(
                          key: controller.createProfileFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: "User Name",
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 6 / 812,
                              ),
                              CustomTextField(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                maxLines: 1,
                                maxLength: 24,
                                cursorColor: AppColors.primaryColor,
                                fillColor: controller.focusUsername.hasFocus
                                    ? AppColors.whiteColor
                                    : AppColors.whiteColor,
                                focusColor: AppColors.borderColor.withOpacity(.4),
                                hint: "Username",
                                hintFontSize: 16,
                                inputFormat: [
                                  FilteringTextInputFormatter.deny(RegExp(r"\s")), // Deny spaces
                                ],
                                textInputType: TextInputType.visiblePassword,
                                txtController:
                                    controller.usernameTextEditingController,
                                validatorFtn: (v){
                                  if(v.isEmpty){
                                    return Constants.usernameEmptyMsg;
                                  }else if(!RegExp(Constants.regExpUserName).hasMatch(v)){
                                    return Constants.usernameRegisMsg;
                                  }else{
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                node: controller.focusUsername,
                                onTap: () {},
                                borderRadius: 41,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              CustomTextWidget(
                                text: "Select Country",
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 6 / 812,
                              ),
                              widget.isEdit
                                  ? CSCPicker(
                                      layout: Layout.vertical,
                                      key: _cscPickerKey,
                                      currentCountry:
                                          controller.countryValue ?? '',
                                      currentState: controller.stateValue ?? '',
                                      currentCity: controller.cityValue ?? '',

                                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                      showStates: true,

                                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                                      showCities: true,

                                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                      flagState: CountryFlag.DISABLE,

                                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                      dropdownDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1)),

                                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                      disabledDropdownDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.grey.shade300,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1)),

                                      ///placeholders for dropdown search field
                                      countrySearchPlaceholder: "Country",
                                      stateSearchPlaceholder: "State",
                                      citySearchPlaceholder: controller.cityValue,

                                      ///labels for dropdown
                                      countryDropdownLabel: "*Country",
                                      stateDropdownLabel: "*State",
                                      cityDropdownLabel: "*City",

                                      ///selected item style [OPTIONAL PARAMETER]
                                      selectedItemStyle: TextStyle(
                                          color: Colors.black, fontSize: 14),

                                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                      dropdownHeadingStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),

                                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                      dropdownItemStyle: TextStyle(
                                          color: Colors.black, fontSize: 14),

                                      ///Dialog box radius [OPTIONAL PARAMETER]
                                      dropdownDialogRadius: 20.0,

                                      ///Search bar radius [OPTIONAL PARAMETER]
                                      searchBarRadius: 10.0,

                                      ///triggers once country selected in dropdown
                                      onCountryChanged: (String? value) =>
                                          controller.onCountryChanged(value),

                                      ///triggers once state selected in dropdown
                                      onStateChanged: (String? value) =>
                                          controller.onStateChanged(value),

                                      ///triggers once city selected in dropdown
                                      onCityChanged: (String? value) =>
                                          controller.onCityChanged(value),
                                    )
                                  : CSCPicker(
                                      layout: Layout.vertical,
                                      key: _cscPickerKey,

                                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                                      showStates: true,

                                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                                      showCities: true,

                                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                                      flagState: CountryFlag.DISABLE,

                                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                      dropdownDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1)),

                                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                      disabledDropdownDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.grey.shade300,
                                          border: Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1)),

                                      ///placeholders for dropdown search field
                                      countrySearchPlaceholder: "Country",
                                      stateSearchPlaceholder: "State",
                                      citySearchPlaceholder: controller.cityValue,

                                      ///labels for dropdown
                                      countryDropdownLabel: "*Country",
                                      stateDropdownLabel: "*State",
                                      cityDropdownLabel: "*City",

                                      ///selected item style [OPTIONAL PARAMETER]
                                      selectedItemStyle: TextStyle(
                                          color: Colors.black, fontSize: 14),

                                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                                      dropdownHeadingStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),

                                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                                      dropdownItemStyle: TextStyle(
                                          color: Colors.black, fontSize: 14),

                                      ///Dialog box radius [OPTIONAL PARAMETER]
                                      dropdownDialogRadius: 20.0,

                                      ///Search bar radius [OPTIONAL PARAMETER]
                                      searchBarRadius: 10.0,

                                      ///triggers once country selected in dropdown
                                      onCountryChanged: (String? value) =>
                                          controller.onCountryChanged(value),

                                      ///triggers once state selected in dropdown
                                      onStateChanged: (String? value) =>
                                          controller.onStateChanged(value),

                                      ///triggers once city selected in dropdown
                                      onCityChanged: (String? value) =>
                                          controller.onCityChanged(value),
                                    ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              CustomTextWidget(
                                text: "Select Occupation",
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 6 / 812,
                              ),
                              CustomTextField(
                                readOnly: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                maxLines: 1,
                                cursorColor: AppColors.primaryColor,
                                fillColor: controller.focusOccupation.hasFocus
                                    ? AppColors.whiteColor
                                    : AppColors.whiteColor,
                                focusColor: AppColors.borderColor.withOpacity(.4),
                                hint: "",
                                hintFontSize: 16,
                                textInputType: TextInputType.visiblePassword,
                                txtController:
                                    controller.occupationTextEditingController,
                                validatorFtn: AppValidator.required,
                                textInputAction: TextInputAction.next,
                                node: controller.focusOccupation,
                                onTap: () {
                                  controller.searchTextEditingController.text  = "";
                                  Navigator.pushNamed(
                                      context, RoutesName.occupation);

                                },
                                borderRadius: 41,
                                suffixIcon: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: SvgIconComponent(
                                        icon: "right_purple.svg")),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              CustomTextWidget(
                                text: "Select Skills",
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 6 / 812,
                              ),
                              CustomTextField(
                                readOnly: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                maxLines: 1,
                                cursorColor: AppColors.primaryColor,
                                fillColor: controller.focusSkills.hasFocus
                                    ? AppColors.whiteColor
                                    : AppColors.whiteColor,
                                focusColor: AppColors.borderColor.withOpacity(.4),
                                hint: "",
                                textFieldColor: Colors.transparent,
                                hintFontSize: 16,
                                textInputType: TextInputType.visiblePassword,
                                txtController:
                                    controller.skillsTextEditingController,
                                validatorFtn: AppValidator.required,
                                textInputAction: TextInputAction.next,
                                node: controller.focusSkills,
                                onTap: () {
                                  if (controller.selectedOccupationId.isEmpty ||
                                      controller
                                          .occupationTextEditingController.text
                                          .toString()
                                          .isEmpty) {
                                    Utils.toastMessage(
                                        "Select an occupation first, then choose skills");
                                  } else {
                                    Navigator.pushNamed(context, RoutesName.skill,
                                        arguments: {'isEdit': widget.isEdit});
                                  }
                                },
                                borderRadius: 41,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child:
                                      SvgIconComponent(icon: "right_purple.svg"),
                                ),
                              ),
                              controller.selectedSignupSkillList.isNotEmpty
                                  ? SizedBox(
                                      height: MediaQuery.of(context).size.height *
                                          10 /
                                          812,
                                    )
                                  : SizedBox.shrink(),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.selectedSignupSkillList
                                    .map(
                                      (skills) => GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          print("object");
                                          // Navigator.pushNamed(
                                          //     context, RoutesName.skill, );
                                          Navigator.pushNamed(
                                              context, RoutesName.skill,
                                              arguments: {
                                                'isEdit': widget.isEdit
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: AppColors.primaryColor
                                                .withOpacity(0.1),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 6, bottom: 6, left: 12),
                                                child: CustomTextWidget(
                                                  text: skills.tool.toString(),
                                                  color: AppColors.primaryColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                onTap: () {
                                                  controller
                                                      .removeSignupSkills(skills);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: SvgIconComponent(
                                                    icon: "white_circle.svg",
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                              CustomTextWidget(
                                text: "About",
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 6 / 812,
                              ),
                              CustomTextField(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                inputFormat: [
                                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9,. ]')), // Allow only letters and numbers
                                ],
                                maxLines: 5,
                                minLines: 5,
                                maxLength: 255,
                                showMaxLength: true,
                                cursorColor: AppColors.primaryColor,
                                fillColor: controller.focusAbout.hasFocus
                                    ? AppColors.whiteColor
                                    : AppColors.whiteColor,
                                focusColor: AppColors.borderColor.withOpacity(.4),
                                hint: "",
                                hintFontSize: 16,
                                textInputType: TextInputType.visiblePassword,
                                txtController:
                                    controller.aboutTextEditingController,
                                // validatorFtn: AppValidator.required,
                                textInputAction: TextInputAction.done,
                                node: controller.focusAbout,
                                onTap: () {},
                                borderRadius: 12,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 20 / 812,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 20 / 812,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24,24,24,34),
          child: CustomButton(
            onTap: () async {
              if (widget.isEdit) {
                await controller.EditProfilePost(context);
              } else {
                await controller.CreateProfilePost(context);
              }
            },
            radius: 26,
            height: MediaQuery.of(context).size.height * 49 / 812,
            fontWeight: FontWeight.w600,
            bgColor: AppColors.primaryColor,
            fontColor: AppColors.whiteColor,
            fontSize: 15,
            title: widget.isEdit == false ? "Continue" : "Save Changes",
          ),
        ),
      );
    });
  }
}
