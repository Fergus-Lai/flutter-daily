import 'package:android_daily/auth/sign_in.dart';
import 'package:android_daily/nav.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase App
  await Firebase.initializeApp();
  // Initialize Timezone for Notification
  tz.initializeTimeZones();
  runApp(MyApp());
}

// Firebase Auth Instance
FirebaseAuth auth = FirebaseAuth.instance;

// Main application Widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Initialize Widget App Used For Home
  Widget app = auth.currentUser == null ? SignIn() : Nav();

  // Listen To Auth State Change And Change Page According To User Value
  void logInCheck() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          app = SignIn();
        });
      } else {
        setState(() {
          app = Nav();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize flutter_local_notification
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  // When The Notification Is Clicked
  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('alarm')
          .doc(payload)
          .update({"activate": "0"});
    }
  }

  // Building The App
  @override
  Widget build(BuildContext context) {
    logInCheck();
    return MaterialApp(
      title: 'Flutter Daily',
      home: app,
    );
  }
}
