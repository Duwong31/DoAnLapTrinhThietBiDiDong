import 'package:flutter/material.dart';

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return const SettingsBottomSheet();
    },
  );
}

class SettingsBottomSheet extends StatelessWidget {
  const SettingsBottomSheet({super.key});

  // Giả sử bạn có dữ liệu user từ một nguồn như SharedPreferences hoặc Provider
  final String? userName = null; // Nếu chưa đăng nhập, sẽ là null
  final String? userImage = null; // Nếu chưa đăng nhập, sẽ là null

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: userImage != null && userImage!.isNotEmpty
                    ? NetworkImage(userImage!) // Ảnh từ API nếu đã đăng nhập
                    : const AssetImage('assets/images/userclone.png')
                as ImageProvider, // Ảnh mặc định nếu chưa đăng nhập
              ),
              title: Text(
                (userName?.isNotEmpty ?? false) ? userName! : "Chưa Đăng Nhập",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: (userName?.isNotEmpty ?? false)
                  ? const Text('View Profile') // Chỉ hiển thị nếu có tài khoản
                  : null, // Ẩn nếu chưa đăng nhập
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(),

            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildMenuItem(context, 'Account'),
                  _buildMenuItem(context, 'Themes'),
                  _buildMenuItem(context, 'Storages'),
                  _buildMenuItem(context, 'Audio Quality'),
                  _buildMenuItem(context, 'Video Quality'),
                  _buildMenuItem(context, 'Apps and Devices'),
                  _buildMenuItem(context, 'Notification'),
                  _buildMenuItem(context, 'Language'),
                  _buildMenuItem(context, 'Advertisements'),
                  _buildMenuItem(context, 'About'),
                ],
              ),
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                child: Text('Log out'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title) {
  return ListTile(
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {},
  );
}
