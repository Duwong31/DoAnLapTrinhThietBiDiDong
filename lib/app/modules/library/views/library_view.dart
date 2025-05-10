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
import '../../albums & playlist/controllers/playlist_page_controller.dart';
import '../../../data/models/playlist.dart';
import '../../../widgets/playlist_cover_widget.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final LibraryController controller = Get.put(LibraryController());
  final PlayListController playlistController = Get.put(PlayListController());
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>();
  late List<Song> _songs;

  @override
  void initState() {
    super.initState();
    _songs = homeController.songs.toList();
    Get.put(FavoriteController());
    playlistController.fetchPlaylists(); // Fetch playlists when view initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          _buildMenuItem(context, 'favorite_songs'.tr, FavoriteView()),
                          _buildMenuItem(context, 'playlists'.tr, const PlayListView()),
                          _buildMenuItem(context, 'Albums', const AlbumView()),
                          _buildMenuItem(context, 'following'.tr, const FollowView()),
                          _buildMenuItem(context, 'stations'.tr, const StationView()),
                          _buildMenuItem(context, 'your_uploads'.tr, const UploadView()),
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
                                  onPressed: () {
                                    Get.toNamed(Routes.playlist);
                                  },
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
                          Obx(() {
                            if (playlistController.isLoadingPlaylists.value) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final playlists = playlistController.playlists.take(3).toList();

                            return Column(
                              children: playlists.map((playlist) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.playlistnow, arguments: playlist);
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: PlaylistCoverWidget(
                                            firstTrackId: playlist.firstTrackId,
                                          ),
                                        ),
                                      ),
                                      Dimes.width10,
                                      Expanded(
                                        child: Text(
                                          playlist.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            );
                          }),
                          const SizedBox(height: 80), // Giảm height để dành chỗ cho MiniPlayer
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        } else if (destination is PlayListView) {
          Get.toNamed(Routes.playlist);
        } else if (destination is AlbumView) {
          Get.toNamed(Routes.album);
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