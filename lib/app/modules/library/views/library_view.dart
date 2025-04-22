import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../albums & playlist/views/album_page_view.dart';
import '../../albums & playlist/views/playlist_page_view.dart';
import '../controllers/library_controller.dart';

class LibraryView extends GetView<LibraryController> {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Library list
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuItem(context, 'Liked tracks', const LikeView()),
                _buildMenuItem(context, 'Playlists', const PlayListView()),
                _buildMenuItem(context, 'Albums', const AlbumView()),
                _buildMenuItem(context, 'Following', const FollowView()),
                _buildMenuItem(context, 'Stations', const StationView()),
                _buildMenuItem(context, 'Uploads', const UploadView()),
              ],
            ),

            const Divider(
              color: Colors.black, // màu của đường kẻ
              height: 1, // chiều cao của đường kẻ (độ dày)
              thickness: 0.5, // độ dày của đường kẻ
              indent: 15, // khoảng cách bên trái (dễ dàng điều chỉnh chiều dài)
              endIndent: 15, // khoảng cách bên phải
            ),


            // Playlist
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My playlist",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to all songs page
                        },
                        child: Container(
                          width: 60,
                          height: 30,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8E8E8),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text('See all', style: TextStyle(color: AppTheme.labelColor),),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                Dimes.height5,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/f/8/8/5/f885e8888832588c8de1c26765a8aa90.jpg',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Dimes.width10,
                        const Text(
                            'Best song of Jack - J97',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

// danh sách các thành phần trong library
Widget _buildMenuItem(BuildContext context, String title, Widget destination) {
  return ListTile(
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
    // onPressed: () => Get.toNamed(routeName),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
}

// Dummy Views (phải là widgets)
class LikeView extends StatelessWidget {
  const LikeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Liked tracks")),
    );
  }
}

class FollowView extends StatelessWidget {
  const FollowView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Following")),
    );
  }
}

class StationView extends StatelessWidget {
  const StationView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Stations")),
    );
  }
}

class UploadView extends StatelessWidget {
  const UploadView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Your uploads")),
    );
  }
}
