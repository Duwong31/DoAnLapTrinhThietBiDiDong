import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/song.dart';
import '../repositories/repositories.dart';
import 'package:get/get.dart';

abstract interface class DataSource{
  Future<List<Song>?> loadData({
    required int page,      // Số thứ tự của trang dữ liệu muốn tải
    required int perPage,   // Số lượng phần tử muốn tải trong mỗi trang.
});

}

class RemoteDataSource implements DataSource{
  final Dio _dio = Get.find<Dio>(); // Hoặc cách bạn inject Dio
  // URL của file JSON chứa tất cả bài hát
  final String _allSongsUrl = "https://thantrieu.com/resources/braniumapis/songs.json";
  
  @override
  Future<List<Song>> loadData({required int page, required int perPage}) async {
    const url = 'https://api.jsonbin.io/v3/b/681ba8c08a456b7966996409';
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri, headers: {
        'X-Master-Key': 'your_master_key', // Thêm header nếu API yêu cầu key xác thực.
      });

      if (response.statusCode == 200) {
        final bodyContent = utf8.decode(response.bodyBytes);
        final jsonData = jsonDecode(bodyContent);

        // Kiểm tra xem dữ liệu trả về có đúng cấu trúc không
        if (jsonData['record'] != null) {
          final songData = jsonData['record']['songs'];

          // Chuyển đổi dữ liệu từ json sang danh sách bài hát
          List<Song> allSongs = songData.map<Song>((s) => Song.fromJson(s)).toList();

          // Phân trang (tương tự như trước)
          final start = (page - 1) * perPage;
          final end = (start + perPage).clamp(0, allSongs.length);
          return allSongs.sublist(start, end);
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception("API returned ${response.statusCode}");
      }
    } catch (e) {
      print('Error loading remote data: $e');
      return [];
    }
  }


  Future<List<dynamic>> fetchAllSongsData() async {
    try {
      print("RemoteDataSource: Fetching all songs from $_allSongsUrl");
      final response = await _dio.get(_allSongsUrl);

      if (response.statusCode == 200 && response.data is Map) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        // Kiểm tra xem có key 'songs' và giá trị là List không
        if (data.containsKey('songs') && data['songs'] is List) {
           print("RemoteDataSource: Successfully fetched all songs data.");
           // Trả về list các map bài hát dưới key 'songs'
           return data['songs'] as List<dynamic>;
        } else {
           print("RemoteDataSource: Response OK but 'songs' key not found or not a List.");
           throw Exception("Invalid song data format in response.");
        }
      } else {
        print("RemoteDataSource: Failed to fetch all songs. Status: ${response.statusCode}");
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: "Failed to fetch all songs (Status: ${response.statusCode})",
          type: DioExceptionType.badResponse, // Hoặc type phù hợp
        );
      }
    } on DioException catch (e) {
      // Log lỗi chi tiết hơn từ Dio
      print("RemoteDataSource: DioException fetching all songs: ${e.message}");
      print("RemoteDataSource: DioException response: ${e.response?.data}"); // In response nếu có
      rethrow; // Ném lại lỗi để Repository xử lý
    } catch (e) {
      print("RemoteDataSource: Unexpected error fetching all songs: $e");
      rethrow;
    }
  }

  
  final Dio _externalApiDio = Dio(BaseOptions(
      baseUrl: 'https://thantrieu.com/resources/braniumapis/songs.json.', // <-- THAY THẾ BASE URL
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



// phân trang (pagination) => (page và perPage) – thường dùng khi bạn có nhiều dữ liệu (ví dụ: danh sách bài hát, bài viết, sản phẩm,...)
// không muốn tải hết tất cả dữ liệu