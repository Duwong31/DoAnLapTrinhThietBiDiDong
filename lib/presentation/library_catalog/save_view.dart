import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../common/widgets/appbar/appbar.dart';

class SaveView extends StatefulWidget {
  const SaveView({super.key});

  @override
  State<SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<SaveView> {
  List<dynamic> savedSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSavedSongs();
  }

  // Gọi API lấy danh sách bài nhạc đã lưu
  Future<void> fetchSavedSongs() async {
    try {
      var response = await Dio().get("https://api.example.com/saved_songs");
      if (response.statusCode == 200) {
        setState(() {
          savedSongs = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching saved songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Saved Songs"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : savedSongs.isEmpty
          ? const Center(child: Text("No saved songs"))
          : ListView.builder(
        itemCount: savedSongs.length,
        itemBuilder: (context, index) {
          var song = savedSongs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  song["cover"] ?? "https://via.placeholder.com/100",
                ),
              ),
              title: Text(song["title"] ?? "Unknown Song"),
              subtitle: Text(song["artist"] ?? "Unknown Artist"),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow, color: Colors.blue),
                onPressed: () {
                  // Xử lý phát nhạc
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
