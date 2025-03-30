import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../common/widgets/appbar/appbar.dart';

class LikeView extends StatefulWidget {
  const LikeView({super.key});

  @override
  State<LikeView> createState() => _LikeViewState();
}

class _LikeViewState extends State<LikeView> {
  List<dynamic> likedSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLikedSongs();
  }

  Future<void> _fetchLikedSongs() async {
    const String apiUrl = "..."; // Thay URL API
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          likedSongs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load liked songs");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching liked songs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Liked Songs"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : likedSongs.isEmpty
          ? const Center(child: Text("No liked songs yet!"))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: likedSongs.length,
        itemBuilder: (context, index) {
          final song = likedSongs[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(song["cover"], width: 50, height: 50, fit: BoxFit.cover),
            ),
            title: Text(song["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(song["artist"]),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {},
            ),
          );
        },
      ),
    );
  }
}
