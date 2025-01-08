import 'package:flutter/material.dart';
import 'package:val_app/model/user_post_detail_model.dart'; 
import '../../Repository/home_api/home_api_repo.dart';
import '../../Repository/project_api/project_api_repo.dart';
import '../../configs/utils.dart';
import '../../model/all_comments_model.dart';

class CommentsViewModel extends ChangeNotifier {
  TextEditingController commentTextEditingController = TextEditingController();
  FocusNode focusComment = FocusNode();
  List<CommentsData> commentsList = [];
  bool isLoading = true;
  UserPostDetailModel? feedPostDetail;

  ProjectHttpApiRepository projRepo = ProjectHttpApiRepository();
  HomeHttpApiRepository homeRepo = HomeHttpApiRepository();

  Future<void> postComment(BuildContext context, {String? id}) async {
    Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {'Authorization': 'Bearer ${accessToken}'};
    print("headers:" + headers.toString());
    var data = {
      "comment": commentTextEditingController.text.trim().toString(),
    };
    try {
      var response = await projRepo.projectComment(data: data, headers: headers, id: id);

      if (response["status"] == "success") {
        Navigator.pop(context);
        focusComment.unfocus();
        commentTextEditingController.clear();
        print("comment" + response.toString()); 
        notifyListeners();
      } else {
        Navigator.pop(context);
      }
    } catch (error) {
      Navigator.pop(context); // Ensure the loading dialog is closed on error
      Utils.toastMessage(error.toString());
      print("error: $error");
    }
  } 
  Future<void> getComments(BuildContext context, String id, {bool isPullToRefresh = true}) async {
    if (isPullToRefresh == false) Utils().loadingDialog(context);
    final credentials = await Utils.getUserCredentials();
    String? accessToken = credentials['accessToken'];
    var headers = {
      'Authorization': 'Bearer ${accessToken}',
    };
    try {
      var response = await ProjectHttpApiRepository().getComments(headers, id: id);
      if (response['status'] == true) {
        final comments = AllCommentsModel.fromJson(response);

        commentsList = comments.data ?? [];

        notifyListeners();

        print(response.toString());
        if (isPullToRefresh == false) Navigator.pop(context);
        notifyListeners();
      } else {
        Navigator.pop(context);
        Utils.toastMessage(response['message'].toString());
      }
    } catch (error) {
      Navigator.pop(context);
      Utils.toastMessage(error.toString());
    } finally {
      isLoading = false;
    }
  }
}
