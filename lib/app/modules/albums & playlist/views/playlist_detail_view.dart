// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_now_view.dart
// (Đổi tên file này thành playlist_now_view.dart nếu bạn muốn thay thế hoàn toàn file cũ,
// hoặc giữ tên PlayListNow và cập nhật route tương ứng trong app_pages.dart)

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import models, controller, style và widget bottom sheet
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart'; // <-- Import model Song chính
import '../../../data/models/playlist.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';
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
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>(); // Lưu dưới dạng biến instance
  late List<Song> _songs;
  bool showTitle = false;
  // *** Lấy instance của PlayListController ***
  final PlayListController _controller = Get.find<PlayListController>();
  // Dữ liệu playlist sẽ được lấy từ arguments
  Playlist? _playlistData;

  @override
  void initState() {
    super.initState();
    _songs = homeController.songs.toList();
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

  // Thêm phương thức để cập nhật tên playlist
  void _updatePlaylistName(Playlist updatedPlaylist) {
    setState(() {
      _playlistData = updatedPlaylist;
    });
  }

  Future<void> _navigateToMiniPlayer(Song song, List<Song> allSongs) async {
    await _audioService.setPlaylist(allSongs, startIndex: allSongs.indexOf(song));
    await _audioService.player.play();
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
      body: Stack(
        children: [
          CustomScrollView(
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
                  playlist.name,
                  style: const TextStyle(color: Colors.black),
                )
                    : null,
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Obx(() => _buildHeader(
                    context,
                    playlist,
                    _controller.songsInCurrentPlaylist.isNotEmpty
                        ? _controller.songsInCurrentPlaylist.first.image
                        : null,
                  )),
                  collapseMode: CollapseMode.parallax,
                ),
                actions: [
                  Obx(() => _controller.isSongListLoading.value
                      ? const Padding(
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download_for_offline_outlined, size: 30, color: Colors.black),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.more_horiz_outlined, size: 30, color: Colors.black),
                                onPressed: () {
                                  _controller.showPlaylistOptionsBottomSheet(context, playlist: playlist);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StreamBuilder<bool>(
                                stream: _audioService.shuffleStream,
                                initialData: _audioService.isShuffle,
                                builder: (context, snapshot) {
                                  final isShuffle = snapshot.data ?? false;
                                  return IconButton(
                                    icon: Icon(
                                      Icons.shuffle,
                                      size: 30,
                                      color: isShuffle ? AppTheme.primary : AppTheme.labelColor,
                                    ),
                                    onPressed: () {
                                      _audioService.setShuffle(!_audioService.isShuffle);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              Obx(() {
                                // Kiểm tra nếu playlist có bài hát thì hiển thị nút play/pause
                                if (_controller.songsInCurrentPlaylist.isNotEmpty) {
                                  return StreamBuilder<bool>(
                                    stream: _audioService.playerStateStream.map((state) => state.playing),
                                    builder: (context, snapshot) {
                                      final isPlaying = snapshot.data ?? false;
                                      return IconButton(
                                        icon: Icon(
                                          isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                                          size: 60,
                                          color: isPlaying ? Colors.orange : Colors.black,
                                        ),
                                        onPressed: () async {
                                          if (!isPlaying && _audioService.currentSong == null) {
                                            // Nếu không có bài hát đang phát, phát bài hát đầu tiên trong playlist
                                            await _audioService.setPlaylist(
                                              _controller.songsInCurrentPlaylist,
                                              startIndex: 0,
                                            );
                                            await _audioService.player.play();
                                          } else {
                                            // Nếu đang phát hoặc có bài hát, toggle play/pause
                                            await _audioService.togglePlayPause();
                                          }
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  // Nếu không có bài hát, không hiển thị nút play/pause
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (_controller.isSongListLoading.value) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                else if (_controller.songsInCurrentPlaylist.isEmpty) {
                  if (playlist.trackIds.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text("This playlist is empty.")),
                    );
                  } else {
                    return const SliverFillRemaining(
                      child: Center(child: Text("Couldn't load songs for this playlist.")),
                    );
                  }
                }
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
                                width: screenWidth * 0.2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _controller.addSongToPlaylist();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                    elevation: 2,
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 26),
                                      SizedBox(width: 2),
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
                        final Song song = _controller.songsInCurrentPlaylist[index - 1];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              song.image,
                              width: 50, height: 50, fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 50, height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.music_note, color: Colors.grey),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 50, height: 50,
                                  color: Colors.grey[200],
                                  child: Center(child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null)),
                                );
                              },
                            ),
                          ),
                          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                          onTap: () => _navigateToMiniPlayer(song, _controller.songsInCurrentPlaylist),
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

          Obx(() {
            // Cập nhật _songs một cách phản ứng khi HomeController.songs thay đổi
            _songs = homeController.songs.toList();
            return StreamBuilder<Song?>(
              stream: AudioService().currentSongStream,
              builder: (context, snapshot) {
                // Cơ chế dự phòng: Nếu StreamBuilder không có dữ liệu, kiểm tra trực tiếp AudioService.currentSong
                Song? currentSong = snapshot.hasData && snapshot.data != null
                    ? snapshot.data
                    : _audioService.currentSong;

                if (currentSong == null) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Dismissible(
                    key: Key('miniplayer_${currentSong.id}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) async {
                      try {
                        await _audioService.stop();
                        _audioService.clearCurrentSong();
                      } catch (e) {
                        debugPrint('SearchView: Lỗi khi dừng âm thanh: $e');
                      }
                    },
                    child: MiniPlayer(
                      song: currentSong,
                      songs: _songs, // Sử dụng danh sách _songs đã cập nhật
                      onTap: () async {
                        final returnedSong = await Get.toNamed(
                          Routes.songs_view,
                          arguments: {'playingSong': currentSong, 'songs': _songs},
                        );
                        if (returnedSong != null) {
                          _audioService.currentSong = returnedSong;
                        }
                      },
                    ),
                  ),
                );
              },
            );
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