import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../models/song.dart';

abstract interface class DataSource{
  Future<List<Song>?> loadData({
    required int page,      // Số thứ tự của trang dữ liệu muốn tải
    required int perPage,   // Số lượng phần tử muốn tải trong mỗi trang.
});

}

class RemoteDataSource implements DataSource {
  @override
  Future<List<Song>?> loadData({required int page, required int perPage}) async {
    const url = 'https://6802849e0a99cb7408e9d276.mockapi.io/api/songs';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final bodyContent = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(bodyContent);

        List<Song> allSongs = [];

        if (jsonData is List) {
          // API trả về mảng các object có 'songs'
          if (jsonData.isNotEmpty && jsonData[0]['songs'] != null) {
            for (var item in jsonData) {
              allSongs.addAll((item['songs'] as List).map((s) => Song.fromJson(s)));
            }
          }
          // API trả về mảng bài hát trực tiếp
          else {
            allSongs = jsonData.map((s) => Song.fromJson(s)).toList();
          }
        }

        // Phân trang
        final start = (page - 1) * perPage;
        final end = start + perPage;
        return (start >= allSongs.length)
            ? []
            : allSongs.sublist(start, end.clamp(0, allSongs.length));
      } else {
        return null;
      }
    } catch (e) {
      print('Error loading remote data: $e');
      return null;
    }
  }
}


class LocalDataSource implements DataSource{
  @override
  Future<List<Song>?> loadData({required int page, required int perPage}) async{
    final String response = await rootBundle.loadString('assets/songs.json');

    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
    return songs;
  }
}



// phân trang (pagination) => (page và perPage) – thường dùng khi bạn có nhiều dữ liệu (ví dụ: danh sách bài hát, bài viết, sản phẩm,...)
// không muốn tải hết tất cả dữ liệu