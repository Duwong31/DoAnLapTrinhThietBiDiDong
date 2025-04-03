import 'package:flutter/material.dart';
import '../../common/widgets/appbar/appbar.dart';
import '../../core/configs/theme/app_colors.dart';
import '../library_catalog/artists_view.dart';
import '../library_catalog/download_view.dart';
import '../library_catalog/liked_view.dart';
import '../library_catalog/save_view.dart';
import '../library_catalog/upload_view.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Library"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth < 600 ? 10 : 20,
          vertical: screenWidth < 600 ? 20 : 30,
        ),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.1,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item["page"]),
              ),
              child: _buildGridItem(item["icon"], item["title"], item["count"], item["color"]),
            );
          },
        ),
      ),
    );
  }

  final List<Map<String, dynamic>> gridItems = [
    {"icon": Icons.favorite_border, "title": "Liked", "count": "39", "color": AppColors.primary, "page": const LikeView()},
    {"icon": Icons.file_download_outlined, "title": "Download", "count": "24", "color": AppColors.primary, "page": const DownloadView()},
    {"icon": Icons.cloud_upload_outlined, "title": "Upload", "count": "2", "color": AppColors.primary, "page": const UploadView()},
    {"icon": Icons.ondemand_video_sharp, "title": "MV", "count": "5", "color": AppColors.primary, "page": const MovieView()},
    {"icon": Icons.personal_injury_outlined, "title": "Artists", "count": "8", "color": AppColors.primary, "page": const ArtistsView()},
    {"icon": Icons.book_outlined, "title": "Save", "count": "43", "color": AppColors.primary, "page": const SaveView()},
  ];

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

class MovieView {
  const MovieView();
}
