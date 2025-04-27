import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Cho Snackbar và Colors

// Import models và repository
import '../../../../data/models/playlist.dart';
import '../../../../data/repositories/repositories.dart'; // Import UserRepository
import '../../../../routes/app_pages.dart'; // Cho điều hướng

class AddToPlaylistController extends GetxController {
  // --- Dependencies ---
  final UserRepository _userRepository = Get.find<UserRepository>();

  // --- State ---
  final RxBool isLoading = true.obs; // Loading danh sách playlist
  final RxList<Playlist> playlists = <Playlist>[].obs; // Danh sách playlist động
  final RxSet<int> selectedPlaylistIds = <int>{}.obs; // <--- THÊM LẠI: IDs của playlist được chọn
  final RxBool isAdding = false.obs; // <--- THÊM LẠI: Trạng thái cho nút Done (sẽ cần sau)
  String? _trackIdToAdd; // <--- THÊM LẠI: ID của track cần thêm (lấy từ arguments)

  // --- Lifecycle ---
  @override
  void onInit() {
    super.onInit();
    // Lấy trackId từ arguments (quan trọng cho bước tiếp theo, nhưng có thể bỏ qua nếu CHỈ test giao diện list)
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) {
      _trackIdToAdd = args;
      print("AddToPlaylistController: Received trackId to add: $_trackIdToAdd");
    } else {
       
    }
    fetchPlaylists(); 
  }

  // --- Methods ---

  // Fetch danh sách playlist
  Future<void> fetchPlaylists() async {
     try {
      isLoading(true);
      playlists.clear();
      selectedPlaylistIds.clear(); // Reset selection khi refresh list
      final fetchedPlaylists = await _userRepository.getPlaylists();
      playlists.assignAll(fetchedPlaylists);
      print("AddToPlaylistController: Fetched ${fetchedPlaylists.length} playlists.");
    } catch (e, stackTrace) {
      printError(info: "AddToPlaylistController: Error fetching playlists: $e\n$stackTrace");
      Get.snackbar('Error','Could not load your playlists.',snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // --- THÊM LẠI CÁC HÀM XỬ LÝ SELECTION ---

  // Chọn hoặc bỏ chọn một playlist
  void toggleSelection(int playlistId) {
    if (selectedPlaylistIds.contains(playlistId)) {
      selectedPlaylistIds.remove(playlistId);
    } else {
      selectedPlaylistIds.add(playlistId);
    }
    // selectedPlaylistIds.refresh(); // Không cần thiết cho RxSet
    print("AddToPlaylistController: Selected IDs: ${selectedPlaylistIds.toList()}");
  }

  // Xóa tất cả lựa chọn
  void clearSelection() {
    selectedPlaylistIds.clear();
    print("AddToPlaylistController: Selection cleared.");
  }

  Future<void> addTrackToSelectedPlaylists() async {
     // 1. Kiểm tra điều kiện đầu vào
     if (isAdding.value) return; // Ngăn chặn click nhiều lần
     if (_trackIdToAdd == null || _trackIdToAdd!.isEmpty) {
       Get.snackbar('Error', 'Cannot add track: Track information is missing.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
       return;
     }
     if (selectedPlaylistIds.isEmpty) {
       Get.snackbar('Info', 'Please select at least one playlist.', snackPosition: SnackPosition.BOTTOM);
       return;
     }

     // 2. Bắt đầu trạng thái loading
     isAdding(true);
     print("AddToPlaylistController: Attempting to add track '$_trackIdToAdd' to playlists: ${selectedPlaylistIds.toList()}");

     List<int> successfulAdds = [];
     List<int> failedAdds = [];
     List<int> alreadyExists = [];

     try {
        // 3. Gọi API cho từng playlist đã chọn song song
        final results = await Future.wait(selectedPlaylistIds.map((playlistId) {
          // Gọi hàm từ repository
          return _userRepository.addTrackToPlaylist(playlistId, _trackIdToAdd!);
          // Không cần try-catch ở đây vì handleCall trong repository đã xử lý exception thành AddTrackResult.failure
        }).toList()); // eagerError: false là mặc định, nó sẽ chạy hết dù có lỗi

        // 4. Xử lý kết quả trả về từ Future.wait
        int i = 0;
        for (final resultStatus in results) {
          final currentPlaylistId = selectedPlaylistIds.elementAt(i); // Lấy ID tương ứng
          switch (resultStatus) {
            case AddTrackResult.success:
              successfulAdds.add(currentPlaylistId);
              break;
            case AddTrackResult.alreadyExists:
              alreadyExists.add(currentPlaylistId);
              break;
            case AddTrackResult.failure:
            default: // Coi các trường hợp không xác định là failure
              failedAdds.add(currentPlaylistId);
              break;
          }
          i++;
        }

        print("AddToPlaylistController: Add results - Success: ${successfulAdds.length}, Exists: ${alreadyExists.length}, Failed: ${failedAdds.length}");

     } catch (e) {
        // Lỗi này không mong đợi vì handleCall đã xử lý, nhưng vẫn nên có để phòng ngừa
        printError(info:"AddToPlaylistController: Unexpected error during Future.wait for adding tracks: $e");
        // Giả sử tất cả đều lỗi nếu có lỗi ở đây
        failedAdds.addAll(selectedPlaylistIds.where((id) => !successfulAdds.contains(id) && !alreadyExists.contains(id)));
        Get.snackbar('Error', 'An unexpected error occurred while adding tracks.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
     } finally {
        // 5. Kết thúc trạng thái loading (luôn luôn)
        isAdding(false);
     }

    // 6. Hiển thị thông báo kết quả cho người dùng
    if (failedAdds.isEmpty && alreadyExists.isEmpty) { // Tất cả thành công
      Get.snackbar('Success', 'Track added to ${successfulAdds.length} playlist(s).', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      Get.back(); // Quay lại màn hình trước đó
    } else if (successfulAdds.isEmpty && failedAdds.isEmpty && alreadyExists.isNotEmpty) { // Tất cả đã tồn tại
      Get.snackbar('Info', 'Track already exists in the selected playlist(s).', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.blue, colorText: Colors.white);
      // Có thể Get.back() hoặc không tùy ý
    } else { // Có sự pha trộn kết quả
      String message = '';
      if (successfulAdds.isNotEmpty) message += '${successfulAdds.length} added. ';
      if (alreadyExists.isNotEmpty) message += '${alreadyExists.length} already exist. ';
      if (failedAdds.isNotEmpty) message += '${failedAdds.length} failed.';
      Get.snackbar('Action Result', message.trim(), snackPosition: SnackPosition.BOTTOM, backgroundColor: failedAdds.isNotEmpty ? Colors.orange : Colors.blue, colorText: Colors.white, duration: const Duration(seconds: 5));
      // Thường không Get.back() trong trường hợp này để user xem lại
    }
  }
  // Hàm xử lý khi nhấn nút "Done" (Tạm thời chỉ in ra)
  Future<void> handleDoneAction() async {
    if (isAdding.value) return;
    if (selectedPlaylistIds.isEmpty) {
      Get.snackbar('Info', 'Please select at least one playlist.', snackPosition: SnackPosition.BOTTOM);
      return;
    }
     if (_trackIdToAdd == null || _trackIdToAdd!.isEmpty) {
       Get.snackbar('Error', 'Cannot proceed: Track information is missing.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
       return;
     }

    print("AddToPlaylistController: 'Done' button pressed.");
    print("Track to add: $_trackIdToAdd");
    print("Selected playlist IDs: ${selectedPlaylistIds.toList()}");

    // *** TẠM THỜI CHƯA GỌI API ***
    // isAdding(true);
    // try {
    //   // Gọi API ở đây...
    // } catch (e) {
    //   // Xử lý lỗi
    // } finally {
    //   isAdding(false);
    // }
     Get.snackbar('Action', 'Proceeding to add track $_trackIdToAdd to ${selectedPlaylistIds.length} playlist(s)... (API call pending)', snackPosition: SnackPosition.BOTTOM);
     // TODO: Gọi hàm addTrackToSelectedPlaylists() thực sự khi sẵn sàng
  }

  // Hàm điều hướng tới trang tạo playlist
  void goToCreatePlaylist() {
    Get.toNamed(Routes.createNewPlaylist)?.then((didCreate) {
      if (didCreate == true) {
        print("AddToPlaylistController: New playlist created, refreshing list.");
        fetchPlaylists(); // Refresh lại danh sách
      }
    });
  }
}