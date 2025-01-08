
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingHandler {
  static List<String> newMessageId = [];

  Future<String> getFcmToken() async {
    final messaging = FirebaseMessaging.instance;

    String? token = await messaging.getToken();
    return token ?? '';
  }

}
