// C:\work\SoundFlow\lib\app\modules\albums & playlist\addToPlaylist\views\add_to_playlist.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import các thành phần cần thiết
import '../../../../core/styles/style.dart'; // AppTheme
import '../../../../routes/app_pages.dart';
import '../controllers/add_to_playlist_controller.dart'; // Controller
import '../../../../data/models/playlist.dart';      // Model
import '../../../../widgets/playlist_cover_widget.dart'; // Widget ảnh bìa

class AddToPlaylistPage extends GetView<AddToPlaylistController> { // Sử dụng GetView
  const AddToPlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy màu cam từ AppTheme hoặc định nghĩa trực tiếp
    final Color highlightColor = AppTheme.primary; // Hoặc Colors.orange

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        // Không cần title nếu giống giao diện gốc
        actions: [
           // Thêm nút refresh nếu muốn
           IconButton(
             icon: const Icon(Icons.refresh, color: Colors.black),
             tooltip: 'Refresh',
             onPressed: () => controller.fetchPlaylists(),
           ),
        ]
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // --- Nút "New playlist" ---
          ElevatedButton(
            onPressed: () => controller.goToCreatePlaylist(), // Gọi hàm từ controller
            style: ElevatedButton.styleFrom(
              // Style giống hệt bản gốc
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('New playlist'),
          ),
          const SizedBox(height: 20),
          // --- Header Row ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Text giống bản gốc
                const Text('Saved in', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                // Obx để hiển thị/ẩn nút Clear all
                Obx(() => controller.selectedPlaylistIds.isNotEmpty
                    ? GestureDetector(
                        onTap: () => controller.clearSelection(), // Gọi hàm từ controller
                        // Style giống bản gốc
                        child: Text('Clear all', style: TextStyle(color: highlightColor)),
                      )
                    : const SizedBox.shrink()), // Ẩn nếu không có gì được chọn
              ],
            ),
          ),
          // --- Dòng "Most relevant" (Giữ nguyên nếu muốn) ---
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.list), // Icon giống bản gốc
                SizedBox(width: 8),
                // Text giống bản gốc
                Text('Most relevant', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // --- Danh sách Playlist ---
          Expanded(
            child: Obx(() { // Bọc bằng Obx để lắng nghe loading và list
              // 1. Loading State
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // 2. Empty State
              if (controller.playlists.isEmpty) {
                return const Center(child: Text("No playlists found. Create one!"));
              }
              // 3. List View Builder
              return ListView.builder(
                itemCount: controller.playlists.length,
                itemBuilder: (context, index) {
                  final Playlist playlist = controller.playlists[index];

                  // Obx bọc ListTile hoặc chỉ phần trailing để tối ưu rebuild
                  return Obx(() {
                      final bool isSelected = controller.selectedPlaylistIds.contains(playlist.id);

                      return ListTile(
                        // --- Leading: Sử dụng PlaylistCoverWidget ---
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            // Không bo góc nếu gốc không có
                             borderRadius: BorderRadius.zero, // Hoặc bỏ hẳn ClipRRect nếu không cần bo góc
                            child: PlaylistCoverWidget(
                              firstTrackId: playlist.firstTrackId,
                              // Placeholder hoặc Error widget nếu cần
                            ),
                          ),
                        ),
                        // --- Title ---
                        title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        // --- Subtitle ---
                        subtitle: Text('${playlist.trackIds.length} songs', style: Theme.of(context).textTheme.bodySmall),
                        // --- Trailing: Checkbox tròn ---
                        trailing: GestureDetector(
                          onTap: () => controller.toggleSelection(playlist.id), // Gọi hàm controller
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Style border và màu nền giống bản gốc
                              border: Border.all(
                                  color: isSelected ? highlightColor : Colors.grey[400]!, // Màu cam khi chọn
                                  width: 2.2),
                              color: isSelected ? highlightColor : Colors.transparent, // Nền cam khi chọn
                            ),
                            // Icon check màu trắng khi chọn
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                        ),
                        // Cho phép nhấn cả list tile để chọn
                        onTap: () => controller.toggleSelection(playlist.id),
                      );
                  }); // Kết thúc Obx cho ListTile/Trailing
                },
              );
            }),
          ), // Kết thúc Expanded

          // --- Nút "Done" ---
          Padding(
            padding: const EdgeInsets.all(16.0), // Padding giống bản gốc
            child: Obx(() => SizedBox( // Bọc Obx để cập nhật trạng thái nút
                 width: double.infinity, // Chiếm hết chiều ngang
                 child: ElevatedButton(
                    // onPressed gọi hàm controller, vô hiệu hóa nếu không có gì được chọn
                    onPressed: controller.selectedPlaylistIds.isEmpty || controller.isAdding.value
                        ? null
                        : () => controller.addTrackToSelectedPlaylists(), // Gọi hàm tạm thời hoặc hàm add thật
                    // Style nút giống bản gốc
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary, // Màu nền chính
                      foregroundColor: Colors.white, // Màu chữ
                      disabledBackgroundColor: AppTheme.primary.withOpacity(0.5), // Màu khi vô hiệu hóa
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)), // Bo tròn mạnh
                       padding: const EdgeInsets.symmetric(vertical: 14) // Điều chỉnh padding nếu cần
                    ),
                    // Text nút giống bản gốc (chưa cần hiển thị count hoặc loading)
                    child: controller.isAdding.value // Có thể thêm loading nếu cần
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                        : const Text(
                            'Done',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
               ),
            ),
          ) // Kết thúc nút Done
        ],
      ),
    );
  }
}