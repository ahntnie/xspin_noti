import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:xspin_noti/app/app_sp.dart';

// Định nghĩa GlobalKey cho Navigator

// Top-level function để xử lý thông báo background
Future<void> _handleBackground(RemoteMessage message) async {
  print('Background Notification:');
  print("Data: ${message.data}");

  // Lấy title, body và idNoTi từ data
  final title = message.notification!.title;
  final body = message.notification!.body;
  final idNoTi = 1;
  print('Received idNoTi (foreground): $idNoTi'); // Log idNoTi
  print('Received sss (foreground): $title'); // Log idNoTi
  print('Received idNaaaaaaoTi (foreground): $body'); // Log idNoTi
  if (title != null && body != null) {
    await _showLocalNotification(title, body, message.data);

    // await _updateBadgeCount();
  }
}

// Top-level function để hiển thị thông báo cục bộ
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
  // static final _navigationService = appLocator<NavigationService>();
  final firebaseMessaging = FirebaseMessaging.instance;
  //   static final NotificationRequest _notificationRequest = NotificationRequest();
  // static NotificationModel? noti;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // static const MethodChannel _channel = MethodChannel("project/countBadge");
  String FCM_TOPIC_ALL = "xspin_noti";
  String? token;

  Future<void> initNotifications() async {
    // Yêu cầu quyền thông báo
    await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    token = await firebaseMessaging.getToken();
    print('token: $token');
    // Đăng ký topic
    await firebaseMessaging.subscribeToTopic(FCM_TOPIC_ALL);

    // Thiết lập xử lý background và foreground
    FirebaseMessaging.onBackgroundMessage(_handleBackground);
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
    final title = message.notification!.title;
    final body = message.notification!.body;
    final idNoTi = message.data['idNoTi'];
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
      // noti = await _notificationRequest.getNotiById(idNoTi);
      print('Tapped idNoTi: $idNoTi'); // Log idNoTi
      // print('click ${noti}');      // Tạo NotificationModel từ data

      // Kiểm tra navigatorKey trước khi điều hướng

      // await _resetBadgeCount();
      // await _navigationService.navigateToNotificationDetailPage(
      // idNoti: idNoTi,
      // notification: noti!);
      // await _notificationRequest.updateNotificationById(idNoTi);
    } catch (e) {
      print('Error in onNotificationTap: $e');
    }
  }

  // Cập nhật số lượng badge
  // static Future<void> _updateBadgeCount() async {
  //   try {
  //     // Lấy giá trị badge hiện tại từ AppSP
  //     // final storedValue = AppSP.get(AppSPKey.unread_notification_count);
  //     int currentBadgeCount = 0;

  //     // Xử lý giá trị lưu trữ (có thể là null, String, hoặc int)
  //     if (storedValue != null) {
  //       if (storedValue is String) {
  //         currentBadgeCount = int.tryParse(storedValue) ?? 0;
  //       } else if (storedValue is int) {
  //         currentBadgeCount = storedValue;
  //       }
  //     }

  //     // Tăng số lượng badge
  //     currentBadgeCount++;
  //     // Lưu lại số lượng badge
  //     await AppSP.set(AppSPKey.unread_notification_count, currentBadgeCount);
  //     // Gọi MethodChannel để cập nhật badge trên iOS
  //     await _channel.invokeMethod("updateBadgeCount", currentBadgeCount);
  //     print('Badge updated: $currentBadgeCount');
  //   } on PlatformException catch (e) {
  //     print('Lỗi cập nhật badge: $e');
  //   } catch (e) {
  //     print('Lỗi không mong muốn khi cập nhật badge: $e');
  //   }
  // }

  // Reset số lượng badge
  // static Future<void> _resetBadgeCount() async {
  //   try {
  //     final currentCount = AppSP.get(AppSPKey.unread_notification_count) as int;
  //     int newCount = currentCount - 1;
  //     // Reset badge về 0
  //     await AppSP.set(AppSPKey.unread_notification_count, newCount);
  //     // Gọi MethodChannel để cập nhật badge trên iOS
  //     await _channel.invokeMethod("updateBadgeCount", newCount);
  //     print('Badge được reset về $newCount');
  //   } on PlatformException catch (e) {
  //     print('Lỗi reset badge: $e');
  //   } catch (e) {
  //     print('Lỗi không mong muốn khi reset badge: $e');
  //   }
  // }
}
