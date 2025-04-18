import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../models/song.dart';

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
  
  final Dio _externalApiDio = Dio(BaseOptions(
      baseUrl: 'https://api.external-music-source.com', // <-- THAY THẾ BASE URL
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      // Thêm headers nếu API nguồn nhạc yêu cầu (ví dụ: API Key)
      // headers: {
      //   'Authorization': 'Bearer YOUR_EXTERNAL_API_KEY',
      //   'Accept': 'application/json',
      // }
  ));

  Future<Song?> getDetails(String songId) async {
    // *** THAY THẾ '/songs/$songId' BẰNG ENDPOINT THỰC TẾ ***
    final String endpoint = '/songs/$songId'; // Ví dụ endpoint

    print("RemoteDataSource: Fetching details for song $songId from $endpoint");

    try {
      // Thực hiện cuộc gọi GET (hoặc phương thức khác nếu API yêu cầu)
      final response = await _externalApiDio.get(endpoint);

      // Kiểm tra response thành công
      if (response.statusCode == 200 && response.data != null) {
        print("RemoteDataSource: Received details for song $songId");
        // Parse dữ liệu JSON thành đối tượng Song
        // Đảm bảo Song.fromMap hoạt động đúng với cấu trúc response.data này
        return Song.fromJson(response.data as Map<String, dynamic>);
      } else {
        // Log lỗi nếu status code không phải 200
        print("RemoteDataSource: Error fetching song $songId. Status: ${response.statusCode}, Data: ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      // Log lỗi Dio (lỗi mạng, timeout, v.v.)
      print("RemoteDataSource: DioException fetching song $songId: ${e.message}");
      if (e.response != null) {
        print("RemoteDataSource: DioException response data: ${e.response?.data}");
      }
      return null;
    } catch (e, stackTrace) {
      // Log các lỗi khác (ví dụ: lỗi parsing)
      print("RemoteDataSource: Unexpected error fetching song $songId: $e");
      print(stackTrace);
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


// class RemoteDataSource implements DataSource {
//   @override
//   Future<List<Song>?> loadData({required int page, required int perPage}) async {
//     const url = 'https://68013ea281c7e9fbcc41ff1b.mockapi.io/api/songs';
//     final uri = Uri.parse(url);
//
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       final bodyContent = utf8.decode(response.bodyBytes);
//
//       final jsonList = jsonDecode(bodyContent) as List;
//
//       final allSongs = <Song>[];
//
//       for (final item in jsonList) {
//         if (item['songs'] != null) {
//           final songList = item['songs'] as List;
//           allSongs.addAll(songList.map((song) => Song.fromJson(song)).toList());
//         }
//       }
//
//       final start = (page - 1) * perPage;
//       final end = start + perPage;
//
//       if (start >= allSongs.length) return [];
//
//       return allSongs.sublist(start, end > allSongs.length ? allSongs.length : end);
//     } else {
//       return null;
//     }
//   }
// }


// phân trang (pagination) => (page và perPage) – thường dùng khi bạn có nhiều dữ liệu (ví dụ: danh sách bài hát, bài viết, sản phẩm,...)
// không muốn tải hết tất cả dữ liệu