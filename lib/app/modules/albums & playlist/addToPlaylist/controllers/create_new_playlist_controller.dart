import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/repositories.dart'; // Import repository
import '../../controllers/playlist_page_controller.dart'; // Import controller của trang danh sách

class CreateNewPlaylistController extends GetxController {
  // Inject UserRepository (hoặc PlaylistRepository nếu bạn tạo riêng)
  final UserRepository _userRepository = Get.find();

  final TextEditingController nameController = TextEditingController();
  final isLoading = false.obs; // Quản lý trạng thái loading

  @override
  void onClose() {
    nameController.dispose(); // Giải phóng controller khi không cần
    super.onClose();
  }

  // Hàm xử lý tạo playlist
  Future<void> createPlaylist() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        "Oops",
        "Playlist name can't be empty.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading(true); // Bắt đầu loading

    try {
      // Gọi API thông qua repository
      final response = await _userRepository.createPlaylist(name);

      // Giả sử response thành công nếu không có exception
      isLoading(false); // Kết thúc loading *trước* khi điều hướng hoặc hiển thị snackbar

       // --- QUAN TRỌNG: Làm mới danh sách playlist ở trang trước ---
      try {
          // Tìm instance của PlayListController đang chạy
          final playListController = Get.find<PlayListController>();
          // Gọi hàm fetch lại dữ liệu
          playListController.fetchPlaylists();
          print("Refreshed playlists in PlayListController.");
      } catch (e) {
          // Có thể PlayListController chưa được khởi tạo nếu user vào thẳng đây
          print("Could not find PlayListController to refresh: $e");
          // Bạn có thể xử lý bằng cách khác, ví dụ: set một flag để trang kia tự refresh khi onInit
      }

      Get.back(); // Quay lại trang trước

      Get.snackbar(
        "Success",
        "Playlist \"$name\" created!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } catch (e) {
      isLoading(false); // Kết thúc loading khi có lỗi
      print("Create Playlist Error: $e");
      Get.snackbar(
        "Error",
        "Failed to create playlist. Please try again. (${e.toString()})", // Hiển thị lỗi rõ hơn
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}