import 'package:get/get.dart';

// class PlayListItem {
//   final String? id;
//   final String? title;
//   final String? description;
//   final String? imageUrl;
//   final DateTime? createdAt;
//
//   PlayListItem({
//     this.id,
//     this.title,
//     this.description,
//     this.imageUrl,
//     this.createdAt,
//   });
//
//   factory PlayListItem.fromJson(Map<String, dynamic> json) {
//     return PlayListItem(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       imageUrl: json['image_url'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//     );
//   }
// }

class Playlist {
  final String title;
  final String imageUrl;

  Playlist({required this.title, required this.imageUrl});
}


class PlayListController extends GetxController {
  final playlists = <Playlist>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  void fetchPlaylists() async {
    await Future.delayed(Duration(seconds: 1)); // giả lập API delay
    playlists.assignAll([
      Playlist(title: "For the Brokenhearted", imageUrl: "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg"),
      Playlist(title: "Mood Healer", imageUrl: "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/e/d/5/aed50a8e8fd269117c126d8471bf9319.jpg"),
      Playlist(title: "Top Chill Vibes", imageUrl: "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/4/d/8/d/4d8d4608e336c270994d31c59ee68179.jpg"),
      // thêm playlist nếu muốn
    ]);
  }
}
