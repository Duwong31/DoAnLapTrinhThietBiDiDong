import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';

class LikeView extends StatelessWidget {
  const LikeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu giả lập cho UI
    final likedSongs = [
      {
        'title': 'Em Của Ngày Hôm Qua',
        'artist': 'Sơn Tùng M-TP',
        'image': 'https://upload.wikimedia.org/wikipedia/vi/5/5d/Em_c%E1%BB%A7a_ng%C3%A0y_h%C3%B4m_qua.png',
      },
      {
        'title': 'Nàng Thơ',
        'artist': 'Hoàng Dũng',
        'image': 'https://i.scdn.co/image/ab67616d0000b273248295fbbb32d0e4d71cc7ea',
      },
      {
        'title': 'Tháng Tư Là Lời Nói Dối Của Em',
        'artist': 'Hà Anh Tuấn',
        'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFQNKZuKEh9mtCDFo2XIwXjeZcPJqqXqoOiA&s',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'liked_tracks'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        // TODO: Lọc danh sách likedSongs theo từ khóa
                      },
                      decoration: const InputDecoration(
                        hintText: "Search tracks",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: likedSongs.isEmpty
                ? Center(
              child: Text(
                'no_liked_songs'.tr,
                style: const TextStyle(fontSize: 16),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: likedSongs.length,
              separatorBuilder: (_, __) => Dimes.height1,
              itemBuilder: (context, index) {
                final song = likedSongs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    song['title']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    song['artist']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.favorite, color: Colors.red),
                  onTap: () {
                    // Nơi để xử lý mở bài hát
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
