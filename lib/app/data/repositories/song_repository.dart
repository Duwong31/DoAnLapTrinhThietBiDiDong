import '../../../models/song.dart';
import '../sources/source_songs.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData({int page, int perPage});
  Future<Song?> getSongDetails(String songId);
}

class DefaultRepository implements Repository {
  // final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();
  final Map<String, Song> _songDetailCache = {};

  @override
  Future<List<Song>?> loadData({int page = 1, int perPage = 10}) async {
    List<Song> songs = [];

    final remoteSongs = await _remoteDataSource.loadData(page: page, perPage: perPage);
    // final localSongs = await _localDataSource.loadData(page: page, perPage: perPage);

    if (remoteSongs != null) {
      songs.addAll(remoteSongs);
    }

    // if (localSongs != null) {
    //   songs.addAll(localSongs);
    // }

    return songs;
  }

  @override
  Future<Song?> getSongDetails(String songId) async {
    if (_songDetailCache.containsKey(songId)) {
      return _songDetailCache[songId];
    }
    try {
      // Gọi _remoteDataSource để lấy chi tiết bài hát
      // Bạn cần thêm phương thức getDetails(songId) vào RemoteDataSource
      final song = await _remoteDataSource.getDetails(songId);
      if (song != null) {
        _songDetailCache[songId] = song; // Lưu cache
      }
      return song;
    } catch (e) {
      print("Error getting song details for $songId: $e");
      return null; // Trả về null nếu lỗi
    }
  }
}
