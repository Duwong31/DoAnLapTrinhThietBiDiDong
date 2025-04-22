// C:\work\SoundFlow\lib\app\modules\albums & playlist\controllers\playlist_page_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import models và repository
import '../../../../models/song.dart';
import '../../../data/models/playlist.dart';
import '../../../data/repositories/repositories.dart'; // Đảm bảo import đúng repo (DefaultRepository hoặc SongDetailRepository)
import '../../../data/repositories/song_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/bottom_playlist_options.dart';
import '../../../widgets/bottom_song_options.dart'; 

class PlayListController extends GetxController {

  final UserRepository _userRepository = Get.find<UserRepository>();
  // Sử dụng DefaultRepository nếu đã sửa, hoặc SongDetailRepository nếu tạo riêng
  final DefaultRepository _songRepository = Get.find<DefaultRepository>();

  // --- State cho Danh sách Playlists ---
  final playlists = <Playlist>[].obs;
  final isLoadingPlaylists = true.obs;
  final songsInCurrentPlaylist = <Song>[].obs;
  final isSongListLoading = false.obs; 
  Playlist? _currentViewingPlaylist;
  final isRemovingSong = false.obs;
  final isDeletingPlaylist = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchPlaylists(); // Load danh sách playlist khi controller khởi tạo
  }

  // --- Hàm Fetch Danh sách Playlists ---
  void fetchPlaylists() async {
    try {
      isLoadingPlaylists(true);
      final fetchedPlaylists = await _userRepository.getPlaylists();
      playlists.assignAll(fetchedPlaylists);
    } catch (e, stackTrace) {
      print("PlayListController: Error fetching playlists: $e\n$stackTrace");
      Get.snackbar('Error', 'Failed to load playlists.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingPlaylists(false);
    }
  }

  // --- Hàm Fetch Danh sách Bài hát cho Playlist cụ thể ---
  Future<void> fetchSongsForPlaylist(Playlist playlist) async {
     print("Controller fetchSongsForPlaylist: Received playlist: ${playlist.name} (ID: ${playlist.id})");

   // *** ĐẢM BẢO DÒNG NÀY NẰM NGAY SAU DÒNG PRINT TRÊN ***
   _currentViewingPlaylist = playlist;
   // *** DÒNG PRINT XÁC NHẬN ***
   print("Controller fetchSongsForPlaylist: _currentViewingPlaylist assigned: ${_currentViewingPlaylist?.name}");
     if (isSongListLoading.value) return;

    // Nếu playlist không có track ID, hiển thị là rỗng và không cần gọi API
    if (playlist.trackIds.isEmpty) {
       print("PlayListController: Playlist '${playlist.name}' has no track IDs.");
       songsInCurrentPlaylist.clear(); // Xóa bài hát cũ (nếu có)
       isSongListLoading(false); // Đảm bảo không ở trạng thái loading
       return; // Kết thúc sớm
    }

    try {
      isSongListLoading(true); // Bắt đầu loading
      songsInCurrentPlaylist.clear(); // Xóa danh sách cũ trước khi fetch mới
      print("PlayListController: Fetching songs for playlist '${playlist.name}' with IDs: ${playlist.trackIds}");

      List<Song> fetchedSongs = [];
      for (var trackId in playlist.trackIds) {
         // Đảm bảo trackId không null và là String hợp lệ
         if (trackId != null) {
           final String songId = trackId.toString();
           if (songId.isNotEmpty) {
              print("PlayListController: Fetching details for song ID: $songId");
              try {
                 // Gọi repository để lấy chi tiết bài hát
                 final songDetail = await _songRepository.getSongDetails(songId);
                 if (songDetail != null) {
                   fetchedSongs.add(songDetail);
                   print("PlayListController: Added song: ${songDetail.title}");
                 } else {
                   print("PlayListController: Song details not found for ID: $songId");
                 }
              } catch (songError) {
                 // Bắt lỗi cụ thể khi fetch một bài hát để không dừng toàn bộ quá trình
                 print("PlayListController: Error fetching song details for ID $songId: $songError");
              }
           } else {
              print("PlayListController: Skipping invalid track ID: $trackId");
           }
         } else {
             print("PlayListController: Skipping null track ID.");
         }
      }

      // Cập nhật danh sách bài hát (sẽ trigger Obx trong UI)
      songsInCurrentPlaylist.assignAll(fetchedSongs);
      print("PlayListController: Finished fetching. Found ${fetchedSongs.length} songs.");

    } catch (e, stackTrace) {
      // Lỗi tổng quát trong quá trình fetch (ví dụ: lỗi mạng)
      print("PlayListController: Error fetching songs for playlist: $e\n$stackTrace");
      songsInCurrentPlaylist.clear(); // Xóa hết nếu có lỗi lớn
      Get.snackbar('Error', 'Failed to load songs for this playlist.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSongListLoading(false); // Kết thúc loading (luôn luôn)
    }
  }

  // --- HÀM XÓA BÀI HÁT (Sử dụng _userRepository) ---
  Future<void> removeSongFromCurrentPlaylist(Song songToRemove, BuildContext context) async {
    if (_currentViewingPlaylist == null) {
       Get.snackbar('Error', 'Cannot identify the current playlist.', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    if (isRemovingSong.value) return;

    // final confirm = await Get.dialog<bool>( /* ... Dialog xác nhận ... */
    //    AlertDialog(
    //      title: const Text('Confirm Removal'),
    //      content: Text('Are you sure you want to remove "${songToRemove.title}" from this playlist?'),
    //      actions: [
    //        TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
    //        TextButton(
    //          onPressed: () => Get.back(result: true),
    //          child: const Text('Remove', style: TextStyle(color: Colors.red)),
    //        ),
    //      ],
    //    ),
    //  );
    // if (confirm != true) return;

    isRemovingSong(true);
    print("Controller: Attempting to remove song '${songToRemove.title}' (ID: ${songToRemove.id}) from playlist ID: ${_currentViewingPlaylist!.id}");

    try {
      // *** GỌI HÀM TỪ UserRepository ***
      bool success = await _userRepository.removeTrackFromPlaylist(
        _currentViewingPlaylist!.id,
        songToRemove.id,
      );

      if (success) {
        print("Controller: Backend confirmed removal. Updating local list.");
        songsInCurrentPlaylist.removeWhere((song) => song.id == songToRemove.id);
        _currentViewingPlaylist!.trackIds.removeWhere((id) => id.toString() == songToRemove.id); // Cập nhật list ID local
        Get.snackbar('Success', '"${songToRemove.title}" removed.', snackPosition: SnackPosition.BOTTOM);
      } else {
         print("Controller: Backend indicated failure or error during removal.");
        Get.snackbar('Error', 'Failed to remove song. Please try again.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Lỗi bắt được từ handleCall trong Repository hoặc lỗi khác
       print("Controller: Error during removeSongFromCurrentPlaylist: $e");
      // Có thể kiểm tra kiểu lỗi để hiển thị thông báo cụ thể hơn
      Get.snackbar('Error', 'An unexpected error occurred.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isRemovingSong(false);
    }
  }

  Future<void> deletePlaylist(Playlist playlistToDelete) async {
    // --- Hiển thị dialog xác nhận ---
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete the playlist "${playlistToDelete.name}"?\nThis action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false), // Đóng dialog, trả về false
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true), // Đóng dialog, trả về true
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Nếu người dùng không xác nhận (nhấn Cancel hoặc đóng dialog)
    if (confirm != true) {
      return; // Dừng hàm
    }

    // --- Nếu xác nhận ---
    if (isDeletingPlaylist.value) return; // Ngăn chặn nhấn nhiều lần

    isDeletingPlaylist(true); // Bắt đầu trạng thái loading
    print("Controller: Attempting to delete playlist '${playlistToDelete.name}' (ID: ${playlistToDelete.id})");

    try {
      // Gọi hàm xóa từ repository
      bool success = await _userRepository.deletePlaylist(playlistToDelete.id);

      if (success) {
        print("Controller: Playlist deleted successfully from backend.");
        // 1. Đóng Bottom Sheet (nếu đang mở) - không cần thiết nếu gọi từ dialog
        // Get.back();
        // 2. Quay lại màn hình trước đó (ví dụ: màn hình danh sách playlist)
        Get.back();
        // 3. Hiển thị Snackbar thành công
        Get.snackbar(
          'Success',
          'Playlist "${playlistToDelete.name}" deleted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // 4. (Quan trọng) Cập nhật lại danh sách playlist trên màn hình trước đó
        // Giả sử bạn có một controller quản lý danh sách playlist chính (ví dụ: LibraryController)
        // Cần tìm và gọi lại hàm fetch của controller đó.
        // Ví dụ:
        // try {
        //   final libraryController = Get.find<LibraryController>(); // Thay LibraryController bằng tên đúng
        //   libraryController.fetchPlaylists(); // Gọi hàm fetch lại list
        // } catch (e) {
        //    print("Could not find LibraryController to refresh playlists: $e");
        // }
        // Hoặc bạn có thể cập nhật trực tiếp list playlists trong controller này nếu nó quản lý cả list chính
         playlists.removeWhere((p) => p.id == playlistToDelete.id);


      } else {
        print("Controller: Backend indicated failure during playlist deletion.");
        // Hiển thị Snackbar lỗi (Backend trả về false nhưng không phải exception)
        Get.snackbar(
          'Error',
          'Failed to delete playlist. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Lỗi bắt được từ handleCall trong Repository hoặc lỗi mạng, 403,...
      print("Controller: Error during deletePlaylist: $e");
      // Hiển thị Snackbar lỗi chung
      Get.snackbar(
        'Error',
        'An error occurred while deleting the playlist.', // Có thể hiển thị e.toString() nhưng thường không thân thiện
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isDeletingPlaylist(false); // Kết thúc trạng thái loading
    }
  }

  void addSongToPlaylist() {
    Get.toNamed(Routes.search); 
  }

  void showPlaylistOptionsBottomSheet(BuildContext context, {required Playlist playlist}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => PlaylistOptionsSheet(playlist: playlist),
    );
  }

  // Hàm hiển thị bottom sheet tùy chọn bài hát
  void showSongOptionsBottomSheet(BuildContext context, {required Song songData}) { // Thêm songData tùy chọn
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SongOptionsSheet(song: songData, // <--- Dòng 166 giờ sẽ hợp lệ
        onRemoveFromPlaylist: () {
             removeSongFromCurrentPlaylist(songData, context);
        }),
    );
  }
}