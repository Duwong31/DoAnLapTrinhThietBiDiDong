import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import '../../../../models/song.dart';
import '../../../routes/app_pages.dart';
import '../bindings/audio_service.dart';
import '../bindings/songs_binding.dart';
import 'songs_view.dart';

class MiniPlayer extends StatefulWidget {
  final Song song;
  final List<Song> songs;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.songs,
    required this.onTap,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  late final AudioService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
  }

  Future<void> _navigateToNowPlaying() async {
    await Get.toNamed(
      Routes.songs_view,
      arguments: {
        'songs': widget.songs,
        'playingSong': widget.song,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return StreamBuilder<Song>(
      stream: _audioService.currentSongStream,
      initialData: widget.song,
      builder: (context, snapshot) {
        final song = snapshot.data ?? widget.song;

        return GestureDetector(
          onTap: _navigateToNowPlaying,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 4 : 6,
              vertical: isSmallScreen ? 0 : 1,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2), // Màu cố định (Orange Light)
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: isSmallScreen ? 5 : 10,
                  blurRadius: isSmallScreen ? 5 : 17,
                ),
              ],
            ),
            child: Row(
              children: [
                StreamBuilder<bool>(
                  stream: _audioService.playerStateStream.map((state) => state.playing),
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return RotationTransition(
                      turns: const AlwaysStoppedAnimation(0),
                      child: Container(
                        width: isSmallScreen ? 20 : 35,
                        height: isSmallScreen ? 20 : 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: song.image.startsWith('http')
                                ? NetworkImage(song.image) as ImageProvider
                                : const AssetImage("assets/image/img.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<bool>(
                        stream: _audioService.playerStateStream.map((state) => state.playing),
                        builder: (context, snapshot) {
                          final isPlaying = snapshot.data ?? false;

                          return isPlaying
                              ? SizedBox(
                            height: isSmallScreen ? 14 : 18,
                            width: double.infinity,
                            child: Marquee(
                              text: song.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 10 : 13,
                                color: Colors.black, // Màu cố định cho tiêu đề
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 20.0,
                              velocity: 30.0,
                              pauseAfterRound: const Duration(seconds: 0),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 0),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: const Duration(milliseconds: 1000),
                              decelerationCurve: Curves.easeOut,
                            ),
                          )
                              : Text(
                            song.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 10 : 13,
                              color: Colors.black, // Màu cố định cho tiêu đề
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: Colors.grey[700], // Màu cố định cho artist
                          fontSize: isSmallScreen ? 8 : 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _audioService.playPreviousSong(),
                  icon: const Icon(Icons.skip_previous_outlined),
                  iconSize: 30,
                ),
                StreamBuilder<bool>(
                  stream: _audioService.playerStateStream.map((state) => state.playing),
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow, // Nếu đang phát nhạc (isPlaying == true) → hiển thị nút pause (Icons.pause) và ngược lại
                        size: 33,
                      ),
                      onPressed: () => _audioService.togglePlayPause(),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => _audioService.playNextSong(),
                  icon: const Icon(Icons.skip_next_outlined),
                  iconSize: 30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
