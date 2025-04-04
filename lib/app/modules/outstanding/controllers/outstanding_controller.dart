import 'package:get/get.dart';

class OutstandingItem {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  OutstandingItem({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  factory OutstandingItem.fromJson(Map<String, dynamic> json) {
    return OutstandingItem(
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

class OutstandingController extends GetxController {
  // Không cần xử lý dữ liệu phức tạp khi chỉ hiển thị văn bản tĩnh
}
