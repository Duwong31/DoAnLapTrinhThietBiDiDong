// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import models, controller, widgets
import '../../../../models/song.dart';
import '../../../data/models/playlist.dart';
import '../../../widgets/playlist_cover_widget.dart'; // Widget hiển thị ảnh bìa
import '../controllers/playlist_page_controller.dart'; // Sử dụng controller chung
import '../../../core/styles/style.dart';
import '../../../widgets/bottom_song_options.dart';

class PlayListNow extends StatefulWidget {
  const PlayListNow({Key? key}) : super(key: key);

  @override
  State<PlayListNow> createState() => _PlayListNowState();
}

class _PlayListNowState extends State<PlayListNow> {
  final scrollController = ScrollController();
  bool showTitle = false;
  // Lấy instance Controller
  final PlayListController controller = Get.find<PlayListController>();
  Playlist? _playlistData; // Dữ liệu playlist nhận từ arguments

  @override
  void initState() {
    super.initState();
    // Lấy dữ liệu playlist từ arguments
    try {
      _playlistData = Get.arguments as Playlist?;
      if (_playlistData != null) {
        // *** QUAN TRỌNG: Gọi hàm fetch bài hát khi có dữ liệu playlist ***
        controller.fetchSongsForPlaylist(_playlistData!);
      } else {
        // Xử lý trường hợp không nhận được arguments playlist
        _handleArgumentError();
      }
    } catch (e) {
      print("Error getting playlist arguments: $e");
      _handleArgumentError();
    }

    // Scroll listener
    scrollController.addListener(() {
      const double threshold = 200.0;
      final offset = scrollController.offset;
      final shouldShow = offset > threshold;
      if (showTitle != shouldShow) {
        if (mounted) {
          setState(() {
            showTitle = shouldShow;
          });
        }
      }
    });
  }

  // Hàm xử lý lỗi arguments
  void _handleArgumentError() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.back();
        Get.snackbar(
          "Error", "Could not load playlist details.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent, colorText: Colors.white
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    // Cân nhắc việc clear danh sách bài hát khi thoát màn hình chi tiết
    // controller.songsInCurrentPlaylist.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nếu không có dữ liệu playlist (đã xử lý ở initState nhưng kiểm tra lại cho chắc)
    if (_playlistData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Playlist details not available.")),
      );
    }
    // Đảm bảo playlist không null từ đây
    final playlist = _playlistData!;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // --- SliverAppBar ---
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: AnimatedOpacity( // Thêm hiệu ứng mờ dần cho title
               opacity: showTitle ? 1.0 : 0.0,
               duration: const Duration(milliseconds: 300),
               child: Text(playlist.name, style: const TextStyle(color: Colors.black)),
             ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(context, playlist), // Header với ảnh bìa
              collapseMode: CollapseMode.parallax,
            ),
          ),
          // --- Các nút Actions ---
          const SliverToBoxAdapter(
             // ... code các nút giữ nguyên ...
          ),

          // --- Danh sách bài hát ---
          // Sử dụng Obx để lắng nghe cả isLoading và danh sách bài hát
          Obx(() {
             // --- Trạng thái Loading bài hát ---
             if (controller.isSongListLoading.value) {
               return const SliverFillRemaining( // Widget chiếm hết phần còn lại
                 child: Center(child: CircularProgressIndicator()),
               );
             }

             // --- Trạng thái Không có bài hát ---
             if (controller.songsInCurrentPlaylist.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No songs in this playlist yet.")),
                );
             }

             // --- Hiển thị danh sách bài hát ---
             final songs = controller.songsInCurrentPlaylist; // Lấy list bài hát
             return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final Song currentSong = songs[index]; // Lấy bài hát hiện tại

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        // Lấy ảnh từ bài hát hiện tại
                        currentSong.image.isNotEmpty
                            ? currentSong.image
                            : 'assets/images/default_song_icon.png', // Ảnh mặc định cho bài hát
                        width: 50, height: 50, fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 50, height: 50,
                          color: Colors.grey[200],
                          child: const Icon(Icons.music_note, color: Colors.grey)
                        ),
                         loadingBuilder: (context, child, loadingProgress) {
                             if (loadingProgress == null) return child;
                             return Container(
                                width: 50, height: 50,
                                color: Colors.grey[200],
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2.0, value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null)),
                             );
                           },
                      ),
                    ),
                    title: Text(currentSong.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(currentSong.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      // TODO: Phát nhạc currentSong
                      print('Play song: ${currentSong.title}');
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      tooltip: 'Song options',
                      onPressed: () {
                        // Gọi bottom sheet, truyền bài hát hiện tại
                        controller.showSongOptionsBottomSheet(context, songData: currentSong);
                      },
                    ),
                  );
                },
                childCount: songs.length, // Số lượng bài hát thực tế
              ),
            );
          }), // Kết thúc Obx
        ],
      ),
    );
  }

  // Widget Header (sử dụng PlaylistCoverWidget)
  Widget _buildHeader(BuildContext context, Playlist playlist) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20), // Tăng padding top
      decoration: BoxDecoration( // Thêm gradient nhẹ cho đẹp
         gradient: LinearGradient(
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter,
           colors: [Colors.grey[200]!, Colors.white],
           stops: const [0.0, 0.6]
         )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 180, // Điều chỉnh kích thước nếu muốn
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Bo tròn nhiều hơn
              // *** SỬ DỤNG PlaylistCoverWidget ***
              child: PlaylistCoverWidget(firstTrackId: playlist.firstTrackId),
            ),
          ),
          const SizedBox(height: 15),
          Text( // Đặt Text trong Container để giới hạn chiều rộng nếu cần
            playlist.name,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), // Dùng style từ Theme
            textAlign: TextAlign.center, // Căn giữa
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Có thể thêm Text hiển thị số lượng bài hát
          Obx(() => Opacity( // Ẩn/hiện số lượng bài hát
               opacity: controller.songsInCurrentPlaylist.isNotEmpty ? 0.6 : 0.0,
               child: Text(
                 "${controller.songsInCurrentPlaylist.length} songs",
                 style: Theme.of(context).textTheme.bodySmall,
               ),
             ),
          )
        ],
      ),
    );
  }
}