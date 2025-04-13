import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../controllers/songs_controller.dart';

class NowPlayingBinding implements Bindings {
  @override
  void dependencies() {
    // Lấy AudioPlayer đã được đăng ký từ AudioService
    final audioPlayer = Get.find<AudioPlayer>();

    Get.lazyPut<NowPlayingController>(() => NowPlayingController(
      songs: Get.arguments['songs'],                        // 	Lấy danh sách bài hát từ dữ liệu truyền vào khi điều hướng (Get.to(...))
      currentSong: Get.arguments['currentSong'],        // Lấy bài hát hiện tại
      player: audioPlayer,              // Lấy một instance của AudioPlayer đã được đăng ký trước (ở nơi khác)
    ));
  }
}

// Bindings dùng để khai báo những controller hay service cần thiết trước khi chuyển đến một Route (trang/màn hình mới).