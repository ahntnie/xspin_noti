import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/main.dart';
import 'package:xspin_noti/models/noti.model.dart';
import 'package:xspin_noti/requests/noti_request.dart';
import 'package:xspin_noti/view_models/project/projectNoti_viewModel.dart';
import 'package:xspin_noti/views/detail_view/detail_view.dart';

Future<void> _handleBackground(RemoteMessage message) async {
  print('Background Notification:');
  print("Data: ${message.data}");

  // Lấy title, body và idNoTi từ data
  final title = message.data['title'];
  final body = message.data['body'];
  final idNoTi = message.data['idNoTi'];
  print('Received idNoTi (background): $idNoTi'); // Log idNoTi

  if (title != null && body != null) {
    await _showLocalNotification(title, body, message.data);
  }
}

Future<void> _showLocalNotification(
    String? title, String? body, Map<String, dynamic> data) async {
  final dio = Dio();
  final imageUrl = data['imageUrl'] as String?;

  AndroidNotificationDetails androidDetails;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        androidDetails = AndroidNotificationDetails(
          'xspin_notification_channel_id',
          'Xspin Notifications',
          channelDescription: 'Thông báo Xspin',
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: ByteArrayAndroidBitmap(response.data),
          icon: '@drawable/notifications',
        );
      } else {
        print('Failed to load image: Status ${response.statusCode}');
        androidDetails = const AndroidNotificationDetails(
          'xspin_notification_channel_id',
          'Xspin Notifications',
          channelDescription: 'Thông báo Xspin',
          importance: Importance.high,
          priority: Priority.high,
          largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
          icon: '@drawable/notifications',
        );
      }
    } catch (e) {
      print('Error loading image with Dio: $e');
      androidDetails = const AndroidNotificationDetails(
        'xspin_notification_channel_id',
        'Xspin Notifications',
        channelDescription: 'Thông báo Xspin',
        importance: Importance.high,
        priority: Priority.high,
        largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
        icon: '@drawable/notifications',
      );
    }
  } else {
    androidDetails = const AndroidNotificationDetails(
      'xspin_notification_channel_id',
      'Xspin Notifications',
      channelDescription: 'Thông báo Xspin',
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
      icon: '@drawable/notifications',
    );
  }

  NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await localNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    platformDetails,
    payload: jsonEncode(data),
  );
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String FCM_TOPIC_ALL = "xspin_noti";
  String? token;
  static NotiModel? noti;
  static final NotiRequest _notiRequest = NotiRequest();
  static final ProjectViewmodel projectViewmodel = ProjectViewmodel();
  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    await firebaseMessaging.subscribeToTopic(FCM_TOPIC_ALL);
    FirebaseMessaging.onBackgroundMessage(
        _handleBackground); // Bật xử lý background
    FirebaseMessaging.onMessage.listen(_handleForeground);
    await _initializeLocalNotifications();
  }

  String? getToken() {
    return token;
  }

  Future<void> _handleForeground(RemoteMessage message) async {
    print('Foreground Notification:');
    print("Data: ${message.data}");

    // Lấy title, body và idNoTi từ data
    final title = message.data['title'];
    final body = message.data['body'];
    final idNoTi = message.data['idNoTi'];
    print('Received idNoTi (foreground): $idNoTi'); // Log idNoTi

    if (title != null && body != null) {
      await _showLocalNotification(title, body, message.data);
      // await _updateBadgeCount();
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'xspin_notification_channel_id',
      'Xspin Notifications',
      description: 'Thông báo Xspin',
      importance: Importance.high,
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void onNotificationTap(NotificationResponse response) async {
    try {
      final data = jsonDecode(response.payload ?? '{}');
      print('Notification tapped: $data');
      String idPush = data['IdPush'];
      noti = await _notiRequest.handleGetDetailNoti(
          IdPush: idPush, IdThanhVien: AppSP.get(AppSPKey.idUser));
      if (noti != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => DetailView(
              idPush: idPush,
              notiModel: noti!,
              // projectViewmodel: projectViewmodel,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error in onNotificationTap: $e');
    }
  }
}
