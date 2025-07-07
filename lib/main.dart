import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:xspin_noti/app/app_sp.dart';
import 'package:xspin_noti/app/app_sp_key.dart';
import 'package:xspin_noti/app/di.dart';
import 'package:xspin_noti/constants/firebase_api.dart';
import 'package:xspin_noti/firebase_options.dart';
import 'package:xspin_noti/views/auth_view/login_view/login_view.dart';
import 'package:xspin_noti/views/home_view/home_view.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🎯 Background message received: ${message.messageId}');
  print('🔥 Message data: ${message.data}');

  final title = message.data['title'];
  final body = message.data['body'];
  if (title != null && body != null) {
    await FirebaseApi.showLocalNotification(
        title, body, message.data); // hoặc static method
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register background message handler TRƯỚC KHI RUN APP
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('🔥 Firebase initialized successfully');

  // Init Firebase Notifications
  FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  // Subcribe topic
  String FCM_TOPIC_ALL = "xspin_noti";
  FirebaseMessaging.instance.subscribeToTopic(FCM_TOPIC_ALL);

  await DependencyInjection.init();

  final userJson = await AppSP.get(AppSPKey.userInfo);
  final isLoggedIn = userJson != null;

  FlutterNativeSplash.remove();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xspin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFED1925)),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const HomeView() : const LoginView(),
    );
  }
}
