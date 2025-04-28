import 'package:get/get.dart';

import '../../../models/song.dart';
import '../sources/source_songs.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData({int page, int perPage});
  Future<Song?> getSongDetails(String songId);
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final RemoteDataSource _remoteDataSource = Get.find<RemoteDataSource>();
  final Map<String, Song> _songDetailCache = {};
  List<Song>? _cachedSongs; // Lưu trữ danh sách bài hát đã fetch
  bool _isFetchingAllSongs = false;

  @override
  Future<List<Song>?> loadData({int page = 1, int perPage = 10}) async {
    List<Song> songs = [];

    final remoteSongs =
        await _remoteDataSource.loadData(page: page, perPage: perPage);
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
  Future<Song?> getSongDetails(String id) async {
    print("Repository: Requesting details for song ID: $id");
    try {
      // 1. Đảm bảo danh sách tất cả bài hát đã được fetch và cache
      final List<Song> allSongs = await _fetchAllSongsAndCache();

      // Nếu fetch lỗi và trả về list rỗng
      if (allSongs.isEmpty && _cachedSongs == null) {
        print(
            "Repository: Cannot find song '$id' because the song list failed to load.");
        return null;
      }

      // 2. Tìm bài hát trong danh sách đã cache bằng ID
      // Sử dụng firstWhereOrNull từ package:collection để an toàn hơn
      // Hoặc dùng try-catch với firstWhere
      final song = allSongs.firstWhereOrNull((song) => song.id == id);

      if (song != null) {
        print("Repository: Found song '$id' in cache: ${song.title}");
      } else {
        // Điều này có thể xảy ra nếu ID trong playlist không tồn tại trong file songs.json
        print(
            "Repository: Song with ID '$id' NOT FOUND in the cached list (${allSongs.length} songs total).");
      }
      return song; // Trả về bài hát tìm thấy hoặc null
    } catch (e) {
      // Lỗi xảy ra trong quá trình tìm kiếm hoặc khi fetch cache
      print("Repository: Error in getSongDetails for ID '$id': $e");
      return null; // Trả về null nếu có lỗi
    }
  }

  Future<List<Song>> _fetchAllSongsAndCache() async {
    // Nếu đang fetch rồi thì chờ và trả về cache (hoặc ném lỗi/chờ)
    if (_isFetchingAllSongs) {
      print("Repository: Already fetching all songs, waiting...");
      // Đợi một chút và thử lại hoặc implement cơ chế lock phức tạp hơn
      await Future.delayed(const Duration(milliseconds: 200));
      return _cachedSongs ?? []; // Trả về cache nếu có sau khi đợi
    }

    // Nếu đã có cache, trả về luôn
    if (_cachedSongs != null) {
      // print("Repository: Returning cached songs list.");
      return _cachedSongs!;
    }

    // Đánh dấu đang fetch
    _isFetchingAllSongs = true;
    print(
        "Repository: Cache empty or invalid. Fetching all songs from remote source...");

    try {
      // Gọi hàm mới trong RemoteDataSource
      final List<dynamic> songListData =
          await _remoteDataSource.fetchAllSongsData();

      // Parse list Map thành list Song object
      _cachedSongs = songListData
          .map((json) => Song.fromJson(json as Map<String, dynamic>))
          .toList();

      print(
          "Repository: Successfully fetched and cached ${_cachedSongs!.length} songs.");
      return _cachedSongs!;
    } catch (e) {
      print("Repository: Error fetching or caching all songs: $e");
      _cachedSongs = null; // Xóa cache nếu có lỗi
      // Có thể ném lại lỗi hoặc trả về list rỗng tùy logic xử lý lỗi mong muốn
      return []; // Trả về list rỗng để tránh crash app
    } finally {
      // Đảm bảo bỏ đánh dấu sau khi fetch xong (thành công hay thất bại)
      _isFetchingAllSongs = false;
    }
  }
}
