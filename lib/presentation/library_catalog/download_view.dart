import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import '../../common/widgets/appbar/appbar.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({super.key});

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  List<dynamic> downloadedSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDownloadedSongs();
  }

  Future<void> fetchDownloadedSongs() async {
    try {
      final response = await http.get(Uri.parse('https://api.example.com/downloaded-songs'));
      if (response.statusCode == 200) {
        setState(() {
          downloadedSongs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Downloaded Songs"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : downloadedSongs.isEmpty
          ? const Center(child: Text("No downloaded songs available"))
          : ListView.builder(
        itemCount: downloadedSongs.length,
        itemBuilder: (context, index) {
          final song = downloadedSongs[index];
          return ListTile(
            leading: const Icon(Icons.music_note, color: Colors.blue),
            title: Text(song['title']),
            subtitle: Text(song['artist']),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Xóa bài hát
              },
            ),
          );
        },
      ),
    );
  }
}