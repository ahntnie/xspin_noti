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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase initialized successfully');
  } catch (e) {
    print('❌ Error initializing Firebase: $e');
  }
  FirebaseApi firebaseApi = FirebaseApi();
  firebaseApi.initNotifications();
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
      navigatorKey: navigatorKey,
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
