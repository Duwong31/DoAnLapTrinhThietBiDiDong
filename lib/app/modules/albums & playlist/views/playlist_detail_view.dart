// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_now_view.dart
// (Đổi tên file này thành playlist_now_view.dart nếu bạn muốn thay thế hoàn toàn file cũ,
// hoặc giữ tên PlayListNow và cập nhật route tương ứng trong app_pages.dart)

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import models, controller, style và widget bottom sheet
import '../../../../models/song.dart'; // <-- Import model Song chính
import '../../../data/models/playlist.dart';
import '../controllers/playlist_page_controller.dart';
import '../../../core/styles/style.dart'; // <-- Cho Dimes (nếu dùng)
// import '../../../widgets/bottom_song_options.dart'; // Đảm bảo import đúng nếu dùng SongOptionsSheet

class PlayListNow extends StatefulWidget {
  const PlayListNow({Key? key}) : super(key: key);

  @override
  State<PlayListNow> createState() => _PlayListNowState();
}

class _PlayListNowState extends State<PlayListNow> {
  final scrollController = ScrollController();
  bool showTitle = false;
  // *** Lấy instance của PlayListController ***
  final PlayListController _controller = Get.find<PlayListController>();
  // Dữ liệu playlist sẽ được lấy từ arguments
  Playlist? _playlistData;

  @override
  void initState() {
    super.initState();
    // Lấy arguments và xử lý lỗi
    try {
      // Lấy dữ liệu Playlist được truyền qua arguments
      _playlistData = Get.arguments as Playlist?;
      print("PlayListNow initState: Received arguments: $_playlistData");
      if (_playlistData == null) {
        throw Exception("Playlist data is null."); // Ném lỗi nếu data null
      }

      // *** Gọi hàm fetch bài hát sau khi frame đầu tiên được build ***
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _playlistData != null) {
          print("PlayListNow initState: Calling fetchSongsForPlaylist with: ${_playlistData!.name}");
          _controller.fetchSongsForPlaylist(_playlistData!);
        }
      });

    } catch (e) {
      print("PlayListNow initState: Error getting arguments or calling fetch: $e");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Get.back(); // Quay lại màn hình trước
          Get.snackbar(
            "Error",
            "Could not load playlist details.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      });
    }

    // Listener cho scroll để hiển thị/ẩn title trên AppBar
    scrollController.addListener(() {
      const double threshold = 200.0;
      if (scrollController.offset > threshold && !showTitle) {
        if (mounted) {
          setState(() {
            showTitle = true;
          });
        }
      } else if (scrollController.offset <= threshold && showTitle) {
        if (mounted) {
          setState(() {
            showTitle = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _controller.songsInCurrentPlaylist.clear();
    _controller.isSongListLoading(false); // Reset trạng thái loading
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_playlistData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: Get.back),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: Text("Playlist details not available.")),
      );
    }

    final playlist = _playlistData!;

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
              onPressed: () => Get.back(),
            ),
            title: showTitle
                ? Text(
                    playlist.name, // Sử dụng tên playlist từ data
                    style: const TextStyle(color: Colors.black),
                  )
                : null,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              // *** Sử dụng Obx để cập nhật header khi có ảnh ***
              background: Obx(() => _buildHeader(
                    context,
                    playlist,
                    // Lấy ảnh của bài hát đầu tiên làm ảnh playlist nếu có
                    _controller.songsInCurrentPlaylist.isNotEmpty
                        ? _controller.songsInCurrentPlaylist.first.image
                        : null, // Hoặc ảnh mặc định nếu muốn
                  )),
              collapseMode: CollapseMode.parallax,
            ),
            // *** Thêm nút Refresh vào actions ***
             actions: [
               Obx(() => _controller.isSongListLoading.value
                 ? const Padding( // Hiển thị loading nhỏ thay cho nút refresh khi đang tải
                     padding: EdgeInsets.only(right: 16.0),
                     child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.0))))
                 : IconButton(
                     icon: const Icon(Icons.refresh, color: Colors.black),
                     tooltip: 'Refresh Songs',
                     onPressed: () => _controller.fetchSongsForPlaylist(playlist),
                   ),
               ),
             ],
          ),
          // SliverToBoxAdapter cho các nút action (giữ nguyên)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nhóm bên trái
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.download_for_offline_outlined, size: 30, color: Colors.black),
                            onPressed: () {
                            },
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.more_horiz_outlined, size: 30, color: Colors.black),
                            onPressed: () {
                              _controller.showPlaylistOptionsBottomSheet(context, playlist: playlist);

                            },
                          ),
                        ],
                      ),
                      // Nhóm bên phải
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.shuffle, size: 30, color: Colors.black),
                            onPressed: () {
                              // TODO: Kích hoạt phát ngẫu nhiên
                              print("Shuffle icon pressed");
                            },
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.play_circle_outline, size: 60, color: Colors.black),
                            onPressed: () {
                              // TODO: Phát tất cả bài hát
                              print("Play icon pressed");
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          // *** Sử dụng Obx để hiển thị trạng thái loading, lỗi hoặc danh sách bài hát ***
          Obx(() {
            // --- Trường hợp đang loading ---
            if (_controller.isSongListLoading.value) {
              return const SliverFillRemaining( // Sử dụng SliverFillRemaining để chiếm không gian còn lại
                child: Center(child: CircularProgressIndicator()),
              );
            }
            // --- Trường hợp load xong nhưng không có bài hát ---
            else if (_controller.songsInCurrentPlaylist.isEmpty) {
              // Kiểm tra xem playlist gốc có trackIds không
              if (playlist.trackIds.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("This playlist is empty.")),
                );
              } else {
                // Có trackIds nhưng không load được bài hát (lỗi API, ID sai, ...)
                return const SliverFillRemaining(
                  child: Center(child: Text("Couldn't load songs for this playlist.")),
                );
              }
            }
            // --- Trường hợp load thành công và có bài hát ---
            else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 8),
                          child: SizedBox(
                            width: screenWidth * 0.2, // 👈 chỉnh width tùy ý
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.addSongToPlaylist(); // Gọi hàm thêm bài hát vào playlist
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                elevation: 2,
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min, // Để giữ mọi thứ gọn lại
                                children: [
                                  Icon(Icons.add, size: 26),
                                  SizedBox(width: 2), // Điều chỉnh khoảng cách giữa icon và text
                                  Text(
                                    'Add',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // Lấy dữ liệu bài hát thật từ controller
                    final Song song = _controller.songsInCurrentPlaylist[index - 1];

                    // Sử dụng ListTile gốc, nhưng với dữ liệu thật
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          song.image, // Ảnh của bài hát
                          width: 50, height: 50, fit: BoxFit.cover,
                          // Error builder cho ảnh bài hát
                          errorBuilder: (c, e, s) => Container(
                            width: 50, height: 50,
                            color: Colors.grey[200],
                            child: const Icon(Icons.music_note, color: Colors.grey),
                          ),
                          // Loading builder cho ảnh bài hát
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
                      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis), // Giả sử artist không null theo model Song
                      onTap: () {
                        // TODO: Implement logic phát nhạc khi nhấn vào bài hát
                        print('Play song: ${song.title} (ID: ${song.id})');
                        // Ví dụ: Get.find<AudioPlayerController>().playSong(song, _controller.songsInCurrentPlaylist);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'Song options',
                        onPressed: () {
                          _controller.showSongOptionsBottomSheet(context, songData: song);
                        },
                      ),
                    );
                  },
                  childCount: _controller.songsInCurrentPlaylist.length + 1,
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  // Widget _buildHeader được cập nhật để nhận imageUrl tùy chọn
  Widget _buildHeader(BuildContext context, Playlist playlist, String? imageUrl) {
    // Lấy URL ảnh (từ bài hát đầu tiên hoặc null)
    final String? displayImageUrl = imageUrl;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), // Giữ padding gốc
      decoration: const BoxDecoration( // Thêm decoration để có thể làm gradient nếu muốn
         color: Colors.white, // Màu nền gốc
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Căn dưới cùng cho dễ nhìn khi collapse
        crossAxisAlignment: CrossAxisAlignment.start, // Căn giữa các thành phần con
        children: [
          Center(
          child: SizedBox(
            width: 180, // Điều chỉnh kích thước nếu cần
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Bo tròn nhiều hơn một chút
              child: displayImageUrl != null && displayImageUrl.isNotEmpty
                  ? Image.network(
                      displayImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container( // Placeholder khi đang loading ảnh
                          color: Colors.grey[300],
                           child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                           ),
                        );
                      },
                    )
                  : _buildImagePlaceholder(), // Hiển thị placeholder nếu không có ảnh
            ),
          ),
          ),
          const SizedBox(height: 15), // Khoảng cách
          // Tên playlist
          Text(
            playlist.name, // Sử dụng tên động từ playlist
            style: const TextStyle(
              fontSize: 22, // Tăng cỡ chữ một chút
              fontWeight: FontWeight.bold,
              color: Colors.black87, // Màu chữ đậm hơn
            ),
            textAlign: TextAlign.left, // Căn giữa text
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Có thể thêm thông tin khác nếu cần (ví dụ: số lượng bài hát)
           Obx(() => Text(
                '${_controller.songsInCurrentPlaylist.length} songs', // Hiển thị số lượng bài hát (cập nhật động)
                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                 maxLines: 1,
              ),
            ),
          const SizedBox(height: 10), // Khoảng cách dưới cùng trong header
        ],
      ),
    );
  }

  // Widget con để tạo placeholder cho ảnh
  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity, // Chiếm hết không gian cha
      height: double.infinity,
      color: Colors.grey[300], // Màu nền placeholder
      child: const Icon(
        Icons.music_note, // Icon nhạc
        size: 80, // Kích thước icon
        color: Colors.grey, // Màu icon
      ),
    );
  }
}