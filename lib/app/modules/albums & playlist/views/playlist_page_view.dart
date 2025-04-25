// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_page_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import style, routes, controller và model
import '../../../core/styles/style.dart';       // <-- Điều chỉnh đường dẫn
import '../../../routes/app_pages.dart';      // <-- Điều chỉnh đường dẫn
import '../../../widgets/playlist_cover_widget.dart';
import '../controllers/playlist_page_controller.dart'; // <-- Điều chỉnh đường dẫn
import '../../../data/models/playlist.dart';      // <-- Điều chỉnh đường dẫn

class PlayListView extends GetView<PlayListController> {
  const PlayListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'PlayList',
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            tooltip: 'Refresh',
            onPressed: () => controller.fetchPlaylists(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        // Sử dụng Obx để lắng nghe thay đổi state trong controller
        child: Obx(() {
          // Hiển thị loading indicator khi đang fetch dữ liệu
          if (controller.isLoadingPlaylists.value) {
            return const Center(child: CircularProgressIndicator());
          }
          // Hiển thị thông báo nếu không có playlist
          if (controller.playlists.isEmpty) {
            return const Center(child: Text("No playlists found."));
          }
          // Hiển thị GridView khi có dữ liệu
          return _buildLazyGridView(context);
        }),
      ),
    );
  }

  // Widget xây dựng GridView
  Widget _buildLazyGridView(BuildContext context) {
    // Lấy danh sách items từ controller (đã được cập nhật bởi Obx)
    final items = controller.playlists;

    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // Số cột
        crossAxisSpacing: 12,     // Khoảng cách ngang
        mainAxisSpacing: 12,      // Khoảng cách dọc
        childAspectRatio: 0.8,    // Tỷ lệ chiều rộng/cao của item
      ),
      itemBuilder: (context, index) {
        final Playlist item = items[index]; // Lấy item playlist cụ thể
        return GestureDetector(
          onTap: () {
            // Điều hướng đến trang chi tiết playlist, truyền object Playlist qua arguments
            Get.toNamed(Routes.playlistnow, arguments: item);
          },
          child: Container(
            decoration: BoxDecoration(
              // Nên dùng màu từ Theme
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [ // Thêm shadow nhẹ cho đẹp hơn
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.2),
                   spreadRadius: 1,
                   blurRadius: 4,
                   offset: const Offset(0, 2),
                 )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Để ảnh và text giãn đầy chiều ngang
              children: [
                Expanded( // Cho phép ảnh chiếm không gian còn lại theo chiều dọc
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: PlaylistCoverWidget(firstTrackId: item.firstTrackId),
                    // child: Image.network(
                    //   item.imageUrl,
                    //   fit: BoxFit.cover, // Đảm bảo ảnh cover hết vùng
                    //    // Placeholder và error builder cho Image.network
                    //    loadingBuilder: (context, child, loadingProgress) {
                    //      if (loadingProgress == null) return child;
                    //      return Container( // Giữ đúng kích thước khi loading
                    //        color: Colors.grey[300],
                    //        child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                    //      );
                    //    },
                    //    errorBuilder: (context, error, stackTrace) => Container(
                    //      color: Colors.grey[300],
                    //      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    //    ),
                    // ),
                  ),
                ),
                // Sử dụng const SizedBox hoặc Dimes từ style
                const SizedBox(height: 8), // Hoặc Dimes.height8
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), // Style chữ
                    maxLines: 2, // Giới hạn 2 dòng
                    overflow: TextOverflow.ellipsis, // Hiển thị ... nếu quá dài
                  ),
                ),
                const SizedBox(height: 8), // Thêm khoảng cách dưới cùng
              ],
            ),
          ),
        );
      },
    );
  }
}