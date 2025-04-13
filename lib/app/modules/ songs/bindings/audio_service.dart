import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer player;
  Song? currentSong;
  Duration? currentPosition;

  AudioService._internal() : player = AudioPlayer(){
    // Đăng ký AudioPlayer với GetX
    Get.put<AudioPlayer>(player, permanent: true);

    // Nghe những thay đổi vị trí
    player.positionStream.listen((position) {
      currentPosition = position;
    });
  }

  factory AudioService() => _instance;

  Future<void> setSong(String url, {required Song song}) async {
    if (url.isEmpty) throw Exception('Invalid URL');
    if (currentSong?.id != song.id) {
      await player.setUrl(url);
      currentSong = song;
    }

    // Tiếp tục từ vị trí hiện tại nếu có thể
    if (currentPosition != null) {
      await player.seek(currentPosition!);
    }
  }

  Future<void> dispose() async => await player.dispose();
}