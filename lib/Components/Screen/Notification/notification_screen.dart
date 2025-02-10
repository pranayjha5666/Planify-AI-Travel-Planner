import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Common/widget/custom_button.dart';
class NotificationScreen extends StatefulWidget {
  static const String routeName = "/notification-screen";

  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedNotifications = prefs.getStringList("notifications") ?? [];

    setState(() {
      notifications = storedNotifications
          .map((notif) => Map<String, String>.from(jsonDecode(notif)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:notifications.isEmpty
          ? Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications,
                size: 40,
                color: Colors.red,
              ),
              SizedBox(height: 20,),
              Center(
                child: Text(
                  "No Notification Yet",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          :ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification["title"] ?? "No title"),
            subtitle: Text(notification["body"] ?? "No message"),
            trailing: Text(
              _formatTime(notification["time"] ?? ""),
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
  String _formatTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return "${dateTime.hour}:${dateTime.minute}";
  }
}
