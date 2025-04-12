import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

// Dummy Song model
class Song {
  final String title;
  final String artist;

  Song({required this.title, required this.artist});
}

// Dummy search of songs
final List<Song> sampleSongs = [
  Song(title: 'Song 1', artist: 'Artist A'),
  Song(title: 'Song 2', artist: 'Artist B'),
  Song(title: 'Song 3', artist: 'Artist C'),
  Song(title: 'Song 4', artist: 'Artist D'),
  Song(title: 'Song 5', artist: 'Artist E'),
  Song(title: 'Song 6', artist: 'Artist F'),
];

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  Widget _buildSongCard(BuildContext context, Song song) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildSongGrid(BuildContext context, List<Song> songs) {
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: songs.length > 6 ? 6 : songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return _buildSongCard(context, song);
      },
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
    final textColor = Theme.of(context).textTheme.titleLarge?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: "we_think_you_like".tr,
              textColor: textColor,
              onMorePressed: () {},
            ),
            SizedBox(
              height: 200,
              child: _buildSongGrid(context, sampleSongs),
            ),
            Dimes.height10,

            SectionHeader(
              title: "music_genre".tr,
              textColor: textColor,
              onMorePressed: () {},
            ),
            SizedBox(
              height: 122,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-GonKEYBHzuAh2slh-Dw0lGA-t500x500.jpg', 'Pop', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-ZJmK1lnTJZe6oJ95-qXl4lA-t500x500.jpg', 'HipHop', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/avatars-000314373332-ucnx5x-t240x240.jpg', 'EDM', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-000252256061-v177r7-t500x500.jpg', 'Jazz', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-000434822688-6nltvh-t500x500.jpg', 'Rock', Routes.album),
                ],
              ),
            ),
            Dimes.height10,

            SectionHeader(
              title: "artists".tr,
              textColor: textColor,
              onMorePressed: () {},
            ),
            SizedBox(
              height: 122,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/avatars/0/3/3/7/0337e4cc5a05cdcc93b5d65762aea241.jpg', 'Jack - J97', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-Kqc0EeoQXIjYObfm-Fyae3w-t500x500.jpg', 'Phan Mạnh Quỳnh', Routes.album),
                  _buildCategoryItem(context,
                      'https://i1.sndcdn.com/artworks-IYYY8cfvf0zw-0-t500x500.jpg', 'Mr.Siro', Routes.album),
                  _buildCategoryItem(context,
                      'https://photo-zmp3.zadn.vn/avatars/5/9/6/9/59696c9dba7a914d587d886049c10df6.jpg', 'Sơn Tùng - MTP', Routes.album),
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/cover/3/b/3/3/3b333f6327d95ba9ef3fdabe5a7e1754.jpg', 'The Weeknd', Routes.album),
                ],
              ),
            ),
            Dimes.height10,

            SectionHeader(
              title: "you_might_want_to_hear".tr,
              textColor: textColor,
              onMorePressed: () {},
            ),
            SizedBox(
              height: 122,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg', 'For the Brokenhearted', Routes.playlist),
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/f/a/f/8/faf8935387e4d248e287ba7a21c8eb01.jpg', 'The Other One', Routes.playlist),
                ],
              ),
            ),
            Dimes.height10,

            SectionHeader(
              title: "chill".tr,
              textColor: textColor,
              onMorePressed: () {},
            ),
            SizedBox(
              height: 122,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/e/d/5/aed50a8e8fd269117c126d8471bf9319.jpg', 'Mood Healer', Routes.playlist),
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/4/d/8/d/4d8d4608e336c270994d31c59ee68179.jpg', 'Top Chill Vibes', Routes.playlist),
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zmdcdn.me/w240_r1x1_jpeg/cover/e/2/3/f/e23f4479037d8d9d30e83691a9bf7376.jpg', 'Modern Chill', Routes.playlist),
                  _buildCategoryItem(context,
                      'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/4/5/4/9/45493e859cde749c75fb4377c14d0db3.jpg', 'Addictive Lofi Vibes', Routes.playlist),
                ],
              ),
            ),
            Dimes.height10,
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onMorePressed;
  final Color? textColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onMorePressed,
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
            onPressed: onMorePressed,
            child:  Center(
                child: Text(
                  "more".tr,
                  style: TextStyle(color: effectiveTextColor, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
