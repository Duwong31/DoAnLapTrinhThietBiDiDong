import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/styles/style.dart';
import '../../../../routes/app_pages.dart';
import 'create_new_playlist.dart';

class AddToPlaylistPage extends StatefulWidget {
  const AddToPlaylistPage({super.key});

  @override
  State<AddToPlaylistPage> createState() => _AddToPlaylistPageState();
}

class _AddToPlaylistPageState extends State<AddToPlaylistPage> {
  Set<int> selectedIndexes = {}; // <-- đổi từ int? selectedIndex sang Set

  List<Map<String, dynamic>> playlists = [
    {
      'name': 'Liked Songs',
      'songs': 'saved',
      'image': Icons.favorite,
      'gradient': LinearGradient(colors: [Colors.purple, Colors.blue]),
    },
    {
      'name': 'Người ta nghe gì',
      'songs': '2 songs',
      'image':
          'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg',
    },
    {
      'name': 'bruh',
      'songs': '1 song',
      'image':
          'https://photo-resize-zmp3.zadn.vn/w600_r1x1_jpeg/cover/9/0/a/a/90aaf76ec66bed90edc006c899415054.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.createNewPlaylist);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('New playlist'),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Saved in',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndexes.clear(); // clear all
                    });
                  },
                  child: const Text('Clear all',
                      style: TextStyle(color: Colors.orange)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.list),
                SizedBox(width: 8),
                Text('Most relevant',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final item = playlists[index];
                final isSelected = selectedIndexes.contains(index);
                return ListTile(
                  leading: item.containsKey('gradient')
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            gradient: item['gradient'],
                          ),
                          child:
                              const Icon(Icons.favorite, color: Colors.white),
                        )
                      : Image.network(item['image'],
                          width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle:
                      item['songs'] == 'saved' ? null : Text(item['songs']),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color:
                                isSelected ? Colors.orange : Colors.grey[400]!,
                                width: 2.2),
                        color: isSelected ? Colors.orange : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedIndexes.isNotEmpty ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
