import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../model/AuthModels/SignInModel.dart';
import 'chat_detail.dart';
import 'chat_strings.dart';
import 'firebase_user_model.dart';

class FirestoreController {
  static FirestoreController get instance => FirestoreController();

  Future<String> saveUserData(int? id, String? name, String? email, String? image) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection(ChatStrings.usersCollectionReference)
        .where('id', isEqualTo: id.toString())
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    try {
      if (documents.isEmpty) {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection(ChatStrings.usersCollectionReference)
            .doc(id!.toString());
        FirebaseFirestore.instance
            .runTransaction((Transaction myTransaction) async {
          myTransaction.set(userDoc, {
            'id': id.toString(),
            'name': name,
            'email': email,
            'online': true,
            'image': image ?? "",
          });
        });
      }
    } catch (ex) {
      print(ex);
    }

    return id!.toString();
  }

  Future<String> updateUserData(int? id, String? name, String? image,) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection(ChatStrings.usersCollectionReference)
        .doc(id.toString());
    doc.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        doc.update({
          'name': name,
          'image': image != null ? image: "",
        });
      }
    });
    return "";
  }

  static Future chatStatus({String? userID, bool? onlineStatus}) async {
    await FirebaseFirestore.instance
        .collection(ChatStrings.usersCollectionReference)
        .doc(userID)
        .update({'online': onlineStatus});
  }

  Future<FirebaseUserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists) {
        return FirebaseUserModel.fromFirestore(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        print("User not found");
        return null; // or handle this case as needed
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null; // Handle error appropriately
    }
  }

  Future saveMsgToChatRoom(
      String? _documentId,
      String myId,
      String userId,
      String? message,
      int messageType,
      String thumbnail,
      String url,) async {
    if (_documentId==null) {
      ///Create new chat
      var chatDocumentResult = await FirebaseFirestore.instance.collection(ChatStrings.chatsCollectionReference).add({
        ChatStrings.userIds: [int.parse(myId), int.parse(userId)], //user id list
        ChatStrings.createdAt: FieldValue.serverTimestamp(),
        ChatStrings.updatedAt: FieldValue.serverTimestamp(),
        ChatStrings.blockedStatuses: [
          {
            ChatStrings.id: int.parse(myId), ///my user id
            ChatStrings.isBlocked: false,
          },
          {
            ChatStrings.id: int.parse(userId), ///other user id
            ChatStrings.isBlocked: false,
          }
        ],
        ChatStrings.lastMessage: message,
      });

      print("Chat document created: ${chatDocumentResult.id}");

      _documentId = chatDocumentResult.id;

    } else {

      ///To Update all chat members
      FirebaseFirestore.instance.collection(ChatStrings.chatsCollectionReference).doc(_documentId).update({
        ChatStrings.updatedAt: FieldValue.serverTimestamp(),
        ChatStrings.lastMessage: message,
      }).then((value) => print("Chat document updated"));
    }

    ///Update thread everytime with new message
    final _uuid = const Uuid();

    var threadDocument = await FirebaseFirestore.instance
        .collection(ChatStrings.chatsCollectionReference)
        .doc(_documentId)
        .collection(ChatStrings.threadsCollectionReference)
        .add({
      ChatStrings.isRead: false,
      ChatStrings.imageUrl: "",
      ChatStrings.videoUrl: "",
      ChatStrings.messageType: messageType,
      ChatStrings.senderId: int.parse(myId),
      ChatStrings.text: message,
      ChatStrings.createdAt: FieldValue.serverTimestamp(),
      ChatStrings.id: _uuid.v1(),

    });
    print("Chat thread created: ${threadDocument.id}");

    print("Message sent");
    if(messageType != ChatStrings.messageTypeText) {
      if (messageType == ChatStrings.messageTypeImage) {
        print("Message with image");
        threadDocument.update({ChatStrings.imageUrl: url,});
      }if (messageType == ChatStrings.messageTypeVideo) {
        print("Message with Video");
        print(thumbnail);
        print(url);
        threadDocument.update({ChatStrings.imageUrl: thumbnail,});
        threadDocument.update({ChatStrings.videoUrl: url,});

      }
    }

  }

}
