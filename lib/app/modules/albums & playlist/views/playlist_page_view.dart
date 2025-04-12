import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/playlist_controller.dart';

class PlayListView extends GetView<PlayListController> {
  const PlayListView({Key? key}) : super(key: key);

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
          'PlayList',
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
                'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            Dimes.height10,
            const Text(
              'Dành Riêng Cho Kẻ Lụy Tình',
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
                      color: AppTheme.primary,
                    ),
                    Icon(
                      Icons.more_horiz_outlined,
                      size: 40,
                      color: AppTheme.primary,
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.shuffle,
                      size: 40,
                      color: AppTheme.primary,
                    ),
                    Icon(
                      Icons.play_circle_outline,
                      size: 40,
                      color: AppTheme.primary,
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
