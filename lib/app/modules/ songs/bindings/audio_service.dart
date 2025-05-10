import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../models/song.dart';
import '../../../data/repositories/history_repository.dart';
import '../../history/controllers/history_controller.dart';
import '../controllers/songs_controller.dart';

class AudioService extends GetxService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer player;         // player: giúp điều khiển phát, dừng, tua, lấy trạng thái phát, v.v.
  Song? currentSong;                // Bài hát hiện tại đang phát.
  List<Song> songs = [];            // Danh sách tất cả bài hát trong playlist.
  Duration? currentPosition;        // vị trí thời gian của bài hát
  int currentIndex = 0;             // Vị trí bài hát hiện tại trong danh sách songs
  bool _isShuffle = false;          // Có đang bật chế độ trộn bài (shuffle) hay không.
  LoopMode _loopMode = LoopMode.off;      // Chế độ lặp hiện tại (off, one, all)
  final _currentSongController = StreamController<Song>.broadcast();          // Tạo stream broadcast để nhiều widget có thể lắng nghe cùng lúc (Khi bài hát thay đổi, gọi _currentSongController.add(currentSong!))
  final _shuffleSubject = BehaviorSubject<bool>.seeded(false);                // Thêm BehaviorSubject để quản lý trạng thái shuffle(trộn)
  final _currentSongBehavior = BehaviorSubject<Song?>();

  final _playlistController = StreamController<List<Song>>.broadcast();       // cho phép nhiều listener (ví dụ các màn hình khác nhau) cùng lúc theo dõi danh sách bài hát hiện tại

  // Cung cấp danh sách songs
  List<Song> get currentPlaylist => songs;                                    //  Dùng để phát ra danh sách playlist mới mỗi khi có sự thay đổi.

  Stream<bool> get shuffleStream => _shuffleSubject.stream;                   // Stream dùng để lắng nghe trạng thái bật/tắt shuffle ( trộn bài ).
  Stream<Song> get currentSongStream => _currentSongController.stream;        // Stream cung cấp bài hát đang phát hiện tại (Dùng trong MiniPlayer để hiển thị bài hát hiện tại theo thời gian thực (StreamBuilder))
  Stream<PlayerState> get playerStateStream => player.playerStateStream;      // Stream trạng thái trình phát (playing, paused, completed, buffering, v.v.)
  bool get isPlaying => player.playing;                                       // Trả về true nếu trình phát đang phát nhạc.
  bool get isShuffle => _isShuffle;                                           // Getter cho trạng thái shuffle hiện tại (đang bật hay tắt)
  LoopMode get loopMode => _loopMode;                                         // Trả về trạng thái vòng lặp hiện tại: không lặp, lặp một bài, hoặc lặp danh sách

  //history
  Timer? _playbackTimer;
  bool _isTrackAddedToHistory = false;
  late final HistoryController _historyController;

  AudioService._internal() : player = AudioPlayer() {
    // Khởi tạo HistoryRepository nếu chưa tồn tại
    if (!Get.isRegistered<HistoryRepository>()) {
      Get.put(HistoryRepository(), permanent: true);
    }
    
    // Khởi tạo HistoryController nếu chưa tồn tại
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController(), permanent: true);
    }
    _historyController = Get.find<HistoryController>();
    
    Get.put<AudioPlayer>(player, permanent: true);
    player.positionStream.listen((position) {
      currentPosition = position;

      if (position.inSeconds >= 30 && !_isTrackAddedToHistory && currentSong != null) {
        _addToHistory(); 
      }
    });

    // Reset khi chuyển bài
    player.currentIndexStream.listen((index) {
      if (index != null && index < songs.length) {
        currentSong = songs[index];
        _currentSongController.add(currentSong!); // Cập nhật stream bài hát hiện tại
        _isTrackAddedToHistory = false; // QUAN TRỌNG: Reset cờ khi chuyển bài
      }
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

      _shuffleSubject.add(_isShuffle);
    });

    // Đồng bộ dữ liệu từ AudioService sang NowPlayingController
    player.currentIndexStream.listen((index) {
      if (index != null && index < songs.length) {
        currentSong = songs[index];
        _currentSongController.add(currentSong!); // Cập nhật stream
        _currentSongBehavior.add(currentSong); // Cập nhật BehaviorSubject
      }
    });
  }

  Future<void> _addToHistory() async {
    if (currentSong == null) return;
    
    try {
      _isTrackAddedToHistory = true; // Đặt cờ để tránh gọi lại cho cùng một lần phát
      await _historyController.addTrackToHistory(currentSong!.id);
      print('[AudioService] Added track ${currentSong!.id} to history after 30s playback');
    } catch (e) {
      print('[AudioService] Error adding track to history: $e');
      _isTrackAddedToHistory = false; // Reset cờ nếu có lỗi để có thể thử lại (cân nhắc)
    }
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

    // Thông báo cho các listener về danh sách phát đã cập nhật
    _playlistController.add(songs);
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
      _currentSongController.add(song); // Đảm bảo stream được cập nhật
      _currentSongBehavior.add(song); // Thêm dòng này
    }
    if (currentPosition != null) {
      await player.seek(currentPosition!);
    }
  }

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
    _shuffleSubject.add(isShuffle); // Cập nhật giá trị vào stream
  }

  void setLoopMode(LoopMode loopMode) {
    _loopMode = loopMode;
    player.setLoopMode(loopMode);
  }

  // Dừng phát nhạc
  Future<void> stop() async {
    await player.stop();
    currentSong = null;
  }

  // Xóa bài hát hiện tại
  void clearCurrentSong() {
    currentSong = null;
    _currentSongBehavior.add(null);
  }

  Future<void> playNextSong() => _playNextSong();
  Future<void> playPreviousSong() => _playPreviousSong();

  // Hủy bỏ Stream và giải phóng tài nguyên
  Future<void> dispose() async {
    await _currentSongController.close();
    await _shuffleSubject.close(); // Đóng stream khi dispose
    await _playlistController.close();
    await player.dispose();
    _playbackTimer?.cancel();
  }
}
