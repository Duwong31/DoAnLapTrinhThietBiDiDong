import 'package:get/get.dart';
import '../../../../models/song.dart';
import '../../../data/sources/source_songs.dart';
import '../../../data/repositories/repositories.dart';
import 'package:flutter/foundation.dart';

class HomeController extends GetxController {
  final RemoteDataSource _dataSource = RemoteDataSource();
  final UserRepository _userRepository = Get.find<UserRepository>();
  final RxList<Song> songs = <Song>[].obs;
  final RxList<Song> recentSongs = <Song>[].obs;
  final RxList<Song> recommendedSongs = <Song>[].obs;
  final Rxn<Song> currentSong = Rxn<Song>();
  final RxBool isLoadingRecents = false.obs;
  final RxBool isLoadingRecommended = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (songs.isEmpty) {
      loadSongs();
    }
    loadRecentSongs();
    loadRecommendedSongs();
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
      debugPrint(">>> [HomeController.loadRecentSongs] Loading recent history...");
      final recentIds = await _userRepository.getRecentHistory();
      debugPrint(">>> [HomeController.loadRecentSongs] Got ${recentIds.length} recent IDs");
      
      if (recentIds.isNotEmpty) {
        final recentIdsToLoad = recentIds.take(10).toList();
        recentSongs.clear();
        
        debugPrint(">>> [HomeController.loadRecentSongs] Fetching all songs data...");
        final allSongs = await _dataSource.fetchAllSongsData();
        debugPrint(">>> [HomeController.loadRecentSongs] Got ${allSongs.length} total songs");
        
        for (var songId in recentIdsToLoad) {
          try {
            debugPrint(">>> [HomeController.loadRecentSongs] Looking for song ID: $songId");
            final songData = allSongs.firstWhere(
              (song) => song['id']?.toString() == songId,
              orElse: () => null,
            );
            
            if (songData != null) {
              try {
                final song = Song.fromJson(songData);
                recentSongs.add(song);
                debugPrint(">>> [HomeController.loadRecentSongs] Added song: ${song.title}");
              } catch (e) {
                debugPrint(">>> [HomeController.loadRecentSongs] Error parsing song data: $e");
                debugPrint(">>> [HomeController.loadRecentSongs] Problematic song data: $songData");
              }
            } else {
              debugPrint(">>> [HomeController.loadRecentSongs] Song not found: $songId");
            }
          } catch (e) {
            debugPrint(">>> [HomeController.loadRecentSongs] Error processing song $songId: $e");
          }
        }
        debugPrint(">>> [HomeController.loadRecentSongs] Final recent songs count: ${recentSongs.length}");
      } else {
        debugPrint(">>> [HomeController.loadRecentSongs] No recent IDs found");
      }
    } catch (e) {
      debugPrint(">>> [HomeController.loadRecentSongs] Error: $e");
    } finally {
      isLoadingRecents(false);
    }
  }

  Future<void> loadRecommendedSongs() async {
    try {
      isLoadingRecommended(true);
      debugPrint(">>> [HomeController.loadRecommendedSongs] Starting to load recommended songs...");
      
      // 1. Get favorite genre
      debugPrint(">>> [HomeController.loadRecommendedSongs] Step 1: Getting favorite genre...");
      final favoriteGenreResponse = await _userRepository.getFavoriteGenre();
      debugPrint(">>> [HomeController.loadRecommendedSongs] Favorite genre response: $favoriteGenreResponse");
      
      final favoriteGenre = favoriteGenreResponse.data.favoriteGenre;
      debugPrint(">>> [HomeController.loadRecommendedSongs] Favorite genre: $favoriteGenre");
      
      // 2. Get all songs from new endpoint
      debugPrint(">>> [HomeController.loadRecommendedSongs] Step 2: Getting all songs from JsonBin...");
      final allSongs = await _dataSource.fetchSongsFromJsonBin();
      debugPrint(">>> [HomeController.loadRecommendedSongs] Total songs found: ${allSongs.length}");
      
      // 3. Filter songs by genre
      debugPrint(">>> [HomeController.loadRecommendedSongs] Step 3: Filtering songs by genre...");
      recommendedSongs.clear();
      
      int matchingSongs = 0;
      for (var songData in allSongs) {
        debugPrint(">>> [HomeController.loadRecommendedSongs] Checking song: ${songData['id']} - Genre: ${songData['genre']}");
        if (songData['genre'] == favoriteGenre) {
          try {
            final song = Song.fromJson(songData);
            recommendedSongs.add(song);
            matchingSongs++;
            debugPrint(">>> [HomeController.loadRecommendedSongs] Added song: ${song.title}");
            if (recommendedSongs.length >= 10) {
              debugPrint(">>> [HomeController.loadRecommendedSongs] Reached 10 songs limit");
              break;
            }
          } catch (e) {
            debugPrint(">>> [HomeController.loadRecommendedSongs] Error parsing song: $e");
            debugPrint(">>> [HomeController.loadRecommendedSongs] Problematic song data: $songData");
          }
        }
      }
      
      debugPrint(">>> [HomeController.loadRecommendedSongs] Found $matchingSongs songs matching genre '$favoriteGenre'");
      debugPrint(">>> [HomeController.loadRecommendedSongs] Final recommended songs count: ${recommendedSongs.length}");
      
    } catch (e, stackTrace) {
      debugPrint(">>> [HomeController.loadRecommendedSongs] Error: $e");
      debugPrint(">>> [HomeController.loadRecommendedSongs] Stack trace: $stackTrace");
    } finally {
      isLoadingRecommended(false);
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