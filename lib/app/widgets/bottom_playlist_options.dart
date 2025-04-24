import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/styles/style.dart';
import '../data/models/playlist.dart';
import '../modules/albums%20&%20playlist/controllers/playlist_page_controller.dart';

class PlaylistOptionsSheet extends StatelessWidget {
  final Playlist playlist;
  final PlayListController controller = Get.find<PlayListController>();
  PlaylistOptionsSheet({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit playlist'),
            onTap: () {
              Get.back(); 
            },
          ),
          Obx(() => ListTile( // Sử dụng Obx để disable khi đang xóa
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.black
                ),
                title: const Text(
                  'Delete Playlist',
                  style: TextStyle(color: Colors.black),
                ),
                enabled: !controller.isDeletingPlaylist.value, // Disable khi đang xóa
                onTap: controller.isDeletingPlaylist.value
                    ? null // Không làm gì khi đang loading
                    : () {
                        Get.back(); // Đóng bottom sheet *trước* khi hiển thị dialog xác nhận
                        // Gọi hàm xóa trong controller
                        controller.deletePlaylist(playlist);
                      },
                // Có thể thêm trailing là CircularProgressIndicator nhỏ khi loading
                trailing: controller.isDeletingPlaylist.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : null,
              )),
        ],
      ),
    );
  }
}
