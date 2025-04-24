import 'package:get/get.dart';
import '../../models/song.dart';
import '../core/styles/style.dart';
import '../core/utilities/image.dart';
import '../routes/app_pages.dart';
import '../modules/albums & playlist/controllers/playlist_page_controller.dart';
import 'package:flutter/material.dart';

class SongOptionsSheet extends StatelessWidget {

  final Song song; // Luôn cần thông tin bài hát
  final VoidCallback? onRemoveFromPlaylist; // Callback để xóa (có thể null nếu không phải màn hình playlist)

  const SongOptionsSheet({
    super.key,
    required this.song, // Yêu cầu phải có song
    this.onRemoveFromPlaylist, // Nhận callback (tùy chọn)
  });


  @override
  Widget build(BuildContext context) {

    final PlayListController controller = Get.find<PlayListController>();

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.playlist_add, color: Colors.black),
          title: const Text('Add to playlist'),
          onTap: () {
            Get.toNamed(Routes.addToPlaylist);
          },
        ),
        ListTile(
          leading: Image.asset(
            AppImage.logo1,
            width: 20,
            color: AppTheme.primary,
          ),
          title: const Text('Try Premium'),
          onTap: () {
            // Handle logic
            Get.toNamed(Routes.premium);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: const Text('View artists'),
          onTap: () {
            // Handle logic
            Get.back();
          },
        ),
        if (onRemoveFromPlaylist != null)
          Obx(() => ListTile(
                // Sử dụng controller đã lấy ở trên
                leading: controller.isRemovingSong.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.remove_circle_outline, color: Colors.black),
                title: Text('Remove from this playlist', style: TextStyle(color: controller.isRemovingSong.value ? Colors.grey : Colors.black)),
                onTap: controller.isRemovingSong.value ? null : () {
                    Navigator.pop(context);
    
                    onRemoveFromPlaylist!(); 
                },
              )),
        const SizedBox(height: 10),
      ],
    );
  }
}
