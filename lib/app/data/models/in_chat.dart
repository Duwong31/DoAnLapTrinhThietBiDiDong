part of 'models.dart';

class InChat {
  InChat({
    required this.senderId,
    required this.receiverId,
  });
  factory InChat.fromJson(Map<String, dynamic> json) => InChat(
        senderId: json["senderId"],
        receiverId: json["receiverId"],
      );
  String senderId;
  String receiverId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "senderId": senderId,
        "receiverId": receiverId,
      };
}
