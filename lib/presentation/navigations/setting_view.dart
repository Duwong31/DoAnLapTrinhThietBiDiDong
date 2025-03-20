import 'package:flutter/material.dart';

void showSettings(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              title: const Text('Phong Hoàng', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('View Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(),
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
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      );
    },
  );
}

Widget _buildMenuItem(BuildContext context, String title) {
  return ListTile(
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {},
  );
}
