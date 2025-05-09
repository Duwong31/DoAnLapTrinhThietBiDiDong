import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../models/song.dart';

class GenreController extends GetxController {
  var genreList = <String>[].obs;
  var songsByGenre = <Song>[].obs;
  var isLoading = true.obs;
  var isGenreLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGenres();
  }

  Future<void> fetchGenres() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse('https://api.jsonbin.io/v3/b/681ba8c08a456b7966996409'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final songs = (data['record']['songs'] as List)
            .map((json) => Song.fromJson(json))
            .toList();

        final uniqueGenres = songs
            .map<String>((song) => toTitleCase(song.genre))
            .toSet()
            .toList();

        genreList.assignAll(uniqueGenres);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSongsByGenre(String genre) async {
    try {
      isGenreLoading.value = true;
      final response = await http.get(Uri.parse('https://api.jsonbin.io/v3/b/681ba8c08a456b7966996409'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        songsByGenre.assignAll(
            (data['record']['songs'] as List)
                .map((json) => Song.fromJson(json))
                .where((song) => song.genre.toLowerCase() == genre.toLowerCase())
                .toList()
        );
      }
    } finally {
      isGenreLoading.value = false;
    }
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;

    // Xử lý các trường hợp đặc biệt trước (như R&B)
    if (text.toLowerCase() == 'r&b') {
      return 'R&B';
    }

    // Kết hợp regex để xử lý cả khoảng trắng và dấu gạch ngang
    return text.replaceAllMapped(
      RegExp(r'(^|\s|-)([a-z0-9])'), // Thêm số (0-9) nếu cần
          (Match m) => '${m[1]}${m[2]?.toUpperCase()}',
    ).replaceAllMapped(
      RegExp(r'([a-z])([A-Z])'), // Xử lý các chữ viết hoa giữa từ
          (Match m) => '${m[1]} ${m[2]}',
    );
  }
}