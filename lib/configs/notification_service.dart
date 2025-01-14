/*
import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:val_app/configs/routes/routes_name.dart';

import '../firestore/chat_strings.dart';
import '../main.dart';


class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      handleMessage(message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (kDebugMode) {
        print('notification type:${message.data['type']}');
      }

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      }
    });
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      sound: channel.sound,
    );

    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title ?? 'No Title',
        message.notification!.body ?? 'No Body',
        notificationDetails,
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);

    });
  }

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleBackgroundMessage(initialMessage);

    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleBackgroundMessage(event);

    });
  }

  void handleMessage(RemoteMessage message) {
    print('on tap handle notification');
    if(message.data['type'] == "message"){
     */
/* print('ontap data:${message.data['document_id']}');
      Navigator.pushNamed(NavigationService.navigatorKey.currentContext!, RoutesName.chatDetail, arguments: {
        "userId": message.data['sender_id'],
        "documentId": message.data['document_id']
      });*//*


    }else if(message.data['type'] == "rate"){
      print('notification data:${message.data['project_id']}');
    }else if(message.data['type'] == "comment"){
      print('notification data:${message.data['project_id']}');
    }else if(message.data['type'] == "follow"){
      print('notification data:${message.data['val_profile']}');
    }else if(message.data['type'] == "like"){
      print('notification data:${message.data['project_id']}');
    }
  }

  void handleBackgroundMessage(RemoteMessage message) {
    print('on tap handle background notification');
    Future.delayed(Duration(seconds: 3), () {
      if(message.data['type'] == "message"){

      }else if(message.data['type'] == "rate"){

      }else if(message.data['type'] == "comment"){

      }else if(message.data['type'] == "follow"){

      }else if(message.data['type'] == "like"){

      }
    });


  }

  Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}*/
