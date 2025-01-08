// ignore_for_file: must_call_super

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../Repository/my_account_api/account_http_api_repository.dart';
import '../../configs/utils.dart';
import '../../model/report_model.dart';

class ProjectReportViewModel extends ChangeNotifier {
  final projectReportFormKey = GlobalKey<FormState>();
  TextEditingController reportTextEditingController = TextEditingController();
  FocusNode focusReport = FocusNode();

  ReportViewModel() {
    focusReport.addListener(notifyListeners);
    reportTextEditingController.addListener(notifyListeners);
  }

  List<ReportModel> reportList = [
    ReportModel(id: 1, name: 'Inappropriate Content'),
    ReportModel(id: 2, name: 'Plagiarism'),
    ReportModel(id: 3, name: 'Spam'),
    ReportModel(id: 4, name: 'Misleading Information'),
    ReportModel(id: 5, name: 'Harassment or Abuse'),
    ReportModel(id: 6, name: 'Violation of Terms'),
    ReportModel(id: 7, name: 'Other'),
  ];
  int? selectedReportId;
  String? selectedReport;
  String? report;

  void selectReport(ReportModel report) {
    selectedReportId = report.id;
    selectedReport = report.name;
    notifyListeners();
  }

  Future<void> reportProject(BuildContext context, {String? id}) async {
    // Show loading dialog
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken}',
    };
    dynamic data = {
      "reported_about_project": id,
      "claim": selectedReport,
      "content": reportTextEditingController.text,
    };
    print("report profile data:" + data.toString());
    try {
      dynamic response = await AccountHttpApiRepository().reportProject(
        data: jsonEncode(data),
        headers: headers,
      );
      if (response['status'] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        // Utils.toastMessage(response['message'].toString());

        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    }
  }

  @override
  void dispose() {
    focusReport.dispose();
    reportTextEditingController.dispose();
  }
}
