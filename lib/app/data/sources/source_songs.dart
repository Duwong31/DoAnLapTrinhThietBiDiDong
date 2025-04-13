import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../models/songs/all_songs.dart';

abstract interface class DataSource{
  Future<List<Song>?> loadData({
    required int page,      // Số thứ tự của trang dữ liệu muốn tải
    required int perPage,   // Số lượng phần tử muốn tải trong mỗi trang.
});

}

class RemoteDataSource implements DataSource{
  @override
  Future<List<Song>?> loadData({required int page, required int perPage}) async {
    const url = ('https://thantrieu.com/resources/braniumapis/songs.json');
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if(response.statusCode == 200){
      final bodyContent = utf8.decode(response.bodyBytes);

      var SongWrapper = jsonDecode(bodyContent) as Map;

      var songList = SongWrapper['songs'] as List;
      List<Song> songs = songList.map((song) => Song.fromJson(song)).toList();
      return songs;
    }else{
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