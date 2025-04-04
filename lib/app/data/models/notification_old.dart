part of 'models.dart';

class NotificationMessage {
  final String sent;
  final bool isRead;
  final String orderId;
  final String title;
  final NotificationType? notificationType;
  final String body;
  final String id;

  NotificationMessage({
    required this.sent,
    required this.isRead,
    required this.orderId,
    required this.title,
    required this.notificationType,
    required this.body,
    required this.id,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      sent: json['sent'] ?? '',
      isRead: json['isRead'] ?? false,
      orderId: json['orderId'] ?? '',
      title: json['title'] ?? '',
      notificationType: json['notificationType'] == null
          ? null
          : (json['notificationType'] as String).toNotificationType(),
      body: json['body'] ?? '',
      id: json['id'] ?? '',
    );
  }

  NotificationMessage copyWith({
    String? sent,
    bool? isRead,
    String? orderId,
    String? title,
    NotificationType? notificationType,
    String? body,
    String? id,
  }) {
    return NotificationMessage(
      sent: sent ?? this.sent,
      isRead: isRead ?? this.isRead,
      orderId: orderId ?? this.orderId,
      title: title ?? this.title,
      notificationType: notificationType ?? this.notificationType,
      body: body ?? this.body,
      id: id ?? this.id,
    );
  }
}

enum NotificationType { oderDetail, message, generic }

extension RawNotificationType on NotificationType {
  String rawValue() {
    switch (this) {
      case NotificationType.oderDetail:
        return "OrderDetails";
      case NotificationType.message:
        return "NewMessage";
      default:
        return "GenericNotification";
    }
  }
}

extension StringToEnum on String {
  NotificationType toNotificationType() {
    switch (this) {
      case "OrderDetails":
        return NotificationType.oderDetail;
      case "NewMessage":
        return NotificationType.message;
      default:
        return NotificationType.generic;
    }
  }
}
