import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../common/widgets/appbar/appbar.dart';

class ArtistsView extends StatefulWidget {
  const ArtistsView({super.key});

  @override
  State<ArtistsView> createState() => _ArtistsViewState();
}

class _ArtistsViewState extends State<ArtistsView> {
  List<dynamic> artistsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArtists();
  }

  // Gọi API lấy danh sách nghệ sĩ
  Future<void> fetchArtists() async {
    try {
      var response = await Dio().get("https://api.example.com/artists");
      if (response.statusCode == 200) {
        setState(() {
          artistsList = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching artists: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Followed Artists"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : artistsList.isEmpty
          ? const Center(child: Text("No followed artists"))
          : ListView.builder(
        itemCount: artistsList.length,
        itemBuilder: (context, index) {
          var artist = artistsList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  artist["avatar"] ?? "https://via.placeholder.com/100",
                ),
              ),
              title: Text(artist["name"] ?? "Unknown Artist"),
              subtitle: Text("Followers: ${artist["followers"] ?? 0}"),
              trailing: IconButton(
                icon: Icon(Icons.more_vert, color: Colors.black54),
                onPressed: () {
                  // Xử lý mở trang chi tiết nghệ sĩ
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
