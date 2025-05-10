// C:\work\SoundFlow\lib\app\widgets\bottom_song_options.dart
import 'package:get/get.dart';
import '../../models/song.dart'; // Đảm bảo import Song model
import '../core/styles/style.dart';
import '../core/utilities/image.dart';
import '../routes/app_pages.dart';
// import '../modules/albums & playlist/controllers/playlist_page_controller.dart'; // Không cần trực tiếp ở đây nữa nếu onRemoveFromPlaylist đã đủ

class SongOptionsSheet extends StatelessWidget {
  final Song song;
  final VoidCallback? onRemoveFromPlaylist;
  // Nếu cần trạng thái loading cho nút Remove, có thể truyền RxBool vào đây
  // final RxBool? isRemoving;

  const SongOptionsSheet({
    super.key,
    required this.song,
    this.onRemoveFromPlaylist,
    // this.isRemoving,
  });

  @override
  Widget build(BuildContext context) {
    // Không cần Get.find<PlayListController>() ở đây nếu chỉ dùng onRemoveFromPlaylist

    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.playlist_add, color: Colors.black),
          title: const Text('Add to playlist'),
          onTap: () {
            // 1. Đóng bottom sheet hiện tại
            Navigator.pop(context); // Hoặc Get.back();

            // 2. Điều hướng đến trang AddToPlaylist, TRUYỀN song.id
            Get.toNamed(Routes.addToPlaylist, arguments: song.id); // <--- QUAN TRỌNG
          },
        ),
        // ... các ListTile khác giữ nguyên ...
         ListTile(
          leading: Image.asset( AppImage.logo1, width: 20, color: AppTheme.primary),
          title: const Text('Try Premium'),
          onTap: () {
             Navigator.pop(context);
             Get.toNamed(Routes.premium);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: const Text('View artists'),
          onTap: () {
            Navigator.pop(context);
          
          },
        ),
        if (onRemoveFromPlaylist != null) // Chỉ hiển thị nếu callback được cung cấp
           ListTile(
                 leading: const Icon(Icons.remove_circle_outline, color: Colors.black), // Tạm bỏ loading ở đây, controller của PlaylistPage sẽ xử lý
                 title: const Text('Remove from this playlist'),
                 onTap: () {
                     Navigator.pop(context); // Đóng sheet trước
                     onRemoveFromPlaylist!(); // Gọi callback được truyền vào
                 },
           ),
          // Obx(() => ListTile(
          //       leading: (isRemoving?.value ?? false) // Kiểm tra null safety
          //           ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          //           : const Icon(Icons.remove_circle_outline, color: Colors.black),
          //       title: Text('Remove from this playlist', style: TextStyle(color: (isRemoving?.value ?? false) ? Colors.grey : Colors.black)),
          //       onTap: (isRemoving?.value ?? false) ? null : () {
          //           Navigator.pop(context);
          //           onRemoveFromPlaylist!();
          //       },
          //     )),
        const SizedBox(height: 10),
      ],
    );
  }
}