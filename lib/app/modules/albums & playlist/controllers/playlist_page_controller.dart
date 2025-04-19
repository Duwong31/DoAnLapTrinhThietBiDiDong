// C:\work\SoundFlow\lib\app\modules\albums & playlist\controllers\playlist_page_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import models và repository
import '../../../../models/song.dart';
import '../../../data/models/playlist.dart';
import '../../../data/repositories/repositories.dart'; // Đảm bảo import đúng repo (DefaultRepository hoặc SongDetailRepository)
import '../../../data/repositories/song_repository.dart';
import '../../../widgets/bottom_song_options.dart';

class PlayListController extends GetxController {
  // --- Dependencies ---
  // Inject cả hai repo cần thiết
  final UserRepository _userRepository = Get.find<UserRepository>();
  // Sử dụng DefaultRepository nếu đã sửa, hoặc SongDetailRepository nếu tạo riêng
  final DefaultRepository _songRepository = Get.find<DefaultRepository>();

  // --- State cho Danh sách Playlists ---
  final playlists = <Playlist>[].obs;
  final isLoadingPlaylists = true.obs; // Đổi tên biến loading cho rõ ràng

  // --- State cho Danh sách Bài hát (của playlist đang xem) ---
  final songsInCurrentPlaylist = <Song>[].obs;
  final isSongListLoading = false.obs; // Loading state riêng cho danh sách bài hát

  @override
  void onInit() {
    super.onInit();
    fetchPlaylists(); // Load danh sách playlist khi controller khởi tạo
  }

  // --- Hàm Fetch Danh sách Playlists ---
  void fetchPlaylists() async {
    try {
      isLoadingPlaylists(true); // Bắt đầu loading playlist list
      print("PlayListController: Fetching playlists from repository...");
      final fetchedPlaylists = await _userRepository.getPlaylists();
      print("PlayListController: Received ${fetchedPlaylists.length} playlists.");
      playlists.assignAll(fetchedPlaylists);
    } catch (e, stackTrace) {
      print("PlayListController: Error fetching playlists: $e");
      print(stackTrace);
      Get.snackbar('Error', 'Failed to load playlists. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingPlaylists(false); // Kết thúc loading playlist list
      print("PlayListController: Finished fetching playlists attempt.");
    }
  }

  // --- Hàm Fetch Danh sách Bài hát cho Playlist cụ thể ---
  Future<void> fetchSongsForPlaylist(Playlist playlist) async {
    // Kiểm tra nếu playlist không có track ID thì không cần fetch
    if (playlist.trackIds.isEmpty) {
       print("PlayListController: Playlist '${playlist.name}' has no track IDs. Clearing song list.");
       songsInCurrentPlaylist.clear(); // Xóa list cũ (nếu có)
       return; // Kết thúc sớm
    }

    try {
      isSongListLoading(true); // Bắt đầu loading song list
      songsInCurrentPlaylist.clear(); // Xóa list cũ trước khi fetch mới
      print("PlayListController: Fetching songs for playlist '${playlist.name}' with IDs: ${playlist.trackIds}");

      List<Song> fetchedSongs = [];
      // Lặp qua danh sách track IDs và gọi API lấy chi tiết từng bài
      // **LƯU Ý:** Cách này không hiệu quả nếu playlist có nhiều bài.
      // Lý tưởng nhất là có API backend trả về danh sách bài hát theo playlist ID.
      for (var trackId in playlist.trackIds) {
         if (trackId != null) { // Kiểm tra null cho ID
           final songId = trackId.toString();
           print("PlayListController: Fetching details for track ID: $songId");
           final songDetail = await _songRepository.getSongDetails(songId);
           if (songDetail != null) {
             fetchedSongs.add(songDetail);
             print("PlayListController: Added song '${songDetail.title}'.");
           } else {
             print("PlayListController: Could not fetch details for track ID: $songId");
             // Bạn có thể thêm logic xử lý lỗi ở đây nếu muốn (ví dụ: thêm bài hát placeholder)
           }
         }
      }

      print("PlayListController: Finished fetching songs. Found ${fetchedSongs.length} songs.");
      // Cập nhật danh sách bài hát
      songsInCurrentPlaylist.assignAll(fetchedSongs);

    } catch (e, stackTrace) {
      print("PlayListController: Error fetching songs for playlist '${playlist.name}': $e");
      print(stackTrace);
      Get.snackbar('Error', 'Failed to load songs for this playlist.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSongListLoading(false); // Kết thúc loading song list
    }
  }


  // Hàm hiển thị bottom sheet tùy chọn bài hát
  void showSongOptionsBottomSheet(BuildContext context, {Song? songData}) { // Thêm songData tùy chọn
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // TODO: Truyền songData vào SongOptionsSheet nếu cần
      builder: (_) => const SongOptionsSheet(/*song: songData*/),
    );
  }
}