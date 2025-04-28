import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../controllers/songs_controller.dart';

class NowPlayingBinding implements Bindings {
  @override
  void dependencies() {
    // Lấy AudioPlayer đã được đăng ký từ AudioService
    final audioPlayer = Get.find<AudioPlayer>();

    final songs = Get.arguments['songs'];
    // Kiểm tra cả 2 key 'playingSong' và 'currentSong'
    final playingSong = Get.arguments['playingSong'] ?? Get.arguments['currentSong'];

    if (songs == null || songs is! List<Song>) {
      throw Exception("Songs list is missing or invalid");
    }
    if (playingSong == null || playingSong is! Song) {
      throw Exception("Current song is missing or invalid");
    }

    Get.lazyPut<NowPlayingController>(() => NowPlayingController(
      songs: songs,                        // Lấy danh sách bài hát từ dữ liệu truyền vào khi điều hướng (Get.to(...))
      currentSong: playingSong,           // Lấy bài hát hiện tại
      player: audioPlayer,                // Lấy một instance của AudioPlayer đã được đăng ký trước (ở nơi khác)
    ));
  }
}

// Bindings dùng để khai báo những controller hay service cần thiết trước khi chuyển đến một Route (trang/màn hình mới).