import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../../artists/controllers/artist_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  final HomeController controller = Get.put(HomeController());
  final ArtistController artistController = Get.put(ArtistController());
  final AudioService _audioService = AudioService();

  @override
  bool get wantKeepAlive => true;

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _navigateToMiniPlayer(Song song, List<Song> allSongs) async {
    await _audioService.setPlaylist(allSongs, startIndex: allSongs.indexOf(song));
    await _audioService.player.play();
  }

  Widget _buildSongGrid(BuildContext context, List<Song> songs) {
    return SizedBox(
      height: 120,
      child: Obx(() => GridView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.3,
          mainAxisSpacing: 30,
        ),
        itemCount: controller.songs.length > 6 ? 6 : controller.songs.length,
        itemBuilder: (context, index) {
          return _buildSongCard(context, controller.songs[index]);
        },
      )),
    );
  }

  Widget _buildSongCard(BuildContext context, Song song) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.grey[200],
            child: song.image.isNotEmpty
                ? Image.network(
              song.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note, size: 24, color: Colors.grey),
            )
                : const Icon(Icons.music_note, size: 24, color: Colors.grey),
          ),
        ),
        title: Text(
          song.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: textColor?.withOpacity(0.7),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          if (controller.songs.isNotEmpty) {
            _navigateToMiniPlayer(song, controller.songs);
          } else {
            Get.snackbar('Error', 'No songs available to play');
          }
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String imageUrl, String label, String routeName) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Get.toNamed(routeName),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Dimes.height5,
            SizedBox(
              width: 85,
              child: Text(
                label,
                style: TextStyle(fontSize: 12, color: textColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdBanner(String imageUrl, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textColor = Theme.of(context).textTheme.titleLarge?.color;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: "we_think_you_like".tr, textColor: textColor, route: Routes.all_song_view),
                SizedBox(height: 225, child: _buildSongGrid(context, controller.songs)),

                Dimes.height10,

                // QUẢNG CÁO BANNER 1
                _buildAdBanner('https://tongweivietnam.com/wp-content/uploads/2025/03/hello88-%E2%80%93-cai-ten-khong-phai-dang-vua-trong-lang-ca-cuoc.jpg',
                    onTap: () => _launchURL('https://mcafee6.uk.net/'),
                ),

                SectionHeader(title: "music_genre".tr, textColor: textColor, route: Routes.genre),
                SizedBox(
                  height: 122,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-GonKEYBHzuAh2slh-Dw0lGA-t500x500.jpg', 'Pop', Routes.albumnow),
                    _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-ZJmK1lnTJZe6oJ95-qXl4lA-t500x500.jpg', 'HipHop', Routes.albumnow),
                    _buildCategoryItem(context, 'https://i1.sndcdn.com/avatars-000314373332-ucnx5x-t240x240.jpg', 'EDM', Routes.albumnow),
                    _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000252256061-v177r7-t500x500.jpg', 'Jazz', Routes.albumnow),
                    _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000434822688-6nltvh-t500x500.jpg', 'Rock', Routes.albumnow),
                  ]),
                ),
                Dimes.height10,

                // QUẢNG CÁO BANNER 1
                _buildAdBanner('https://lh7-us.googleusercontent.com/docsz/AD_4nXezl_SrxAm9dKv-wMeFKThHwP6U7Np5w7KUVGjJa8-8R00MribXOdkm17HXQJid_wJM7i4xAmB-Oz0K9J1nEhqBLNsUzLGxA8EBXNPKDQ64I1l9YV5DP0UuGcgOcarXWiJU5qOG2NMCIVOmwABdYzYx1ESG?key=jR9BtSOkPttHBYWeWMkvrA',
                    onTap: () => _launchURL('https://3okvip.info/'),
                ),

                SectionHeader(title: "artists".tr, textColor: textColor, route: Routes.artist),
                SizedBox(
                  height: 122,
                  child: Obx(() {
                    if (artistController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (artistController.artistList.isEmpty) {
                      return const Center(child: Text('No artists found'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: artistController.artistList.length >= 4 ? 4 : artistController.artistList.length,
                      itemBuilder: (context, index) {
                        final artist = artistController.artistList[index];
                        return _buildCategoryItem(
                            context,
                            artist.imageUrl ?? '',
                            artist.name ?? '',
                            Routes.albumnow);
                      },
                    );
                  }),
                ),

                Dimes.height10,
                SectionHeader(title: "you_might_want_to_hear".tr, textColor: textColor, route: Routes.playlist),
                SizedBox(
                  height: 122,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg', 'For the Brokenhearted', Routes.playlistnow),
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/f/a/f/8/faf8935387e4d248e287ba7a21c8eb01.jpg', 'The Other One', Routes.playlistnow),
                  ]),
                ),

                Dimes.height10,
                SectionHeader(title: "chill".tr, textColor: textColor, route: Routes.playlist),
                SizedBox(
                  height: 122,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/e/d/5/aed50a8e8fd269117c126d8471bf9319.jpg', 'Mood Healer', Routes.playlistnow),
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/4/d/8/d/4d8d4608e336c270994d31c59ee68179.jpg', 'Top Chill Vibes', Routes.playlistnow),
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/e/2/3/f/e23f4479037d8d9d30e83691a9bf7376.jpg', 'Modern Chill', Routes.playlistnow),
                    _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/4/5/4/9/45493e859cde749c75fb4377c14d0db3.jpg', 'Addictive Lofi Vibes', Routes.playlistnow),
                  ]),
                ),

                Dimes.height10,
              ],
            ),
          ),

          // MiniPlayer
          StreamBuilder<Song?>(
            stream: AudioService().currentSongStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return const SizedBox.shrink();
              }
              final currentSong = snapshot.data!;
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
                    songs: _audioService.currentPlaylist, // Sử dụng danh sách phát của AudioService
                    onTap: () async {
                      final returnedSong = await Get.toNamed(
                        Routes.songs_view,
                        arguments: {'playingSong': currentSong, 'songs': _audioService.currentPlaylist},
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

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? textColor;
  final String route;

  const SectionHeader({
    super.key,
    required this.title,
    this.textColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? Theme.of(context).textTheme.titleMedium?.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppTheme.primary,
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(route),
            child: Center(
              child: Text(
                "more".tr,
                style: TextStyle(color: effectiveTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
