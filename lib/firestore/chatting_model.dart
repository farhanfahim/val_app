import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_strings.dart';

class ChattingModel {
  int type;
  int userId;
  int senderId;
  String text;
  String image;
  String video;
  Timestamp? time;
  String id;

  ChattingModel({
    required this.type,
    required this.userId,
    required this.senderId,
    required this.text,
    required this.image,
    required this.video,
    required this.time,
    required this.id,
  });

  factory ChattingModel.fromFirestore(String userID,DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ChattingModel(
      id: data[ChatStrings.id],
      type: data[ChatStrings.messageType],
      userId: int.parse(userID),
      senderId: data[ChatStrings.senderId],
      text: data[ChatStrings.text],
      image: data[ChatStrings.imageUrl],
      video: data[ChatStrings.videoUrl],
      time: data[ChatStrings.createdAt],
    );
  }
}
