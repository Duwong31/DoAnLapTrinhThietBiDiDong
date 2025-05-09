import 'dart:async';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/song_service.dart';

class FavoriteController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final SongService _songService = Get.find<SongService>();

  final RxList<String> favoriteSongIds = <String>[].obs;              // Danh sách ID bài hát yêu thích
  final RxList<Song> allSongs = <Song>[].obs;                         // Tất cả bài hát
  final RxList<Song> filteredSongs = <Song>[].obs;                    // Bài hát sau khi lọc
  final RxBool isLoading = false.obs;                                 // Trạng thái loading
  final RxString searchKeyword = ''.obs;                              // Từ khóa tìm kiếm
  final _updateStream = StreamController<void>.broadcast();           // Stream cập nhật UI
  final RxMap<String, bool> _favoriteStatus = <String, bool>{}.obs;   // Trạng thái yêu thích

  Stream<void> get updateStream => _updateStream.stream;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteSongs(); // Tự động tải danh sách yêu thích khi khởi tạo
  }

  // Kiểm tra bài hát có trong danh sách yêu thích không
  bool isFavorite(String songId) => favoriteSongIds.contains(songId);


  // Cập nhật ngay trạng thái yêu thích
  void _updateFavoriteStatus(String songId, bool isFavorite) {
    _favoriteStatus[songId] = isFavorite;
  }


  // Thêm/xóa bài hát yêu thích
  Future<void> toggleFavorite(String songId, {bool delayBeforeFilter = false}) async {
    try {
      final isFav = isFavorite(songId);
      if (isFav) {
        favoriteSongIds.remove(songId);
      } else {
        favoriteSongIds.add(songId); // Thêm vào danh sách ngay lập tức
      }

      _updateFavoriteStatus(songId, !isFav);

      if (isFav) {
        favoriteSongIds.remove(songId);
        await _userRepo.removeFavorite(songId);

        if (delayBeforeFilter) {
          await Future.delayed(const Duration(milliseconds: 900));
        }

        allSongs.removeWhere((s) => s.id == songId);
        filteredSongs.removeWhere((s) => s.id == songId);
      } else {
        await _userRepo.addToFavorite(songId);
        await fetchFavoriteSongs();
      }

      _updateStream.add(null); // Thông báo cho listener
    } catch (e) {
      Get.snackbar('Lỗi', 'Cập nhật yêu thích thất bại');
      // Khôi phục trạng thái nếu có lỗi
      _updateFavoriteStatus(songId, isFavorite(songId));
    }
  }

  // Tải danh sách bài hát yêu thích
  Future<void> fetchFavoriteSongs() async {
    try {
      isLoading(true);
      final response = await _userRepo.getFavorites();
      favoriteSongIds.value = response.songIds;

      if (favoriteSongIds.isEmpty) {
        allSongs.clear();
        filteredSongs.clear();
        return;
      }

      final songs = await _songService.getSongsByIds(favoriteSongIds);

      // Cập nhật trạng thái cho tất cả bài hát
      for (var song in songs) {
        _favoriteStatus[song.id] = true;
      }

      allSongs.value = songs;
      filteredSongs.value = List.from(songs);

    } catch (e, stack) {
      debugPrint('Lỗi khi tải danh sách yêu thích: $e');
      debugPrint('Chi tiết lỗi: $stack');
      Get.snackbar('Lỗi', 'Không thể tải danh sách yêu thích');
    } finally {
      isLoading(false);
    }
  }

  // Tìm kiếm bài hát
  void searchSongs(String keyword) {
    searchKeyword.value = keyword;
    filteredSongs.value = keyword.isEmpty
        ? List.from(allSongs)
        : allSongs.where((song) {
      return song.title.toLowerCase().contains(keyword.toLowerCase()) ||
          song.artist.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  // Làm mới danh sách
  Future<void> refreshFavorites() async {
    await fetchFavoriteSongs();
  }

  @override
  void onClose() {
    _updateStream.close();
    _favoriteStatus.close();
    super.onClose();
  }
}