import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Keep Get if needed for navigation/state later

import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../../../routes/app_pages.dart';
import '../../profile/widgets/widgets.dart'; // Ensure this path is correct

// Define your colors
const darkTextColor = Colors.black87;
const mediumTextColor = Color(0xFF616161);
const lightGrey = Color(0xFFEEEEEE);

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  // final AudioService _audioService = AudioService();
  final List<Song> _songs = []; // Danh sách bài hát
  Song? _currentlyPlaying;

  @override
  Widget build(BuildContext context) {
    // RxBool isYearlySelected = true.obs; // Keep if you plan to add plan selection back

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar( // Uncomment if you want a close button
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.close, color: Colors.black54),
      //     onPressed: () => Get.back(), // Needs Get package
      //   ),
      // ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- Hero Element ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Replace with your actual logo widget
                    Image.asset(
                      AppImage.logo, // Make sure AppImage.logo path is correct
                      width: 32,
                      // Add errorBuilder for robustness
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.music_note, size: 32, color: AppTheme.primary),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Premium", // Already English
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                Dimes.height15,
                const Text(
                  "Elevate Your Music Experience", // Translated
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'Noto Sans',
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 25),

                // --- Benefits ---
                BoxContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn chỉnh nội dung
                    children: [
                      const Text('Why Premium?', style: TextStyle(fontSize: 18, fontFamily: 'Noto Sans', fontWeight:FontWeight.w800)),
                      Divider(color: lightGrey, thickness: 1,),
                      _buildBenefitItem(Icons.headset_off_outlined, "Ad-Free Listening"),
                      _buildBenefitItem(Icons.download_for_offline_outlined, "Download & Offline Playback"),
                      _buildBenefitItem(Icons.volume_up_outlined, "Highest Audio Quality"),
                      _buildBenefitItem(Icons.skip_next_outlined, "Unlimited Skips"),
                    ],
                  ),
                ),
                Dimes.height50,

                // --- Primary CTA ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 50), // Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {

                  },
                  child: const Text(
                    "GET PREMIUM NOW", // Translated
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // --- Optional: Free Trial ---
                // TextButton(
                //   onPressed: () { /* Handle free trial */ },
                //   child: Text("Or try free for 7 days", style: TextStyle(color: AppTheme.primary)), // Example English text
                // ),
                // const SizedBox(height: 20),

                // --- Footer Links ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () { /* Handle Restore */}, child: const Text("Restore", style: TextStyle(color: mediumTextColor, fontSize: 12))), // Translated
                    TextButton(onPressed: () { /* Handle Terms */}, child: const Text("Terms", style: TextStyle(color: mediumTextColor, fontSize: 12))), // Translated
                    TextButton(onPressed: () { /* Handle Privacy */}, child: const Text("Privacy", style: TextStyle(color: mediumTextColor, fontSize: 12))), // Translated
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
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
                      _currentlyPlaying = returnedSong ?? AudioService().currentSong;
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

  // Helper widget for benefit items
  Widget _buildBenefitItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          const SizedBox(width: 15),
          Expanded( // Use Expanded to prevent text overflow issues
            child: Text(text, style: const TextStyle(fontSize: 16, color: mediumTextColor)),
          ),
        ],
      ),
    );
  }
}