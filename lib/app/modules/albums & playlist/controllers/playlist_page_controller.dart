// C:\work\SoundFlow\lib\app\modules\albums & playlist\controllers\playlist_page_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import model Playlist
import '../../../data/models/playlist.dart'; // <-- Điều chỉnh đường dẫn nếu cần
// Import widget bottom sheet (giả sử nó nằm ở đây)
import '../../../widgets/bottom_song_options.dart'; // <-- Điều chỉnh đường dẫn nếu cần

class PlayListController extends GetxController {
  // Danh sách playlist observable
  final playlists = <Playlist>[].obs;
  final isLoading = true.obs; // Thêm biến trạng thái loading

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists();
  }

  // Hàm fetch dữ liệu playlist (có thể là từ API)
  void fetchPlaylists() async {
    try {
      isLoading(true); // Bắt đầu loading
      // Giả lập gọi API
      await Future.delayed(const Duration(seconds: 1));
      playlists.assignAll([
        Playlist(title: "For the Brokenhearted", imageUrl: "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg"),
        Playlist(title: "Mood Healer", imageUrl: "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/e/d/5/aed50a8e8fd269117c126d8471bf9319.jpg"),
        Playlist(title: "Top Chill Vibes", imageUrl: "https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/4/d/8/d/4d8d4608e336c270994d31c59ee68179.jpg"),
        Playlist(title: "Lofi Study Beats", imageUrl: "https://i.scdn.co/image/ab67706c0000bebb7913dfac17249691a4961351"),
        Playlist(title: "Workout Hits", imageUrl: "https://i.scdn.co/image/ab67706f00000002babc373d33da3a476c15f11f"),
      ]);
    } catch (e) {
      // Xử lý lỗi (ví dụ: hiển thị snackbar)
      Get.snackbar('Error', 'Failed to load playlists: ${e.toString()}');
      print("Error fetching playlists: $e");
    } finally {
      isLoading(false); // Kết thúc loading
    }
  }

  // Hàm hiển thị bottom sheet tùy chọn bài hát
  void showSongOptionsBottomSheet(BuildContext context /*, Song songData - truyền dữ liệu bài hát nếu cần */) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // Quan trọng nếu nội dung sheet dài
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const SongOptionsSheet(/* song: songData */), // Truyền dữ liệu vào sheet nếu cần
    );
  }

  // TODO: Thêm các hàm khác nếu cần (ví dụ: fetchSongsForPlaylist(String playlistId))
}