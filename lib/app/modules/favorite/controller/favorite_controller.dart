import 'dart:async';
import 'package:get/get.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/song_service.dart';

class FavoriteController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();    // Gọi UserRepository và SongService
  final SongService _songService = Get.find<SongService>();       // để sử dụng trong controller

  final RxList<String> favoriteSongIds = <String>[].obs;          // Danh sách bài hát yêu thích
  final RxList<Song> allSongs = <Song>[].obs;                     // Danh sách tất cả bài hát
  final RxList<Song> filteredSongs = <Song>[].obs;                // Danh sách bài hát sau khi tìm kiếm
  final RxBool isLoading = false.obs;                             // Trạng thái tải dữ liệu
  final RxString searchKeyword = ''.obs;                          // Từ khóa tìm kiếm
  final _updateStream = StreamController<void>.broadcast();       // Stream để cập nhật UI

  Stream<void> get updateStream => _updateStream.stream;          // Stream để cập nhật UI



  @override
  void onInit() {         // Gọi khi controller khởi tạo, tự động fetch danh sách bài hát yêu thích
    super.onInit();
    fetchFavoriteSongs();
  }

  // Lấy danh sách bài hát yêu thích
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

      if (songs.isEmpty) {
        debugPrint('No songs found for IDs: $favoriteSongIds');
        debugPrint('API returned 200 but no matching songs found');
        Get.snackbar(
          'Thông báo',
          'Không tìm thấy thông tin bài hát',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      allSongs.value = songs;
      filteredSongs.value = List.from(songs);

    } catch (e, stack) {
      debugPrint('Error in fetchFavoriteSongs: $e');
      debugPrint('Stack trace: $stack');
      Get.snackbar('Lỗi', 'Không thể tải danh sách yêu thích');
    } finally {
      isLoading(false);
    }
  }

  // Tìm kiếm bài hát
  void searchSongs(String keyword) {
    searchKeyword.value = keyword;
    if (keyword.isEmpty) {
      filteredSongs.value = List.from(allSongs);
      return;
    }
    filteredSongs.value = allSongs.where((song) {
      return song.title.toLowerCase().contains(keyword.toLowerCase()) ||
          song.artist.toLowerCase().contains(keyword.toLowerCase());
    }).toList();
  }

  // Thêm và xóa bài hát yêu thích
  Future<void> toggleFavorite(String songId, {bool delayBeforeFilter = false}) async {
    try {
      final isFav = isFavorite(songId);

      if (isFav) {
        await _userRepo.removeFavorite(songId);
        favoriteSongIds.remove(songId);

        // Cho UI có thời gian đổi màu icon trước khi xóa khỏi danh sách
        if (delayBeforeFilter) {
          await Future.delayed(const Duration(milliseconds: 900));
        }

        allSongs.removeWhere((s) => s.id == songId);
        filteredSongs.removeWhere((s) => s.id == songId);
      } else {
        await _userRepo.addToFavorite(songId);
        await fetchFavoriteSongs();
      }

      _updateStream.add(null);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite');
    }
  }

  // Kiểm tra xem bài hát có trong danh sách yêu thích hay không
  bool isFavorite(String songId) => favoriteSongIds.contains(songId);

  // Cập nhật danh sách yêu thích
  Future<void> refreshFavorites() async {
    await fetchFavoriteSongs();
  }

  @override
  void onClose() {
    _updateStream.close();
    super.onClose();
  }
}