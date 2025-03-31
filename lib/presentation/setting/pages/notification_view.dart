import 'package:flutter/material.dart';
import 'dart:async';

import '../../../core/configs/theme/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, String>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    await Future.delayed(Duration(seconds: 2)); // Giả lập tải API
    setState(() {
      notifications = [
        {'title': 'Thông báo 1', 'message': 'Nội dung thông báo 1'},
        {'title': 'Thông báo 2', 'message': 'Nội dung thông báo 2'},
        {'title': 'Thông báo 3', 'message': 'Nội dung thông báo 3'},
        {'title': 'Thông báo 4', 'message': 'Nội dung thông báo 4'},
        {'title': 'Thông báo 5', 'message': 'Nội dung thông báo 5'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "Thông báo",
        style: TextStyle(
          color: AppColors.primary,
        ),
      )),
      body: notifications.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.notifications, color: AppColors.primary),
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['message']!),
            ),
          );
        },
      ),
    );
  }
}
