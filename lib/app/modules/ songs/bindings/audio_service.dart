import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../controllers/songs_controller.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer player;
  Song? currentSong;
  List<Song> songs = [];
  Duration? currentPosition;
  int currentIndex = 0;
  bool _isShuffle = false;
  LoopMode _loopMode = LoopMode.off;
  final _currentSongController = StreamController<Song>.broadcast();      // Tạo stream broadcast để nhiều widget có thể lắng nghe cùng lúc (Khi bài hát thay đổi, gọi _currentSongController.add(currentSong!))


  Stream<PlayerState> get playerStateStream => player.playerStateStream;
  bool get isPlaying => player.playing;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;

  AudioService._internal() : player = AudioPlayer() {
    Get.put<AudioPlayer>(player, permanent: true);
    player.positionStream.listen((position) {
      currentPosition = position;
    });

    // Xử lý sự kiện khi bài hát kết thúc
    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one) {
          player.seek(Duration.zero);
          player.play();
        } else {
          _playNextSong();
        }
      }
    });

    // Đồng bộ dữ liệu từ AudioService sang NowPlayingController
    player.currentIndexStream.listen((index) {
      if (index != null && index < songs.length) {
        currentSong = songs[index];
        _currentSongController.add(currentSong!);
      }
    });
  }

  factory AudioService() => _instance;

  // Khởi tạo danh sách bài hát và phát bài hát đầu tiên
  Future<void> setPlaylist(List<Song> songs, {int startIndex = 0}) async {
    this.songs = songs;
    currentIndex = startIndex;
    currentSong = songs.isNotEmpty ? songs[startIndex] : null;

    final audioSources = songs
        .map((song) => AudioSource.uri(Uri.parse(song.source)))   // Chuyển đổi danh sách bài hát thành AudioSource
        .toList();

    await player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: startIndex,     // Lưu vị trí bài hát hiện tại và index
    );

    if (currentPosition != null) {
      await player.seek(currentPosition!);
    }
  }

  // Phát bài hát tiếp theo
  Future<void> _playNextSong() async {
    if (songs.isEmpty) return;

    if (_isShuffle) {
      currentIndex = _getRandomIndex();
    } else {
      currentIndex = (currentIndex + 1) % songs.length;
    }

    await player.seek(Duration.zero, index: currentIndex);
    currentSong = songs[currentIndex];
    await player.play();

    Get.find<NowPlayingController>().update();
  }

  // Phát bài hát trước đó
  Future<void> _playPreviousSong() async {
    if (songs.isEmpty) return;

    if (_isShuffle) {
      currentIndex = _getRandomIndex();
    } else {
      currentIndex = (currentIndex - 1) % songs.length;
      if (currentIndex < 0) currentIndex = songs.length - 1;
    }

    await player.seek(Duration.zero, index: currentIndex);
    currentSong = songs[currentIndex];
    await player.play();

    Get.find<NowPlayingController>().update();
  }

  // Lấy chỉ số ngẫu nhiên
  int _getRandomIndex() {
    if (songs.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = Random().nextInt(songs.length);
    } while (newIndex == currentIndex);
    return newIndex;
  }

  // Đặt bài hát mới
  Future<void> setSong(String url, {required Song song}) async {
    if (url.isEmpty) throw Exception('Invalid URL');
    if (currentSong?.id != song.id) {
      await player.setUrl(url);
      currentSong = song;
    }
    if (currentPosition != null) {
      await player.seek(currentPosition!);
    }
  }

  // Tắt chế độ shuffle
  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  // Đặt chế độ shuffle
  void setShuffle(bool isShuffle) {
    _isShuffle = isShuffle;
    player.setShuffleModeEnabled(isShuffle);
  }

  void setLoopMode(LoopMode loopMode) {
    _loopMode = loopMode;
    player.setLoopMode(loopMode);
  }

  // Hủy bỏ Stream và giải phóng tài nguyên
  Future<void> dispose() async {
    await _currentSongController.close();
    await player.dispose();
  }

  Stream<Song> get currentSongStream => _currentSongController.stream;
  Future<void> playNextSong() => _playNextSong();
  Future<void> playPreviousSong() => _playPreviousSong();
}