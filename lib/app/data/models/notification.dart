part of 'models.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.isRead,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  final String id;
  final String targetId;
  final String targetType;
  bool isRead;
  final String title;
  final String description;
  final DateTime createdAt;
  bool get promote => targetType != 'Order';

  String get date => DateFormat('MM/dd/yyyy').format(createdAt);

  factory NotificationModel.fromMap(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        targetId: json["target_id"] ?? '',
        targetType: json["target_type"] ?? '',
        isRead: json["is_read"] ?? false,
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        createdAt: DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      );
}
