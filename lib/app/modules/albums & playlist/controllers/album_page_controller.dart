import 'package:get/get.dart';

class Album {
  final String title;
  final String imageUrl;

  Album({required this.title, required this.imageUrl});
}


class AlbumController extends GetxController {
  final playlists = <Album>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  void fetchPlaylists() async {
    await Future.delayed(Duration(seconds: 1)); // giả lập API delay
    playlists.assignAll([
      Album(title: "Jack - J97", imageUrl: "https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/avatars/0/3/3/7/0337e4cc5a05cdcc93b5d65762aea241.jpg"),
      Album(title: "Phan Mạnh Quỳnh", imageUrl: "https://i1.sndcdn.com/artworks-Kqc0EeoQXIjYObfm-Fyae3w-t500x500.jpg"),
      Album(title: "Sơn Tùng - MTP", imageUrl: "https://photo-zmp3.zadn.vn/avatars/5/9/6/9/59696c9dba7a914d587d886049c10df6.jpg"),
      // thêm album nếu muốn
    ]);
  }
}
