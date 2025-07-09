import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xspin_noti/models/noti.model.dart';
import 'package:xspin_noti/requests/noti_request.dart';

Future<void> _handleBackground(RemoteMessage message) async {
  await Firebase.initializeApp(); // Đảm bảo khởi tạo Firebase
  print('Background Notification: ${message.toMap()}');
  print("Data: ${message.data}");
  final title = message.data['title'] ?? message.notification?.title;
  final body = message.data['body'] ?? message.notification?.body;
  final idNoTi = message.data['idNoTi'] ?? '1';
  print('Received idNoTi (background): $idNoTi');
  print('Received title (background): $title');
  print('Received body (background): $body');
  if (title != null && body != null) {
    await FlutterLocalNotificationsPlugin().cancelAll();
    _showLocalNotification(title, body, message.data);
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

    // Chỉ sử dụng data, bỏ qua notification
    final title = message.data['title'] ?? message.notification?.title;
    final body = message.data['body'] ?? message.notification?.body;
    final idNoTi = message.data['idNoTi'] ?? '1';

    print('Received idNoTi (foreground): $idNoTi');
    print('Received title (foreground): $title');
    print('Received body (foreground): $body');
    if (title != null && body != null) {
      await _showLocalNotification(title, body, message.data);
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
      String idNoTi = data['idNoTi'];
      print('Tapped idNoTi: $idNoTi');
    } catch (e) {
      print('Error in onNotificationTap: $e');
    }
  }
}
