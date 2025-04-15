import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../controllers/songs_controller.dart';

class NowPlayingBinding implements Bindings {
  @override
  void dependencies() {
    // Lấy AudioPlayer đã được đăng ký từ AudioService
    final audioPlayer = Get.find<AudioPlayer>();

    // Lấy dữ liệu từ arguments
    final songs = Get.arguments['songs'];
    final currentSong = Get.arguments['playingSong']; // Sửa từ 'currentSong' thành 'playingSong'

    // Kiểm tra null và kiểu dữ liệu cho songs
    if (songs == null || songs is! List<Song>) {
      throw Exception("Songs list is missing or invalid");
    }

    // Kiểm tra null và kiểu dữ liệu cho currentSong
    if (currentSong == null || currentSong is! Song) {
      throw Exception("Current song is missing or invalid");
    }

    Get.lazyPut<NowPlayingController>(() => NowPlayingController(
      songs: songs,                     // 	Lấy danh sách bài hát từ dữ liệu truyền vào khi điều hướng (Get.to(...))
      currentSong: currentSong,      // Lấy bài hát hiện tại
      player: audioPlayer,              // Lấy một instance của AudioPlayer đã được đăng ký trước (ở nơi khác)
    ));
  }
}

// Bindings dùng để khai báo những controller hay service cần thiết trước khi chuyển đến một Route (trang/màn hình mới).