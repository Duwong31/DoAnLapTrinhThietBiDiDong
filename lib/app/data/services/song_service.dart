import 'package:get/get.dart';
import '../../../models/song.dart';
import '../../core/styles/style.dart';
import '../http_client/http_client.dart';

class SongService extends GetxService {
  final ApiClient apiClient;

  SongService(this.apiClient);

  Future<List<Song>> getSongsByIds(List<String> songIds) async {
    try {
      debugPrint('Fetching songs for IDs: $songIds');

      // Gọi API JSONBin
      final response = await apiClient.get(
        'https://api.jsonbin.io/v3/b/681ba8c08a456b7966996409',
      );

      debugPrint('API Response: ${response.data}');

      if (response.statusCode == 200) {
        // Lấy dữ liệu từ trường 'record' trong response và trường 'songs' chứa danh sách bài hát
        final songsData = response.data['record']['songs'] as List<dynamic>? ?? [];
        debugPrint('Total songs in API: ${songsData.length}');

        // Chuyển danh sách songIds thành Set để tìm kiếm nhanh
        final idsSet = songIds.map((id) => id.toString()).toSet();

        // Lọc các bài hát phù hợp với songIds
        final matchedSongs = songsData.where((songJson) {
          final songId = songJson['id']?.toString();
          return songId != null && idsSet.contains(songId);
        }).map((json) => Song.fromJson(json)).toList();

        debugPrint('Found ${matchedSongs.length} matching songs');
        return matchedSongs;
      }
      return [];
    } catch (e, stack) {
      debugPrint('Error in getSongsByIds: $e');
      debugPrint('Stack trace: $stack');
      return [];
    }
  }
}