import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/styles/style.dart';
// *** THÊM IMPORT CONTROLLER ***
import '../controllers/create_new_playlist_controller.dart';

// *** CHUYỂN THÀNH GetView ***
class CreateNewPlaylist extends GetView<CreateNewPlaylistController> {
  const CreateNewPlaylist({Key? key}) : super(key: key);

  // Không cần State nữa, xóa class _CreateNewPlaylistState

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Playlist"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Give your playlist a name", // Sửa text một chút
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            /// Field input kiểu underline
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    // *** SỬ DỤNG CONTROLLER TỪ GetView ***
                    controller: controller.nameController,
                    decoration: const InputDecoration(
                      hintText: "Playlist Name", // Thêm hintText
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.words,
                    // Tự động focus khi màn hình mở lên
                    autofocus: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// Row gồm 2 nút
            Row(
              children: [
                Expanded(
                  // *** SỬ DỤNG Obx ĐỂ HIỂN THỊ LOADING ***
                  child: Obx(() => ElevatedButton(
                        // Gọi hàm từ controller
                        onPressed: controller.isLoading.value ? null : controller.createPlaylist,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          // Thay đổi style khi đang loading
                          disabledBackgroundColor: AppTheme.primary.withOpacity(0.5)
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox( // Hiển thị loading indicator
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text("Create", // Hiển thị text bình thường
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      )),
                ),
                const SizedBox(width: 16), // Khoảng cách giữa 2 nút
                Expanded(
                  child: OutlinedButton(
                    // *** Vẫn dùng Get.back() đơn giản ***
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black26),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    // Sửa màu chữ nút Cancel cho hợp lý
                    child: Text("Cancel",
                        style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                             fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}