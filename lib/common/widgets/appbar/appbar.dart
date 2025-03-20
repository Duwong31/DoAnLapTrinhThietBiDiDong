import 'package:flutter/material.dart';

import '../../../presentation/navigations/setting_view.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
          ),
          onPressed: () => showSettings(context), // Gọi hàm từ setting.dart
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
