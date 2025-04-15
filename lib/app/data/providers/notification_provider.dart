import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/utilities/utilities.dart';
import '../../modules/dashboard/controllers/dashboard_controller.dart';
import '../../routes/app_pages.dart';
import '../services/firebase_analytics_service.dart';

final _fln = FlutterLocalNotificationsPlugin();
Future<dynamic> _myBackgroundMessageHandler(RemoteMessage message) async {
  try {
    navigatorPage(message.data, isBackground: true, isBackgroundHandler: true);
  } catch (e) {
    AppUtils.log(e);
  }
}

class NotificationProvider {
  factory NotificationProvider() => _instance;

  NotificationProvider._internal();

  static final _instance = NotificationProvider._internal();
  static final _dataReceive = PublishSubject<Map<String, dynamic>>();

  static Stream<dynamic> get onDataReceived => _dataReceive.stream.distinct();

  static Future<void> requestPermission() async {
    try {
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
    } catch (e) {
      AppUtils.log(e);
    }
  }

  static Future<void> initialize() async {
    await requestPermission();
    final detailLaunch = await _fln.getNotificationAppLaunchDetails();
    if (detailLaunch!.didNotificationLaunchApp) {
      final notificationResponsePayload =
          detailLaunch.notificationResponse?.payload;
      if (notificationResponsePayload != null) {
        var payload = jsonDecode(notificationResponsePayload);
        AppUtils.log(payload);
      }
    }
    var initializationSettings = const InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
      iOS: DarwinInitializationSettings(),
    );
    _fln.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        try {
          if (details.payload != null) {
            Map<String, dynamic> payload = jsonDecode(details.payload!);
            navigatorPage(payload);
          }
        } catch (e) {
          AppUtils.log(e, tag: 'initialize notification');
        }
      },
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
      NotificationProvider.showNotification(remoteMessage);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      // NotificationProvider.showNotification(remoteMessage);
      String notificationBody = remoteMessage.notification?.body ?? '';
      if (notificationBody.contains('You can now add over-the-counter')) {
        FirebaseAnalyticService.logEvent(
          'User_Open_Notification_Add_Over_The_Counter',
        );
      }
      navigatorPage(remoteMessage.data, isBackground: true);
    });
    FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);
  }

  static Future<void> showNotification(RemoteMessage remoteMessage) async {
    Map<String, dynamic> data = remoteMessage.data;
    final threadId = data['message_thread_id'];
    AppUtils.log(data);
    if (threadId != null) {
      if (Get.currentRoute.contains(Routes.chatBox) &&
          Get.parameters['id'] == threadId) {
        _dataReceive.sink.add(data);
        return;
      } else if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().getNumberNotify();
      }
    }
    RemoteNotification? notification = remoteMessage.notification;
    await _fln.show(
      0,
      notification?.title ?? '',
      notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(data),
    );
  }
}

void navigatorPage(dynamic data,
    {isBackground = false, isBackgroundHandler = false}) async {
  if (isBackground) {
    await 1.delay();
  }
  if (data['action'] == 'message' && data['message_thread_id'] != null) {
    Get.toNamed(Routes.chatBox, parameters: {'id': data['message_thread_id']});
  }
}
