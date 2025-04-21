import 'package:get/get.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  final HomeController controller = Get.put(HomeController());
  final AudioService _audioService = AudioService();
  late final List<Song> _songs = [];
  Song? _currentlyPlaying;

  @override
  bool get wantKeepAlive => true;

  // Khởi tạo và tải dữ liệu
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
          childAspectRatio: 0.3,        // Tỷ lệ khung hình
          // crossAxisSpacing: 0,         // Khoảng cách giữa các cột
          mainAxisSpacing: 30,          // Khoảng cách giữa các hàng
        ),
        itemCount: controller.songs.length > 6 ? 6 : controller.songs.length,
        itemBuilder: (context, index) {
          return _buildSongCard(context, controller.songs[index]);
        },
      )),
    );
  }

  Widget _buildSongCard(BuildContext context, Song song) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
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
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.music_note,
                size: 24,
                color: Colors.grey,
              ),
            )
                : const Icon(
              Icons.music_note,
              size: 24,
              color: Colors.grey,
            ),
          ),
        ),
        title: Text(
          song.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
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


  Widget _buildCategoryItem(
      BuildContext context, String imageUrl, String label, String routeName) {
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
            const SizedBox(height: 5),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textColor = Theme.of(context).textTheme.titleLarge?.color;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: "we_think_you_like".tr,
                  textColor: textColor,
                ),
                SizedBox(
                  height: 225,
                  child: _buildSongGrid(context, controller.songs),
                ),
                Dimes.height20,
                SectionHeader(
                  title: "music_genre".tr,
                  textColor: textColor,
                ),
                SizedBox(
                  height: 122,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-GonKEYBHzuAh2slh-Dw0lGA-t500x500.jpg', 'Pop', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-ZJmK1lnTJZe6oJ95-qXl4lA-t500x500.jpg', 'HipHop', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/avatars-000314373332-ucnx5x-t240x240.jpg', 'EDM', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000252256061-v177r7-t500x500.jpg', 'Jazz', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000434822688-6nltvh-t500x500.jpg', 'Rock', Routes.albumnow),
                    ],
                  ),
                ),
                Dimes.height10,
                SectionHeader(
                  title: "artists".tr,
                  textColor: textColor,
                ),
                SizedBox(
                  height: 122,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/avatars/0/3/3/7/0337e4cc5a05cdcc93b5d65762aea241.jpg', 'Jack - J97', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-Kqc0EeoQXIjYObfm-Fyae3w-t500x500.jpg', 'Phan Mạnh Quỳnh', Routes.albumnow),
                      _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-IYYY8cfvf0zw-0-t500x500.jpg', 'Mr.Siro', Routes.albumnow),
                      _buildCategoryItem(context, 'https://photo-zmp3.zadn.vn/avatars/5/9/6/9/59696c9dba7a914d587d886049c10df6.jpg', 'Sơn Tùng - MTP', Routes.albumnow),
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/cover/3/b/3/3/3b333f6327d95ba9ef3fdabe5a7e1754.jpg', 'The Weeknd', Routes.albumnow),
                    ],
                  ),
                ),
                Dimes.height10,
                SectionHeader(
                  title: "you_might_want_to_hear".tr,
                  textColor: textColor,
                ),
                SizedBox(
                  height: 122,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg', 'For the Brokenhearted', Routes.playlistnow),
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/f/a/f/8/faf8935387e4d248e287ba7a21c8eb01.jpg', 'The Other One', Routes.playlistnow),
                    ],
                  ),
                ),
                Dimes.height10,
                SectionHeader(
                  title: "chill".tr,
                  textColor: textColor,
                ),
                SizedBox(
                  height: 122,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/e/d/5/aed50a8e8fd269117c126d8471bf9319.jpg', 'Mood Healer', Routes.playlistnow),
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/4/d/8/d/4d8d4608e336c270994d31c59ee68179.jpg', 'Top Chill Vibes', Routes.playlistnow),
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/e/2/3/f/e23f4479037d8d9d30e83691a9bf7376.jpg', 'Modern Chill', Routes.playlistnow),
                      _buildCategoryItem(context, 'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/4/5/4/9/45493e859cde749c75fb4377c14d0db3.jpg', 'Addictive Lofi Vibes', Routes.playlistnow),
                    ],
                  ),
                ),
                const SizedBox(height: 80), // Bottom padding
              ],
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
                child: MiniPlayer(          // MiniPlayer được hiện ra, và nó hiện ra tự động là nhờ lắng nghe stream từ player và build lại khi có bài mới được phát
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
                      _currentlyPlaying = returnedSong ?? AudioService().currentSong;     // cập nhật lại bài hát hiện tại đang phát
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
}

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? textColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.textColor,
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
            onPressed: () {
              Get.toNamed(Routes.all_song_view);
            },
            child: Center(
              child: Text(
                "more".tr,
                style: TextStyle(
                  color: effectiveTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}