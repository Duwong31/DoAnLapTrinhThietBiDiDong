import 'package:flutter/material.dart';
import 'package:soundflow/presentation/views/personal_edit.dart';
import '../../common/widgets/appbar/appbar.dart';

class PersonalView extends StatefulWidget {
  const PersonalView({super.key});

  @override
  State<PersonalView> createState() => _PersonalViewState();
}

class _PersonalViewState extends State<PersonalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Personal"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phong Hoàng',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('0 followers • 1 following'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PersonalEdit()),
                    );
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.ios_share),
                  onPressed: () {

                  },
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {

                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Playlists',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.music_note, size: 30),
              ),
              title: const Text('Người ta nghe gì'),
              subtitle: const Text('0 saves • Phong Hoàng'),
              onTap: () {},
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text('See all playlists', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}