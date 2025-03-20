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
    return DefaultTabController(
      length: 2, // Số lượng ta=
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: "Library"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GridView
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildGridItem(Icons.favorite_border, "Liked", "39", Colors.cyanAccent),
                  _buildGridItem(Icons.file_download_outlined, "Download", "24", Colors.deepPurpleAccent),
                  _buildGridItem(Icons.cloud_upload_outlined, "Upload", "2", Colors.amberAccent),
                  _buildGridItem(Icons.ondemand_video_sharp, "MV", "5", Colors.blue),
                  _buildGridItem(Icons.personal_injury_outlined, "Artists", "8", Colors.orange),
                  _buildGridItem(Icons.book_outlined, "Save", "43", Colors.pink),
                ],
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
                    Center(child: Text("Playlist Content")), // Nội dung Playlist
                    Center(child: Text("Album Content")), // Nội dung Album
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm tạo Grid Item
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
