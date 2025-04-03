import 'package:flutter/material.dart';

import '../../common/widgets/appbar/appbar.dart';
import '../../core/configs/theme/app_colors.dart';
import '../songs/all_songs_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> rankingSongs = [];
  final List<Map<String, String>> suggestions = [];
  final List<Map<String, dynamic>> categories = [
    {"label": "V-pop", "colors": [Colors.red, Colors.black]},
    {"label": "US-UK", "colors": [Colors.orange, Colors.brown]},
    {"label": "K-pop", "colors": [Colors.indigoAccent, Colors.black]},
    {"label": "Rap", "colors": [Colors.yellow, Colors.brown]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Discovery"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _buildCategoryChip(
                        categories[index]["label"],
                        List<Color>.from(categories[index]["colors"]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildAllMusicSection(),
              const SizedBox(height: 20),
              _buildSuggestionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, List<Color> gradientColors) {
    return Container(
      width: 120,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildAllMusicSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Songs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllSongsView()),
                );
              },
              child: const Text(
                "More",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.black]),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: rankingSongs.asMap().entries.map((entry) {
              int index = entry.key + 1;
              var song = entry.value;
              return _buildRankingItem(index, song["title"]!, song["artist"]!, song["image"]!);
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildRankingItem(int rank, String title, String artist, String imageUrl) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(artist, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.more_vert, color: Colors.white),
    );
  }

  Widget _buildSuggestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Suggestions for you", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: const Text("Refresh", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            var song = suggestions[index];
            return _buildSuggestionItem(song["title"]!, song["artist"]!, song["image"]!);
          },
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(String title, String artist, String imageUrl) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(artist),
      trailing: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
