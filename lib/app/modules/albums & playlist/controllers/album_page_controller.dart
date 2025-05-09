import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../models/album.dart';

class AlbumController extends GetxController {
  var playlists = <AlbumModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlbums();
  }

  void fetchAlbums() async {
    try {
      isLoading(true);

      final albumIds = [
        '7i3TK6Jvdxixy02nUwBJGF',
        '0O3IzHXaHspsJCKd1wbhfl',
        '4faMbTZifuYsBllYHZsFKJ',
        '1AaxmI2e1HRhbwe9XJGPnT',
        '1saojFqMcYhXsYkpUZEOI3',
        '3lof3SRNSDhgx3l7f3Lw08',
        '1z4B1TU1K39ZQi2AHiiTHG',
        '2b1Cru2BclR9ax5spjRCbF',
        '10Dwjqs7dJNxn2g1PkvRCw',
        '03XBexG3TeHsf88bY4xjmQ',
      ];

      final idsString = albumIds.join(',');

      final res = await http.get(
        Uri.parse('https://spotify23.p.rapidapi.com/albums/?ids=$idsString'),
        headers: {
          'X-RapidAPI-Key': '5abe5894c0mshc6c4628d8b42b9bp1b44ecjsnd3f322d3da57',
          'X-RapidAPI-Host': 'spotify23.p.rapidapi.com',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body)['albums'] as List;
        playlists.value =
            data.map((e) => AlbumModel.fromSpotifyJson(e)).toList();
      } else {
        print("Failed to fetch albums: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching albums: $e");
    } finally {
      isLoading(false);
    }
  }
}