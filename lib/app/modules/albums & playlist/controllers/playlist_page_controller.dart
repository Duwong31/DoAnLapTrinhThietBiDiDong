import 'package:get/get.dart';

class PlayListItem {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  PlayListItem({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  factory PlayListItem.fromJson(Map<String, dynamic> json) {
    return PlayListItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class PlayListController extends GetxController {}
