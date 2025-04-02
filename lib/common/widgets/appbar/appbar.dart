import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../presentation/setting/pages/notification_provider.dart';
import '../../../presentation/setting/pages/notification_view.dart';
import '../../../presentation/setting/pages/setting_view.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final double fontSize;

  const CustomAppBar({super.key, required this.title, this.fontSize = 30});

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
          userImage = data["avatarUrl"];
        });
      }
    } catch (e) {
      print("Error download image: $e");
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
          color: AppColors.primary,
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: AppColors.primary,
                size: 30,
              ),
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false).clearNotification();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
            Consumer<NotificationProvider>(
              builder: (context, provider, child) {
                return provider.hasNotification
                    ? Positioned(
                  right: 0,
                  top: 5,
                  child: Container(
                    width: 30,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                )
                    : SizedBox.shrink();
              },
            ),
          ],
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 15,
            backgroundImage: userImage != null
                ? NetworkImage(userImage!)
                : const AssetImage('assets/images/userclone.png') as ImageProvider,
          ),
          onPressed: () => showSettings(context),
        ),
      ],
    );
  }
}
