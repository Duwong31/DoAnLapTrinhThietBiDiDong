import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/artist_controller.dart';

class ArtistView extends GetView<ArtistController> {
  const ArtistView({super.key});

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
          'Artist',
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMenuItem(context, 'Sơn Tùng M-TP', 'https://photo-zmp3.zadn.vn/avatars/5/9/6/9/59696c9dba7a914d587d886049c10df6.jpg'),
              ],
            ),

            const Divider(
              color: Colors.black, // màu của đường kẻ
              height: 1, // chiều cao của đường kẻ (độ dày)
              thickness: 0.5, // độ dày của đường kẻ
              indent: 15, // khoảng cách bên trái (dễ dàng điều chỉnh chiều dài)
              endIndent: 15, // khoảng cách bên phải
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title, String imagePath) {
  return Column(
    children: [
      ListTile(
        leading: Image.network(
          imagePath,
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () {
          //
        },
      ),
    ],
  );
}
