import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../../../routes/app_pages.dart';
import '../../favorite/controller/favorite_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/widgets/widgets.dart';

const darkTextColor = Colors.black87;
const mediumTextColor = Color(0xFF616161);
const lightGrey = Color(0xFFEEEEEE);

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>();
  late List<Song> _songs;

  @override
  void initState() {
    super.initState();
    _songs = _audioService.currentPlaylist.toList();
    Get.put(FavoriteController());
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0).copyWith(bottom: 80), // Thêm padding bottom để tránh MiniPlayer
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImage.logo,
                      width: 32,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.music_note, size: 32, color: AppTheme.primary),
                    ),
                    Dimes.width8,
                    const Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                Dimes.height15,
                Text(
                  'elevate_music'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                Dimes.height30,
                BoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'why_premium'.tr,
                        style: const TextStyle(
                            color: AppTheme.labelColor,
                            fontSize: 18,
                            fontFamily: 'Noto Sans',
                            fontWeight: FontWeight.w800),
                      ),
                      const Divider(color: lightGrey, thickness: 1),
                      _buildBenefitItem(Icons.headset_off_outlined, 'ad_free'.tr),
                      _buildBenefitItem(Icons.download_for_offline_outlined, 'offline_playback'.tr),
                      _buildBenefitItem(Icons.volume_up_outlined, 'high_quality'.tr),
                      _buildBenefitItem(Icons.skip_next_outlined, 'unlimited_skips'.tr),
                    ],
                  ),
                ),
                Dimes.height50,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {},
                  child: Text(
                    'get_premium_now'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                Dimes.height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Text('restore'.tr,
                            style: const TextStyle(color: mediumTextColor, fontSize: 12))),
                    TextButton(
                        onPressed: () {},
                        child: Text('terms'.tr,
                            style: const TextStyle(color: mediumTextColor, fontSize: 12))),
                    TextButton(
                        onPressed: () {},
                        child: Text('privacy'.tr,
                            style: const TextStyle(color: mediumTextColor, fontSize: 12))),
                  ],
                ),
                Dimes.height30,
              ],
            ),
          ),
          StreamBuilder<Song?>(
            stream: _audioService.currentSongStream,
            builder: (context, snapshot) {
              final currentSong = snapshot.data ?? _audioService.currentSong;
              if (currentSong == null) return const SizedBox.shrink();

              return Positioned(
                left: 8,
                right: 8,
                bottom: 8, // Thay đổi từ 8 thành 16 để tạo khoảng cách với bottom
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
          )
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16, color: mediumTextColor)),
          ),
        ],
      ),
    );
  }
}