import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../models/song.dart';

class AlbumNowController extends GetxController {
  var isLoading = true.obs;
  var album = {}.obs;
  var songs = <SongModel>[].obs;

  final String baseUrl = 'https://spotify23.p.rapidapi.com';
  final String apiKey = '94b88f124fmshce6a37630b75745p1b6b7djsn0b7dbb28dd4d';

  @override
  void onInit() {
    super.onInit();
    final albumId = Get.arguments as String?;
    if (albumId != null && albumId.isNotEmpty) {
      fetchAlbum(albumId);
    } else {
      
      isLoading(false);
    }
  }

  void fetchAlbum(String id) async {
    try {
      isLoading(true);
      final res = await http.get(
        Uri.parse('$baseUrl/albums/?ids=$id'),
        headers: {
          'X-RapidAPI-Key': '94b88f124fmshce6a37630b75745p1b6b7djsn0b7dbb28dd4d',
          'X-RapidAPI-Host': 'spotify23.p.rapidapi.com',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final albums = data['albums'];

        if (albums == null || albums.isEmpty) {
          
          return;
        }

        final albumInfo = albums[0];
        album.value = albumInfo;

        final trackItems = albumInfo['tracks']?['items'] ?? [];

        songs.value = trackItems.map<SongModel?>((track) {
          if (track == null) return null;

          final trackImage = (albumInfo['images'] != null && albumInfo['images'].isNotEmpty)
              ? albumInfo['images'][0]['url'] ?? ''
              : '';

          return SongModel(
            id: track['id'] ?? '',
            title: track['name'] ?? '',
            duration: track['duration_ms'] ?? 0,
            source: track['preview_url'] ?? '',
            artist: (track['artists'] != null && track['artists'].isNotEmpty)
                ? track['artists'][0]['name'] ?? 'Unknown Artist'
                : 'Unknown Artist',
            image: trackImage,
          );
        }).whereType<SongModel>().toList();
      } else {
        
      }
    } catch (e) {
      print('Error fetching album: $e');
    } finally {
      isLoading(false);
    }
  }
}
