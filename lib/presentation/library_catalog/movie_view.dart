import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../common/widgets/appbar/appbar.dart';

class MVView extends StatefulWidget {
  const MVView({super.key});

  @override
  State<MVView> createState() => _MVViewState();
}

class _MVViewState extends State<MVView> {
  List<dynamic> mvList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMVList();
  }

  // Gọi API lấy danh sách MV
  Future<void> fetchMVList() async {
    try {
      var response = await Dio().get("https://api.example.com/mv");
      if (response.statusCode == 200) {
        setState(() {
          mvList = response.data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching MV list: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Music Videos"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : mvList.isEmpty
          ? const Center(child: Text("No music videos available"))
          : ListView.builder(
        itemCount: mvList.length,
        itemBuilder: (context, index) {
          var mv = mvList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  mv["thumbnail"] ?? "https://via.placeholder.com/100",
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(mv["title"] ?? "Unknown Title"),
              subtitle: Text("Artist: ${mv["artist"] ?? "Unknown"}"),
              trailing: IconButton(
                icon: Icon(Icons.play_circle_fill, color: Colors.red, size: 30),
                onPressed: () {
                  // Xử lý phát MV
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
