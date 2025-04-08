import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
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

  // Widget bài hát dạng ô đơn giản
  Widget _buildSongCard(Song song) {
    return Card(
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Center(
        child: Icon(Icons.music_note, color: Colors.white, size: 40),
      ),
    );
  }

  // Grid view bài hát
  Widget _buildSongGrid(List<Song> songs) {
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
        return _buildSongCard(song);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // we think you'll like
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "We think you'll like",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.labelColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "More",
                          style: TextStyle(color: AppTheme.labelColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Song grid
            SizedBox(
              height: 200,
              child: _buildSongGrid(sampleSongs),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Music genre",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.labelColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Text(
                          "More",
                          style: TextStyle(color: AppTheme.labelColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Music genres - Horizontal scroll
            SizedBox(
              height: 106,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-GonKEYBHzuAh2slh-Dw0lGA-t500x500.jpg', 'Pop', const PopView()),
                  _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-ZJmK1lnTJZe6oJ95-qXl4lA-t500x500.jpg', 'HipHop', const HipHopView()),
                  _buildCategoryItem(context, 'https://i1.sndcdn.com/avatars-000314373332-ucnx5x-t240x240.jpg', 'EDM', const EDMView()),
                  _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000252256061-v177r7-t500x500.jpg', 'Jazz', const JazzView()),
                  _buildCategoryItem(context, 'https://i1.sndcdn.com/artworks-000434822688-6nltvh-t500x500.jpg', 'Rock', const JazzView()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for each genre item
Widget _buildCategoryItem(
    BuildContext context,
    String imageUrl,
    String label,
    Widget destination,
    ) {
  return Container(
    width: 85,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      // color: AppTheme.primary,
      color: Colors.white,
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
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 85,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 15, color: AppTheme.labelColor)),
        ],
      ),
    ),
  );
}








// Genre Views Below

class PopView extends StatelessWidget {
  const PopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pop")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.music_note), title: Text("Pop Song 1")),
          ListTile(leading: Icon(Icons.music_note), title: Text("Pop Song 2")),
          ListTile(leading: Icon(Icons.music_note), title: Text("Pop Song 3")),
        ],
      ),
    );
  }
}

class HipHopView extends StatelessWidget {
  const HipHopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HipHop")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.music_note), title: Text("HipHop Track 1")),
          ListTile(leading: Icon(Icons.music_note), title: Text("HipHop Track 2")),
          ListTile(leading: Icon(Icons.music_note), title: Text("HipHop Track 3")),
        ],
      ),
    );
  }
}

class EDMView extends StatelessWidget {
  const EDMView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("EDM")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.music_note), title: Text("EDM Banger 1")),
          ListTile(leading: Icon(Icons.music_note), title: Text("EDM Banger 2")),
          ListTile(leading: Icon(Icons.music_note), title: Text("EDM Banger 3")),
        ],
      ),
    );
  }
}

class JazzView extends StatelessWidget {
  const JazzView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jazz")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          ListTile(leading: Icon(Icons.music_note), title: Text("Jazz Tune 1")),
          ListTile(leading: Icon(Icons.music_note), title: Text("Jazz Tune 2")),
          ListTile(leading: Icon(Icons.music_note), title: Text("Jazz Tune 3")),
        ],
      ),
    );
  }
}
