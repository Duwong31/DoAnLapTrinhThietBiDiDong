import 'package:get/get.dart';

class AlbumItem {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  AlbumItem({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    return AlbumItem(
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

class AlbumController extends GetxController {
}