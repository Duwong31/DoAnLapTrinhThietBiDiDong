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

      final response = await apiClient.get(
        'https://thantrieu.com/resources/braniumapis/songs.json',
      );

      debugPrint('API Response: ${response.data}');

      if (response.statusCode == 200) {
        // API trả về {songs: [...]} nên cần lấy key 'songs'
        final songsData = response.data['songs'] as List<dynamic>? ?? [];
        debugPrint('Total songs in API: ${songsData.length}');

        // Chuyển đổi sang Set để tìm kiếm nhanh hơn
        final idsSet = songIds.map((id) => id.toString()).toSet();

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