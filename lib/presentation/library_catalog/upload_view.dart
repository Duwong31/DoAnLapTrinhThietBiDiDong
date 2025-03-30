import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../common/widgets/appbar/appbar.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  List<dynamic> uploadedSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUploadedSongs();
  }

  // Gọi API lấy danh sách nhạc đã upload
  Future<void> fetchUploadedSongs() async {
    try {
      var response = await Dio().get("https://api.example.com/uploads");
      if (response.statusCode == 200) {
        setState(() {
          uploadedSongs = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching uploaded songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Uploaded Songs"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : uploadedSongs.isEmpty
          ? const Center(child: Text("No uploaded songs available"))
          : ListView.builder(
        itemCount: uploadedSongs.length,
        itemBuilder: (context, index) {
          var song = uploadedSongs[index];
          return ListTile(
            leading: Icon(Icons.music_note, color: Colors.blue),
            title: Text(song["title"] ?? "Unknown Title"),
            subtitle: Text("Artist: ${song["artist"] ?? "Unknown"}"),
            trailing: IconButton(
              icon: Icon(Icons.play_arrow, color: Colors.green),
              onPressed: () {
                // Xử lý phát nhạc
              },
            ),
          );
        },
      ),
    );
  }
}
