import 'package:get/get.dart';
import '../../../../models/song.dart';
import '../../../data/sources/source_songs.dart';
import '../../../data/repositories/repositories.dart';

class HomeController extends GetxController {
  final RemoteDataSource _dataSource = RemoteDataSource();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final RxList<Song> songs = <Song>[].obs;
  final RxList<Song> recentSongs = <Song>[].obs;
  final Rxn<Song> currentSong = Rxn<Song>();
  final RxBool isLoadingRecents = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (songs.isEmpty) {
      loadSongs();
    }
    loadRecentSongs();
  }

  Future<void> loadSongs() async {
    try {
      final result = await _dataSource.loadData(page: 1, perPage: 6);
      if (result != null) {
        songs.assignAll(result);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load songs');
    }
  }

  Future<void> loadRecentSongs() async {
    try {
      isLoadingRecents(true);
      final recentIds = await _userRepository.getRecentHistory();
      
      if (recentIds.isNotEmpty) {
        // Lấy tối đa 10 bài hát gần nhất
        final recentIdsToLoad = recentIds.take(10).toList();
        recentSongs.clear();
        
        // Lấy toàn bộ danh sách bài hát
        final allSongs = await _dataSource.fetchAllSongsData();
        
        // Tìm các bài hát theo ID trong danh sách gần đây
        for (var songId in recentIdsToLoad) {
          try {
            final songData = allSongs.firstWhere(
              (song) => song['id'].toString() == songId,
              orElse: () => null,
            );
            
            if (songData != null) {
          
              final song = Song.fromJson(songData);
              recentSongs.add(song);
            } else {
      
            }
          } catch (e) {
            print('Error processing song $songId: $e');
          }
        }
        
      } else {
        
      }
    } catch (e) {
      print('Error in loadRecentSongs: $e');
    } finally {
      isLoadingRecents(false);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}