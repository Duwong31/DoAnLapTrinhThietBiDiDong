part of 'models.dart';

class MessageModel {
  MessageModel({
    required this.id,
    required this.senderId,
    this.attachment,
    required this.message,
    required this.name,
    required this.createdAt,
    required this.isAutoReply,
  });
  final String id;
  final String senderId;
  final String name;
  final String? attachment;
  final String message;
  final int createdAt;
  final bool isAutoReply;
  String get date => AppUtils.formatDateChat(createdAt);
  factory MessageModel.fromMap(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        senderId: json["sender_id"] ?? '',
        attachment: json["attachment"],
        name: json["name"] ?? '',
        message: json["message"] ?? '',
        createdAt: json["created_at"],
        isAutoReply: json["is_auto_reply"] ?? false,
      );
}

class Objectable {
  Objectable({
    required this.id,
    required this.externalId,
    required this.status,
  });

  final String id;
  final String externalId;
  final String status;

  factory Objectable.fromMap(Map<String, dynamic> json) => Objectable(
        id: json["id"] ?? '',
        externalId: json["external_id"] ?? '',
        status: json["status_name"] ?? '',
      );
}
