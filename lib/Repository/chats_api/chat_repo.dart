import 'dart:io';

import '../../view_model/chats/chat_detail_view_model.dart';
import '../../view_model/project/create_project_view_model.dart';

abstract class ChatRepository {
  Future<dynamic> sendAttachmentsApi(dynamic data, var headers,List<File>? media, String? multipartkey);
  Future<dynamic> blockUser({dynamic data, var headers});
  Future<dynamic> unblockUser({dynamic data, var headers});
  Future<dynamic> sendPush({dynamic data, var headers});

}
