import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/album_page_controller.dart';

class AlbumView extends GetView<AlbumController> {
  const AlbumView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: AppTheme.appBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.toNamed(Routes.dashboard);
          },
        ),
        title: const Text(
          'Album',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                'https://photo-resize-zmp3.zadn.vn/w360_r1x1_jpeg/avatars/0/3/3/7/0337e4cc5a05cdcc93b5d65762aea241.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Dimes.height10,
            const Text(
              'Tổng Hợp Nhạc Hay Nhất Của Anh Jack - J97',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            Dimes.height40,
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.download_for_offline_outlined,
                      size: 40,
                      color: AppTheme.labelColor,
                    ),
                    Icon(
                      Icons.more_horiz_outlined,
                      size: 40,
                      color: AppTheme.labelColor,
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.shuffle,
                      size: 40,
                      color: AppTheme.labelColor,
                    ),
                    Icon(
                      Icons.play_circle_outline,
                      size: 40,
                      color: AppTheme.labelColor,
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}