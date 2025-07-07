import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';

Future<void> _handleBackground(RemoteMessage message) async {
  print('Background Notification: ${message.toMap()}');
  print("Data: ${message.data}");
  final title = message.data['title'];
  final body = message.data['body'];
  final idNoTi = message.data['idNoTi'] ?? '1';
  print('Received idNoTi (foreground): $idNoTi');
  print('Received sss (foreground): $title');
  print('Received idNaaaaaaoTi (foreground): $body');
  print('Notification: ${message.notification}');
  if (title != null && body != null) {
    _showLocalNotification(title, body, message.data);
  }
}

Future<void> _showLocalNotification(
    String? title, String? body, Map<String, dynamic> data) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'xspin_notification_channel_id',
    'Xspin Notifications',
    channelDescription: 'Thông báo Xspin',
    importance: Importance.high,
    priority: Priority.high,
    largeIcon: DrawableResourceAndroidBitmap('ic_notification'),
    icon: '@drawable/notifications',
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

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

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    await firebaseMessaging.subscribeToTopic(FCM_TOPIC_ALL);
    FirebaseMessaging.onBackgroundMessage(_handleBackground);
    FirebaseMessaging.onMessage.listen(_handleForeground);
    // FirebaseMessaging.onMessage
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

    final idNoTi = message.data['idNoTi'] ?? '1';
    print('Received idNoTi (foreground): $idNoTi'); // Log idNoTi
    print('Received sss (foreground): $title'); // Log idNoTi
    print('Received idNaaaaaaoTi (foreground): $body'); // Log idNoTi
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

    // Tạo kênh thông báo cho Android 8.0+
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
      String idNoTi = data['idNoTi'];
      print('Tapped idNoTi: $idNoTi'); // Log idNoTi
    } catch (e) {
      print('Error in onNotificationTap: $e');
    }
  }
}
