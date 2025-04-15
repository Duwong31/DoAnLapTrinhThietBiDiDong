import 'dart:convert';

import 'package:extended_image/extended_image.dart' as http;
import 'package:get/get.dart';

import '../../../../models/album.dart';
import '../../../../models/song.dart';

class AlbumController extends GetxController {
  var playlists = <AlbumModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAlbums();
    super.onInit();
  }

  void fetchAlbums() async {
    try {
      isLoading(true);
      final res = await http.get(Uri.parse('https://api.deezer.com/chart/0/albums'));
      if (res.statusCode == 200) {
        final jsonData = json.decode(res.body);
        final List albums = jsonData['data'];
        playlists.value = albums.map((e) => AlbumModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching albums: $e");
    } finally {
      isLoading(false);
    }
  }
}

class AlbumNowController extends GetxController {
  var album = {}.obs;
  var songs = <SongModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAlbum();
    super.onInit();
  }

  void fetchAlbum() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://api.deezer.com/album/302127'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        album.value = jsonData;

        final trackList = jsonData['tracks']['data'] as List<dynamic>;
        songs.value = trackList.map((e) => SongModel.fromJson(e)).toList();
      } else {
        print('Failed to load album');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}