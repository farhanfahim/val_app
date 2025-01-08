import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:val_app/configs/color/colors.dart';
import 'package:val_app/configs/components/custom_appbar.dart';
import 'package:val_app/configs/components/custom_button_widget.dart';
import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/routes/routes_name.dart';
import 'package:val_app/view_model/project/create_project_view_model.dart';
import '../../configs/components/custom_text_field.dart';

class CreateProject extends StatelessWidget {
  const CreateProject({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<CreateProjectViewModel>(context);
    // Navigator.pop(context);
    return MainScaffold(
      appBar: CustomAppBar(
        leading: true,
        backButtonColor: AppColors.blackColor,
        title: "Add Project",
        onLeadingPress: () {
          if(controller.checkBeforeExit()){
            ContinueEditingSheet(context, controller);
          }else{
            Navigator.pop(context);
          }

        },
      ),
      bottomNavigationBar: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if(controller.checkBeforeExit()){
              ContinueEditingSheet(context, controller);
            }else{
              Navigator.pop(context);
            }
            return false;
          },
          child: Container(
            // height: 110,
            padding: EdgeInsets.only(left: 24, right: 24, top: 17, bottom: 15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              // borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyShadowColor.withOpacity(0.25),
                  blurRadius: 15,
                  offset: Offset(3, -10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: 50,
                    radius: 50,
                    bgColor: AppColors.primaryColor,
                    title: "Publish",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    onTap: () async {
                      await controller.CreateProjectPost(context, isDraft: false, isPosted: true);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 14, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Consumer<CreateProjectViewModel>(
                builder: (context, _spp, child) {
                  final selectedMediaFile = _spp.selectedMediaFile;
                  if (selectedMediaFile == null) {
                    return DottedBorder(
                      strokeWidth: 1,
                      dashPattern: [6],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 235 / 812,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(.1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  PopUpSheetPicker(context, controller);
                                },
                                child: Column(
                                  children: [
                                    SvgIconComponent(icon: "add_file.svg", height: 36, width: 36),
                                    SizedBox(height: 7),
                                    CustomTextWidget(
                                      text: "Upload Media",
                                      color: AppColors.primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 11),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  UserRequirementSheet(context);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppColors.grey3,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgIconComponent(icon: "info_2.svg", width: 16, height: 16),
                                      SizedBox(width: 5),
                                      CustomTextWidget(
                                        text: "Requirement Info ",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container(
                    height: MediaQuery.of(context).size.height * 219 / 812,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          _buildMediaWidget(selectedMediaFile.path, context),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Container(
                              width: 55,
                              height: 23,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: AppColors.blackColor.withOpacity(.6), borderRadius: BorderRadius.circular(30)),
                              child: CustomTextWidget(
                                text: "Cover",
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              controller.selectedMediaFile == null
                  ? SizedBox.shrink()
                  : Consumer<CreateProjectViewModel>(
                      builder: (context, _fp, child) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: 1,
                          ),
                          shrinkWrap: true,
                          itemCount: _fp.mediaFiles.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _fp.mediaFiles.length) {
                              return _fp.mediaFiles.length == -0
                                  ? SizedBox.shrink()
                                  : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        PopUpSheetPicker(context, controller);
                                      },
                                      child: Container(
                                        height: 80,
                                        width: 80,
                                        child: SvgIconComponent(icon: "plus_icon.svg"),
                                      ),
                                    );
                            }
                            final mediaFile = _fp.mediaFiles[index];
                            final isSelected = _fp.selectedMediaFile == mediaFile;
                            return Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.purple2 : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _fp.selectMedia(mediaFile);
                                    },
                                    child: Container(
                                      height: 85,
                                      width: 85,
                                      // padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: _buildMediaWidget(mediaFile.path, context),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: SvgIconComponent(
                                      icon: "close_circle.svg",
                                      onTap: () {
                                        _fp.removeMedia(mediaFile);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
              SizedBox(height: 23),
              Divider(color: AppColors.grey2.withOpacity(.3)),
              SizedBox(height: 15),
              CustomTextWidget(
                text: "Title",
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 6 / 812,
              ),
              CustomTextField(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                maxLines: 1,
                cursorColor: AppColors.primaryColor,
                fillColor: controller.focusTitle.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                focusColor: AppColors.borderColor.withOpacity(.4),
                hint: " ",
                maxLength: 100,
                hintFontSize: 16,
                textInputType: TextInputType.visiblePassword,
                txtController: controller.titleTextEditingController,
                // validatorFtn: AppValidator.us,
                textInputAction: TextInputAction.next,
                node: controller.focusTitle,
                onTap: () {},
                borderRadius: 41,
              ),
              SizedBox(height: 20),
              CustomTextWidget(
                text: "Description",
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 6 / 812,
              ),
              CustomTextField(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                txtController: controller.descriptionTextEditingController,
                cursorColor: AppColors.primaryColor,
                fillColor: controller.focusDescription.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                focusColor: AppColors.borderColor.withOpacity(.4),
                hint: "",
                inputFormat: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9,. ]')), // Allow only letters and numbers
                ],
                minLines: 10,
                maxLines: 10,
                maxLength: 500,
                showMaxLength: true,
                hintFontSize: 16,
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                node: controller.focusDescription,
                onTap: () {},
                borderRadius: 12,
              ),
              SizedBox(height: 20),
              CustomTextWidget(
                text: "Category",
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 6 / 812,
              ),
              controller.selectedCategories.isEmpty
                  ? SizedBox.shrink()
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.searchTextEditingController.text = "";
                        Navigator.pushNamed(context, RoutesName.categoryList);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(controller.selectedCategories.length == 1
                              ? 40
                              : controller.selectedCategories.length == 2
                                  ? 40
                                  : 12),
                          border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.selectedCategories
                                    .map(
                                      (categpry) => Container(
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
                                                text: categpry.category,
                                                color: AppColors.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                controller.removeCategories(context,categpry);
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
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: SvgIconComponent(icon: "right_purple.svg"),
                            ),
                          ],
                        ),
                      ),
                    ),
              controller.selectedCategories.isNotEmpty
                  ? SizedBox.shrink()
                  : CustomTextField(
                      readOnly: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      maxLines: 1,
                      cursorColor: AppColors.primaryColor,
                      fillColor: controller.focusCategory.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: AppColors.borderColor.withOpacity(.4),
                      hint: " ",
                      hintFontSize: 16,
                      textInputType: TextInputType.visiblePassword,
                      txtController: controller.categoryTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: controller.focusCategory,
                      onTap: () {
                        controller.searchTextEditingController.text = "";
                        Navigator.pushNamed(context, RoutesName.categoryList);

                      },
                      borderRadius: 41,
                      suffixIcon: SvgIconComponent(icon: "right_purple.svg"),
                    ),
              SizedBox(height: 20),
              CustomTextWidget(
                text: "Tools Used",
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 6 / 812,
              ),
              controller.selectedTools.isEmpty
                  ? SizedBox.shrink()
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        controller.searchTextEditingController.text = "";
                        Navigator.pushNamed(context, RoutesName.toolsList);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(controller.selectedTools.length == 1
                              ? 40
                              : controller.selectedTools.length == 2
                                  ? 40
                                  : 12),
                          border: Border.all(color: AppColors.borderColor.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: controller.selectedTools
                                    .map(
                                      (tools) => Container(
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
                                                text: tools.tool,
                                                color: AppColors.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                controller.removeTools(tools);
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
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: SvgIconComponent(icon: "right_purple.svg"),
                            ),
                          ],
                        ),
                      ),
                    ),
              controller.selectedTools.isNotEmpty
                  ? SizedBox.shrink()
                  : CustomTextField(
                      readOnly: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      maxLines: 1,
                      cursorColor: AppColors.primaryColor,
                      fillColor: controller.focusTools.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                      focusColor: AppColors.borderColor.withOpacity(.4),
                      hint: " ",
                      hintFontSize: 16,
                      textInputType: TextInputType.visiblePassword,
                      txtController: controller.toolsTextEditingController,
                      textInputAction: TextInputAction.next,
                      node: controller.focusTools,
                      onTap: () {
                        controller.searchTextEditingController.text = "";
                        Navigator.pushNamed(context, RoutesName.toolsList);
                      },
                      borderRadius: 41,
                      suffixIcon: SvgIconComponent(icon: "right_purple.svg"),
                    ),
              SizedBox(height: 20),
              CustomTextWidget(
                text: "Tags",
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 6 / 812,
              ),
              CustomTextField(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                maxLines: 3,
                maxLength: 100,
                cursorColor: AppColors.primaryColor,
                fillColor: controller.focusTags.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                focusColor: AppColors.borderColor.withOpacity(.4),
                hint: " ",
                onFieldSubmit: (v) {
                  controller.addTag(v);
                  controller.tagsTextEditingController.clear();
                },
                hintFontSize: 16,
                textInputType: TextInputType.visiblePassword,
                txtController: controller.tagsTextEditingController,
                textInputAction: TextInputAction.done,
                node: controller.focusTags,
                onTap: () {},
                borderRadius: 41,
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.fieldtags.map((tag) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.primaryColor.withOpacity(0.1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add a Flexible widget to allow text wrapping without overflow
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6, left: 12),
                            child: CustomTextWidget(
                              text: tag.name,
                              overFlow: TextOverflow.ellipsis,
                              maxLines:3, // Limit to 2 lines
                              color: AppColors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            controller.removeFieldTag(tag);
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
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> ContinueEditingSheet(BuildContext context, CreateProjectViewModel cont) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    SvgIconComponent(icon: "edit_purple.svg"),
                    SizedBox(width: 14),
                    CustomTextWidget(
                      text: "Continue editing",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Divider(color: AppColors.grey2.withOpacity(.3)),
              SizedBox(height: 22),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  cont.CreateProjectPost(context, isDraft: true, isPosted: false);
                },
                child: Row(
                  children: [
                    SvgIconComponent(icon: "folder.svg"),
                    SizedBox(width: 14),
                    CustomTextWidget(
                      text: "Save as draft",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
              Divider(color: AppColors.grey2.withOpacity(.3)),
              SizedBox(height: 22),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  cont.discardProject(context);
                },
                child: Row(
                  children: [
                    SvgIconComponent(icon: "delete_purple.svg"),
                    SizedBox(width: 14),
                    CustomTextWidget(
                      text: "Discard Post",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> UserRequirementSheet(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: "Minimum 1600px width recommended. \nMax 10MB each (20MB for videos)",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey3,
              ),
              SizedBox(height: 13),
              CustomTextWidget(
                text: "• High resolution images (png, jpg, gif)",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey3,
              ),
              SizedBox(height: 8),
              CustomTextWidget(
                text: "• Videos (mp4)",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey3,
              ),
              SizedBox(height: 8),
              CustomTextWidget(
                text: "• Animated gifs",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey3,
              ),
              SizedBox(height: 8),
              CustomTextWidget(
                text: "• Only upload media you own the rights to",
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.grey3,
              ),
              SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> PopUpSheetPicker(BuildContext context, CreateProjectViewModel controller) {
    return showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      context: context,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(24),
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromCamera(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt_outlined),
                    ),
                    const SizedBox(height: 10),
                    CustomTextWidget(
                      text: "Camera",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromGallery(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.perm_media),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      text: "Image",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 60),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context);
                  controller.pickVideoFromGallery(context);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.video_collection),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                      text: "Video",
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMediaWidget(String filePath, BuildContext context) {
    final fileExtension = filePath.split('.').last.toLowerCase();
    if (fileExtension == 'mp4') {
      return Container(
        child: Center(
          child: Icon(Icons.videocam, size: 50, color: Colors.white),
        ),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
      );
    } else {
      return Image.file(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        File(filePath),
        fit: BoxFit.cover,
      );
    }
  }
}
