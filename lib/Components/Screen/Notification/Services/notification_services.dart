import 'package:ai_travel_planner/Components/Screen/Notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../main.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessageBackgroundHandler(RemoteMessage message) async {
  print("Background handler triggered");

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList("notifications") ?? [];
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print("Saving notification: ${notification.title} - ${notification.body}");

      // Save notification locally
      notifications.insert(
        0,
        jsonEncode({
          "title": notification.title ?? "No Title",
          "body": notification.body ?? "No Body",
          "time": DateTime.now().toIso8601String(),
        }),
      );

      // Keep only the last 5 notifications
      if (notifications.length > 5) {
        notifications = notifications.sublist(0, 5);
      }

      await prefs.setStringList("notifications", notifications);
      print("Notification saved successfully. Total notifications: ${notifications.length}");
    } else {
      print("Notification is null");
    }
  } catch (e) {
    print("Error saving notification in background: $e");
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  bool isflutterLocalNotificationsPluginInitialized = false;

  Future<void>  setupnotification() async {
    if (isflutterLocalNotificationsPluginInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_imp_channel',
      "High Importance Channel",
      description: "Important Notification Channel",
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationandroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    final initializedsetting = InitializationSettings(android: initializationandroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializedsetting,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap();
      },
    );

    isflutterLocalNotificationsPluginInitialized = true;
  }

  Future<void> initalized() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessageBackgroundHandler);
    await requestnotificationpermission();
    await _setupMessageHandler();
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      // await _saveNotification(initialMessage);
      _handleNotificationTap();
    }
  }

  Future<void> requestnotificationpermission() async {
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
      print("User Accepted");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User Accepted Provisional");
    } else {
      print("User denied permission");
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      // Save the notification locally
      await _saveNotification(notification.title ?? "", notification.body ?? "");

      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            "high_imp_channel",
            "High Importance Channel",
            channelDescription: "Important Notification Channel",
            importance: Importance.high,
            priority: Priority.high,
            icon: "@mipmap/ic_launcher",
          ),
        ),
        payload: "NotificationPage", // Pass a payload to handle navigation
      );
    }
  }
  // Future<void> saveNotification(RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   if (notification != null && android != null) {
  //     // Save the notification locally
  //     await _saveNotification(notification.title ?? "", notification.body ?? "");
  //
  //   }
  // }


  Future<void> _setupMessageHandler() async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // saveNotification(message);
      // _handleNotificationTap();
    });

    // final initialMessage = await messaging.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleNotificationTap();
    // }
  }

  void _handleNotificationTap({String? payload}) {
    // navigatorKey.currentState?.pushNamed(NotificationPage.routeName);
    Navigator.pushNamed(navigatorKey.currentContext!, NotificationScreen.routeName);
  }

  Future<void> _saveNotification(String title, String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList("notifications") ?? [];
    print(notifications.length);
    if (notifications.length > 4) {
      notifications.removeRange(4, notifications.length);
    }
    notifications.insert(0, jsonEncode({"title": title, "body": body, "time": DateTime.now().toString()}));
    print(notifications.length);
    await prefs.setStringList("notifications", notifications);
  }

  Future<List<Map<String, String>>> getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notifications = prefs.getStringList("notifications") ?? [];
    return notifications
        .map((notif) => Map<String, String>.from(jsonDecode(notif)))
        .toList();
  }
}
