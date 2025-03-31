import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  bool _hasNotification = true; // Trạng thái thông báo

  bool get hasNotification => _hasNotification;

  void clearNotification() {
    _hasNotification = false;
    notifyListeners(); // Cập nhật UI trên toàn app
  }
}
