import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationInit {
  Future<void> init() async {
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    // Android Init Setting
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // IOS init Setting
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    // Init Setting
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    // IOS Request Permission
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: false,
          sound: true,
        );
    // Init Flutter Local Notification Plugin
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  // Handle On Tap Of Notification
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
}
