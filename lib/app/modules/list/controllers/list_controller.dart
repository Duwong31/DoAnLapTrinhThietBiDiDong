import 'package:get/get.dart';

class ListItem {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? createdAt;

  ListItem({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class ListController extends GetxController {}
