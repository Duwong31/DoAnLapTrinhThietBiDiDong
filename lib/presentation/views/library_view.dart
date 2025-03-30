import 'package:flutter/material.dart';

import '../../common/widgets/appbar/appbar.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600 ? 2 : 3; // Điều chỉnh số cột dựa trên độ rộng màn hình

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "Library"),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 600 ? 10 : 20,
            vertical: screenWidth < 600 ? 20 : 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GridView
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return _buildGridItem(item["icon"], item["title"], item["count"], item["color"]);
                },
              ),

              const SizedBox(height: 20),

              // TabBar (Playlist & Album)
              const TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3, color: Colors.blue),
                  insets: EdgeInsets.symmetric(horizontal: 10),
                ),
                tabs: [
                  Tab(text: "Playlist"),
                  Tab(text: "Album"),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: TabBarView(
                  children: [
                    Center(child: Text("Playlist Content", style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16))),
                    Center(child: Text("Album Content", style: TextStyle(fontSize: screenWidth < 600 ? 14 : 16))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Danh sách các mục trong GridView
  final List<Map<String, dynamic>> gridItems = [
    {"icon": Icons.favorite_border, "title": "Liked", "count": "39", "color": Colors.cyanAccent},
    {"icon": Icons.file_download_outlined, "title": "Download", "count": "24", "color": Colors.deepPurpleAccent},
    {"icon": Icons.cloud_upload_outlined, "title": "Upload", "count": "2", "color": Colors.amberAccent},
    {"icon": Icons.ondemand_video_sharp, "title": "MV", "count": "5", "color": Colors.blue},
    {"icon": Icons.personal_injury_outlined, "title": "Artists", "count": "8", "color": Colors.orange},
    {"icon": Icons.book_outlined, "title": "Save", "count": "43", "color": Colors.pink},
  ];

  // Widget tạo Grid Item
  Widget _buildGridItem(IconData icon, String title, String count, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(count, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}
