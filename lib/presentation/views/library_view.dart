import 'package:flutter/material.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../core/configs/theme/app_colors.dart';
import '../library_catalog/artists_view.dart';
import '../library_catalog/download_view.dart';
import '../library_catalog/liked_view.dart';
import '../library_catalog/movie_view.dart';
import '../library_catalog/save_view.dart';
import '../library_catalog/upload_view.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Library"),
      body: Column(
        children: [
          /// GridView (Danh sách các mục)
          Expanded(
            flex: 2, // GridView chiếm 2 phần
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: gridItems.length,
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return _buildGridItem(
                    item["icon"],
                    item["title"],
                    item["count"],
                    item["color"],
                    item["page"],
                  );
                },
              ),
            ),
          ),

          /// TabBar PlayList, Album
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TabBar(
              controller: controller,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: "Playlist"),
                Tab(text: "Album"),
              ],
            ),
          ),

          /// TabBarView (Phần nội dung bên dưới)
          Expanded(
            flex: 3, // TabBarView chiếm 1 phần
            child: TabBarView(
              controller: controller,
              children: const [
                Center(child: Text("PlayList")),
                Center(child: Text("Album")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> gridItems = [
    {"icon": Icons.favorite_border, "title": "Liked", "count": "39", "color": AppColors.primary, "page": const LikeView()},
    {"icon": Icons.file_download_outlined, "title": "Download", "count": "24", "color": AppColors.primary, "page": const DownloadView()},
    {"icon": Icons.cloud_upload_outlined, "title": "Upload", "count": "2", "color": AppColors.primary, "page": const UploadView()},
    {"icon": Icons.ondemand_video_sharp, "title": "MV", "count": "5", "color": AppColors.primary, "page": const MVView()},
    {"icon": Icons.personal_injury_outlined, "title": "Artists", "count": "8", "color": AppColors.primary, "page": const ArtistsView()},
    {"icon": Icons.book_outlined, "title": "Save", "count": "43", "color": AppColors.primary, "page": const SaveView()},
  ];


  Widget _buildGridItem(IconData icon, String title, String count, Color color, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(count, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
