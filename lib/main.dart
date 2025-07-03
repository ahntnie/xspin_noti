import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:xspin_noti/app/di.dart';
import 'package:xspin_noti/constants/firebase_api.dart';
import 'package:xspin_noti/firebase_options.dart';
import 'package:xspin_noti/views/home_view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Khởi tạo Firebase một lần duy nhất
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print('🔥 Firebase initialized successfully');
  } catch (e) {
    print('❌ Error initializing Firebase: $e');
  }
  FirebaseApi firebaseApi = FirebaseApi();
  firebaseApi.initNotifications();
  String FCM_TOPIC_ALL = "xspin_noti";
  FirebaseMessaging.instance.subscribeToTopic(FCM_TOPIC_ALL);
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
