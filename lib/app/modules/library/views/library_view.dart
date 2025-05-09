import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../routes/app_pages.dart';
import '../../../core/styles/style.dart';
import '../../albums & playlist/views/album_page_view.dart';
import '../../albums & playlist/views/playlist_page_view.dart';
import '../../favorite/bindings/favorite_bindings.dart';
import '../../favorite/controller/favorite_controller.dart';
import '../../favorite/views/favorite_view.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/library_controller.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final LibraryController controller = Get.put(LibraryController());
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>();
  late List<Song> _songs;


  @override
  void initState() {
    super.initState();
    _songs = homeController.songs.toList();
    Get.put(FavoriteController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      _buildMenuItem(context, 'Favorite songs', FavoriteView()),
                      _buildMenuItem(context, 'Playlists', const PlayListView()),
                      _buildMenuItem(context, 'Albums', const AlbumView()),
                      _buildMenuItem(context, 'Following', const FollowView()),
                      _buildMenuItem(context, 'Stations', const StationView()),
                      _buildMenuItem(context, 'Uploads', const UploadView()),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    height: 1,
                    thickness: 0.5,
                    indent: 15,
                    endIndent: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "my_playlist".tr,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text('see_all'.tr,
                                      style: const TextStyle(color: AppTheme.labelColor)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Dimes.height10,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/f/8/8/5/f885e8888832588c8de1c26765a8aa90.jpg',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Dimes.width10,
                            Text(
                              'best_song_of_jack'.tr,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 180),
                    ],
                  ),
                ],
              ),
            ),
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

  Widget _buildMenuItem(BuildContext context, String title, Widget destination) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {
        if (destination is FavoriteView) {
          Get.to(
                () => FavoriteView(),
            binding: FavoriteBinding(),
          );
        } else {
          Get.to(() => destination);
        }
      },
    );
  }
}

class FollowView extends StatelessWidget {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("following".tr)),
    );
  }
}

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("stations".tr)),
    );
  }
}

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("your_uploads".tr)),
    );
  }
}
