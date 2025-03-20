import 'package:flutter/material.dart';

import '../../common/widgets/appbar/appbar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<Map<String, String>> rankingSongs = [
    {
      "title": "Mất Kết Nối",
      "artist": "Dương Domic",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/8/c/1/6/8c166e2b9a0e45ca9a6c7bef40a81f74.jpg",
    },
    {
      "title": "Tái Sinh",
      "artist": "Tùng Dương",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/0/5/0/1/050158601068bfb3b08fd8da7276a32d.jpg",
    },
    {
      "title": "Cám Ơn Em",
      "artist": "Bằng Thành Chi",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/a/0/6/4/a0648741356edad7c734788c84c18877.jpg",
    },
  ];

  final List<Map<String, String>> suggestions = [
    {
      "title": "Shape of You",
      "artist": "Ed Sheeran",
      "image": "https://avatar-ex-swe.nixcdn.com/song/2023/01/06/2/b/5/e/1672979797915_640.jpg",
    },
    {
      "title": "Save Me",
      "artist": "DEAMN",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/covers/3/9/39247dd8f7a4a85f35647cf2d43d82ea_1487647777.jpg",
    },
    {
      "title": "7 Years",
      "artist": "Lukas Graham",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/covers/f/3/f3ccdd27d2000e3f9255a7e3e2c48800_1480320200.jpg",
    },
    {
      "title": "Nơi Này Có Anh",
      "artist": "Sơn Tùng M-TP",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/covers/c/b/cb61528885ea3cdcd9bdb9dfbab067b1_1504988884.jpg",
    },
    {
      "title": "Mất Kết Nối",
      "artist": "Dương Domic",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/8/c/1/6/8c166e2b9a0e45ca9a6c7bef40a81f74.jpg",
    },
    {
      "title": "Bên Trên Tầng Lầu",
      "artist": "Tăng Duy Tân",
      "image": "https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/covers/c/b/cb61528885ea3cdcd9bdb9dfbab067b1_1504988884.jpg",
    },
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
              // Categories
              Row(
                children: [
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Căn đều 3 container
                children: [
                  _buildCategoryChip("V-pop", [Colors.red, Colors.black]),
                  _buildCategoryChip("US-UK", [Colors.orange, Colors.brown]),
                  _buildCategoryChip("K-pop", [Colors.indigoAccent, Colors.black]),
                ],
              ),



              const SizedBox(height: 20),

              // Ranking
              _buildRankingSection(),

              const SizedBox(height: 20),

              // Suggestions for you
              _buildSuggestionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget danh mục
  Widget _buildCategoryChip(String label, List<Color> gradientColors) {
    return Container(
      width: 120,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Widget bảng xếp hạng
  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ranking", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
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
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(artist, style: const TextStyle(color: Colors.white70)),
      trailing: const Icon(Icons.more_vert, color: Colors.white),
    );
  }

  // Widget gợi ý bài hát
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
        child: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(artist),
      trailing: const Icon(Icons.more_vert, color: Colors.grey),
    );
  }

}
