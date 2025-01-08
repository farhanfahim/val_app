// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:val_app/configs/components/custom_text_widget.dart';
import 'package:val_app/configs/components/main_scaffold.dart';
import 'package:val_app/configs/components/svg_icons_component.dart';
import 'package:val_app/configs/validator/app_validator.dart';

import '../../configs/color/colors.dart';
import '../../configs/components/custom_appbar.dart';
import '../../configs/components/custom_button_widget.dart';
import '../../configs/components/custom_text_field.dart';
import '../../configs/utils.dart';
import '../../view_model/report/project_report_view_model.dart';

class ProjectReportView extends StatefulWidget {
  String id;
  ProjectReportView({Key? key, required this.id}) : super(key: key);

  @override
  State<ProjectReportView> createState() => _ProjectReportViewState();
}

class _ProjectReportViewState extends State<ProjectReportView> {
  final ProjectReportViewModel cnt = ProjectReportViewModel();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cnt,
      child: MainScaffold(
        appBar: CustomAppBar(
          title: "Report",
          leading: true,
          backButtonColor: AppColors.blackColor,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24),
          child: CustomButton(
            onTap: () {
              if (cnt.selectedReport == "Other") {
                if (cnt.projectReportFormKey.currentState!.validate()) {
                  cnt.reportProject(context, id: widget.id);
                }
              } else if (cnt.selectedReportId == null) {
                Utils.toastMessage("You need to select atleast 1 problem.");
              } else {
                cnt.reportProject(context, id: widget.id);
              }
            },
            radius: 26,
            height: MediaQuery.of(context).size.height * 49 / 812,
            fontWeight: FontWeight.w600,
            bgColor: AppColors.primaryColor,
            fontColor: AppColors.whiteColor,
            fontSize: 15,
            title: "Report",
          ),
        ),
        body: Consumer<ProjectReportViewModel>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              child: Form(
                key: controller.projectReportFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 22),
                      CustomTextWidget(
                        text: "Please select a problem",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 32),
                      ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: MediaQuery.of(context).size.height * 34 / 812);
                        },
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.reportList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              controller.selectReport(controller.reportList[index]);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextWidget(
                                  text: controller.reportList[index].name,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                SvgIconComponent(icon: controller.selectedReportId == controller.reportList[index].id ? "selected_radio.svg" : "unselected_radio.svg"),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 25),
                      controller.selectedReport == "Other"
                          ? CustomTextField(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              maxLines: 6,
                              minLines: 6,
                              cursorColor: AppColors.primaryColor,
                              fillColor: controller.focusReport.hasFocus ? AppColors.whiteColor : AppColors.whiteColor,
                              focusColor: AppColors.borderColor.withOpacity(.4),
                              hint: "Type your reason...",
                              hintFontSize: 16,
                              textInputType: TextInputType.visiblePassword,
                              validatorFtn: AppValidator.required,
                              txtController: controller.reportTextEditingController,
                              textInputAction: TextInputAction.next,
                              node: controller.focusReport,
                              onTap: () {},
                              borderRadius: 12,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
