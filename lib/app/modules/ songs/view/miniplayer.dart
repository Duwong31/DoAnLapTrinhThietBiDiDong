import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../../../routes/app_pages.dart';
import '../../favorite/controller/favorite_controller.dart';
import '../bindings/audio_service.dart';

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
  final AudioService _audioService = Get.find<AudioService>();
  late final FavoriteController _favoriteController = Get.put(FavoriteController());
  late Song _currentSong;

  @override
  void initState() {
    super.initState();
    _currentSong = widget.song;
  }

  Future<void> _navigateToNowPlaying() async {
    await Get.toNamed(
      Routes.songs_view,
      arguments: {
        'songs': widget.songs,
        'playingSong': _currentSong,
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
        _currentSong = song;

        return GestureDetector(
          onTap: _navigateToNowPlaying,
          child: Container(
            width: screenWidth - 16, // Giới hạn chiều rộng theo màn hình, trừ padding
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 4 : 6,
              vertical: isSmallScreen ? 0 : 1,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE0B2),
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
                    return Container(
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
                    );
                  },
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded( // Sử dụng Expanded để quản lý không gian cho Column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: isSmallScreen ? 14 : 18,
                        child: Marquee(
                          text: song.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isSmallScreen ? 10 : 13,
                            color: Colors.black,
                          ),
                          blankSpace: 50.0,
                          velocity: 55.0,
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                        ),
                      ),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: isSmallScreen ? 8 : 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  final isFavorite = _favoriteController.isFavorite(_currentSong.id);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppTheme.labelColor ?? Colors.black,
                      size: 26,
                    ),
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      try {
                        await _favoriteController.toggleFavorite(_currentSong.id);
                        // Thông báo khi thay đổi trạng thái
                        // Get.snackbar(
                        //   isFavorite ? 'Đã xóa khỏi yêu thích' : 'Đã thêm vào yêu thích',
                        //   '${_currentSong.title} ${isFavorite ? 'đã được xóa' : 'đã được thêm'}',
                        //   snackPosition: SnackPosition.TOP,
                        //   backgroundColor: isFavorite ? Colors.red[800] : Colors.green[800],
                        //   colorText: Colors.white,
                        //   margin: const EdgeInsets.all(10),
                        //   icon: Icon(isFavorite ? Icons.favorite_border : Icons.favorite, color: Colors.white),
                        // );
                      } catch (e) {
                        Get.snackbar(
                          'Lỗi',
                          'Không thể cập nhật trạng thái yêu thích',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                  );
                }),
                IconButton(
                  onPressed: () => _audioService.playPreviousSong(),
                  icon: SvgPicture.asset(
                    AppImage.previousSong,
                    height: 35,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _audioService.playerStateStream.map((state) => state.playing),
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: SvgPicture.asset(
                        isPlaying ? AppImage.pauseSong : AppImage.playSong,
                        height: 35,
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => _audioService.togglePlayPause(),
                    );
                  },
                ),
                IconButton(
                  onPressed: () => _audioService.playNextSong(),
                  icon: SvgPicture.asset(
                    AppImage.nextSong,
                    height: 35,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}