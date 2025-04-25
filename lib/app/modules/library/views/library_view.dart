import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../routes/app_pages.dart';
import '../../../core/styles/style.dart';
import '../../albums & playlist/views/album_page_view.dart';
import '../../albums & playlist/views/playlist_page_view.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/library_controller.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final LibraryController controller = Get.put(LibraryController());
  // final AudioService _audioService = AudioService();
  final List<Song> _songs = []; // Danh sách bài hát
  Song? _currentlyPlaying;      // Bài hát hiện tại đang phát

  // Future<void> _navigateToMiniPlayer(Song song, List<Song> allSongs) async {
  //   await _audioService.setPlaylist(allSongs, startIndex: allSongs.indexOf(song));
  //   await _audioService.player.play();
  // }

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
                  // Library list
                  Column(
                    children: [
                      _buildMenuItem(context, 'Liked tracks', const LikeView()),
                      _buildMenuItem(context, 'Playlists', const PlayListView()),
                      _buildMenuItem(context, 'Albums', AlbumView()),
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

                  // Playlist
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My playlist",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to all songs page
                              },
                              child: Container(
                                width: 60,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8E8),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text('See all',
                                      style: TextStyle(
                                          color: AppTheme.labelColor)),
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
                            const Text(
                              'Best song of Jack - J97',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 180), // Chừa chỗ cho MiniPlayer
                    ],
                  ),
                ],
              ),
            ),
          ),

          // MiniPlayer
          StreamBuilder<Song>(
            stream: AudioService().currentSongStream,
            builder: (context, snapshot) {
              final current = snapshot.data ?? AudioService().currentSong;
              if (current == null) return const SizedBox.shrink();
              return Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: MiniPlayer(
                  key: ValueKey(current.id),
                  song: current,
                  songs: _songs,
                  onTap: () async {
                    final returnedSong = await Get.toNamed(
                      Routes.songs_view,
                      arguments: {
                        'playingSong': current,
                        'songs': _songs,
                      },
                    );
                    setState(() {
                      _currentlyPlaying =
                          returnedSong ?? AudioService().currentSong;
                    });
                  },
                ),
              );
            },
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}

// Dummy Views
class LikeView extends StatelessWidget {
  const LikeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Liked tracks")),
    );
  }
}

class FollowView extends StatelessWidget {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Following")),
    );
  }
}

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Stations")),
    );
  }
}

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Your uploads")),
    );
  }
}