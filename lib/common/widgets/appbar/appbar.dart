import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../presentation/navigations/setting_view.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize; // Thêm tham số điều chỉnh kích cỡ chữ

  const CustomAppBar({super.key, required this.title, this.fontSize = 30}); // Giá trị mặc định là 30

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? userImage;

  @override
  void initState() {
    super.initState();
    _fetchUserImage();
  }

  Future<void> _fetchUserImage() async {
    try {
      final response = await http.get(Uri.parse("https://your-api.com/user/profile"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userImage = data["avatarUrl"]; // Lấy ảnh từ API
        });
      }
    } catch (e) {
      print("Lỗi tải ảnh: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        widget.title,
        style: TextStyle(
          color: Colors.black,
          fontSize: widget.fontSize, // Kích cỡ chữ có thể tùy chỉnh
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black, size: 30,),
          onPressed: () {},
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 15, // Điều chỉnh kích cỡ avatar
            backgroundImage: userImage != null
                ? NetworkImage(userImage!) // Hiển thị ảnh từ API nếu có
                : const AssetImage('assets/images/userclone.png') as ImageProvider, // Ảnh mặc định nếu chưa đăng nhập
          ),
          onPressed: () => showSettings(context),
        ),
      ],
    );
  }
}
