import 'dart:async';
import 'package:get/get.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/song_service.dart';

class FavoriteController extends GetxController {
  final UserRepository _userRepo = Get.find<UserRepository>();
  final SongService _songService = Get.find<SongService>();

  final RxList<String> favoriteSongIds = <String>[].obs;
  final RxList<Song> allSongs = <Song>[].obs;
  final RxList<Song> filteredSongs = <Song>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchKeyword = ''.obs;
  final _updateStream = StreamController<void>.broadcast();

  Stream<void> get updateStream => _updateStream.stream;

  @override
  void onInit() {         // Gọi khi controller khởi tạo, tự động fetch danh sách bài hát yêu thích
    super.onInit();
    fetchFavoriteSongs();
  }

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

  Future<void> toggleFavorite(String songId) async {
    try {
      final isFav = isFavorite(songId);
      if (isFav) {
        await _userRepo.removeFavorite(songId);
        favoriteSongIds.remove(songId);
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

  bool isFavorite(String songId) => favoriteSongIds.contains(songId);

  Future<void> refreshFavorites() async {
    await fetchFavoriteSongs();
  }

  @override
  void onClose() {
    _updateStream.close();
    super.onClose();
  }
}