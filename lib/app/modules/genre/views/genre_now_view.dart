import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../routes/app_pages.dart';
import '../../../../models/song.dart';
import '../controllers/genre_controller.dart';

class GenreNowView extends StatefulWidget {
  const GenreNowView({super.key});

  @override
  State<GenreNowView> createState() => _GenreNowViewState();
}

class _GenreNowViewState extends State<GenreNowView> {
  final GenreController controller = Get.find<GenreController>();
  late final AudioService _audioService;
  String genre = 'Unknown Genre';

  @override
  void initState() {
    super.initState();
    _audioService = Get.find<AudioService>();
    genre = Get.arguments as String? ?? 'Unknown Genre';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          genre, // Hiển thị tên thể loại nhạc
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Danh sách bài hát theo thể loại
          Obx(() {
            if (controller.isGenreLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.songsByGenre.isEmpty) {
              return const Center(child: Text('No songs found in this genre'));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80), // Space for MiniPlayer
              itemCount: controller.songsByGenre.length,
              itemBuilder: (context, index) {
                final song = controller.songsByGenre[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.music_note),
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    song.artist,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    _audioService.setPlaylist(controller.songsByGenre, startIndex: index);
                    _audioService.player.play();
                  },
                );
              },
            );
          }),

          // MiniPlayer
          StreamBuilder<Song?>(
            stream: _audioService.currentSongStream,
            builder: (context, snapshot) {
              Song? currentSong = snapshot.data ?? _audioService.currentSong;

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
                      debugPrint('Error stopping audio: $e');
                    }
                  },
                  child: MiniPlayer(
                    song: currentSong,
                    songs: _audioService.currentPlaylist,
                    onTap: () async {
                      final returnedSong = await Get.toNamed(
                        Routes.songs_view,
                        arguments: {
                          'playingSong': currentSong,
                          'songs': _audioService.currentPlaylist
                        },
                      );
                      if (returnedSong != null) {
                        _audioService.currentSong = returnedSong;
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}