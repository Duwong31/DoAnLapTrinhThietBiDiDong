part of 'models.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.message,
    required this.event,
    required this.avatar,
    required this.name,
    required this.description,
    required this.isRead,
    required this.createdAt,
    this.link,
    this.carId
  });

  final String id;
  final NotificationType notificationType;
  final String title;
  final String message;
  final EventType? event;
  final String avatar;
  final String name;
  final String description;
  bool isRead;
  final DateTime createdAt;
  final String? link;
  final int? carId;

  String get date => DateFormat('MM/dd/yyyy').format(createdAt);

  /// Factory method to create the appropriate model based on `notificationType`
  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    final notificationType =
        (json["notification_type"] as String).toNotificationType();

    // Otherwise, create a standard NotificationModel
    return NotificationModel(
      id: json["id"],
      notificationType: notificationType,
      title: json["title"] ?? '',
      event: EventTypeExtension.fromString(json["event"]),
      avatar: json["avatar"] ?? '',
      message: json["message"] ?? '',
      name: json["name"] ?? '',
      description: json["description"] ?? '',
      isRead: json["is_read"] ?? false,
      createdAt: DateTime.parse(json["created_at"]),
      link: json["link"],
      carId: json["car_id"],
    );
  }
}

enum EventType {
  bookingCreatedEvent,
  bookingUpdatedEvent,
  bookingCancelledEvent,
  bookingPickupTimeEvent,
  bookingReturnLateEvent,
  bookingInvoiceEvent,
  createReviewEvent,
  paymentSuccessEvent
}

class GroupNotificationModel{
  String groupName;
  List<NotificationModel> notificationList;

  GroupNotificationModel(this.groupName, this.notificationList);
}
