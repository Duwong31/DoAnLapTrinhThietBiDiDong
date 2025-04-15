import 'dart:math';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../bindings/audio_service.dart';

class NowPlayingController extends GetxController with SingleGetTickerProviderMixin {
  late final AnimationController _imageAnimController;        // Điều khiển animation liên quan đến hình ảnh (xoay đĩa)
  late final AudioPlayer _player;                             // Quản lý phát nhạc: play, pause , theo dõi trạng thái phát nhạc (đang tải, đang phát, lỗi).
  late int _selectedItemIndex;                                // Lưu vị trí (index) của bài hát đang được chọn trong danh sách
  late Song _song;                                            // Lưu trữ metadata của bài hát hiện tại: title, artist, duration, imageUrl, audioUrl, v.v
  double _currentAnimationPosition = 0.0;                     // Lưu giá trị hiện tại của animation
  bool _isPlayerReady = false;                                // kiểm tra xem trình phát nhạc đã sẵn sàng (true) hay chưa (false).
  bool _isShuffle = false;                                    //  kiểm tra chế độ true => phát ngẫu nhiên, false => không phát ngẫu nhiên
  late LoopMode _loopMode;                                    // Lưu chế độ lặp lại bài hát (off, one, all) từ LoopMode trong just_audio

  // Getters
  Song get song => _song;
  int get selectedIndex => _selectedItemIndex;
  bool get isPlayerReady => _isPlayerReady;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;
  AudioPlayer get player => _player;
  AnimationController get imageAnimController => _imageAnimController;
  double get currentAnimationPosition => _currentAnimationPosition;

  // Method getters
  Future<void> Function() get initAudioPlayer => _initAudioPlayer;
  void Function() get setRepeatSong => _setRepeatSong;
  void Function() get setShuffle => _setShuffle;
  void Function(List<Song> songs) get setNextSong => _setNextSong;
  void Function(List<Song> songs) get setPreviousSong => _setPreviousSong;
  void Function() get playRotationAnim => _playRotationAnim;
  void Function() get pauseRotationAnim => _pauseRotationAnim;
  void Function() get stopRotationAnim => _stopRotationAnim;

  NowPlayingController({
    required List<Song> songs,
    required Song currentSong,
    required AudioPlayer player,
  }) : _player = Get.find<AudioPlayer>()  {
    _song = currentSong;
    _selectedItemIndex = songs.indexWhere((s) => s.id == currentSong.id);
    _loopMode = _player.loopMode;
    _isShuffle = _player.shuffleModeEnabled;

    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Thêm repeat() ngay khi khởi tạo

    // Thêm listener
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.ready) {
        _isPlayerReady = true;
        update();
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    _player.playerStateStream.listen((state) {
      if (state.playing) {
        _playRotationAnim();
      } else {
        _pauseRotationAnim();
      }

      // Thêm listener xử lý khi bài hát kết thúc
      if (state.processingState == ProcessingState.completed) {
        if (_loopMode == LoopMode.one) {
          _player.seek(Duration.zero);
          _player.play();
        } else {
          _setNextSong(_song as List<Song>); // Truyền danh sách bài hát hiện tại
        }
      }
    });
  }

  @override
  void onClose() {
    _imageAnimController.dispose();
    super.onClose();
  }

  Future<void> _initAudioPlayer() async {
    try {
      final audioService = AudioService();

      // này là đồng bộ giữa audioService và _player
      // Chỉ đặt URL nếu đó là một bài hát khác
      if (_song.id != audioService.currentSong?.id) {
        await _player.setUrl(_song.source);
        audioService.currentSong = _song;
      }
      // Tiếp tục từ vị trí hiện tại
      if (audioService.currentPosition != null) {
        await _player.seek(audioService.currentPosition!);
      }

      await _player.play();
      _isPlayerReady = true;
      _playRotationAnim();
      update();
    } catch (e) {
      _isPlayerReady = false;
      update();
    }
  }


  // // Thêm hàm này để xử lý phát bài hát mới
  // void _playNewSong(Song song) async {
  //   try {
  //     await _player.setUrl(song.source);
  //     _song = song;
  //     _currentAnimationPosition = 0.0;
  //     await _player.play();
  //     _playRotationAnim();
  //     update();
  //   } catch (e) {
  //     print('Error playing song: $e');
  //   }
  // }

// Thêm hàm này để lấy index ngẫu nhiên (cho chế độ trộn bài)
  int _getRandomIndex(List<Song> songs) {
    if (songs.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = Random().nextInt(songs.length);
    } while (newIndex == _selectedItemIndex);
    return newIndex;
  }

  void _setRepeatSong() {
    if (_loopMode == LoopMode.off) {
      _loopMode = LoopMode.one;
    } else if (_loopMode == LoopMode.one) {
      _loopMode = LoopMode.all;
    } else {
      _loopMode = LoopMode.off;
    }
    _player.setLoopMode(_loopMode);
    update();
  }
  void _setShuffle() {
    _isShuffle = !_isShuffle;
    _player.setShuffleModeEnabled(_isShuffle);
    update();
  }


  void _setNextSong(List<Song> songs) {
    if (_isShuffle) {
      _selectedItemIndex = _getRandomIndex(songs);
    } else {
      _selectedItemIndex = (_selectedItemIndex + 1) % songs.length;
    }

    _updateCurrentSong(songs[_selectedItemIndex]);
  }

  void _setPreviousSong(List<Song> songs) {
    if (_isShuffle) {
      _selectedItemIndex = _getRandomIndex(songs);
    } else {
      _selectedItemIndex = (_selectedItemIndex - 1) % songs.length;
      if (_selectedItemIndex < 0) _selectedItemIndex = songs.length - 1;
    }

    _updateCurrentSong(songs[_selectedItemIndex]);
  }

  // Thêm phương thức helper mới
  void _updateCurrentSong(Song newSong) async {
    try {
      _song = newSong;          // Cập nhật bài hát hiện tại
      await _player.setUrl(newSong.source);
      await _player.play();
      _currentAnimationPosition = 0.0;
      _playRotationAnim();
      update();               // cập nhật UI
    } catch (e) {
      print('Error updating song: $e');
    }
  }

  void _playRotationAnim() {
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
    update();
  }

  void _pauseRotationAnim() {
    _imageAnimController.stop();
    _currentAnimationPosition = _imageAnimController.value;
    update();
  }

  void _stopRotationAnim() {
    _imageAnimController.stop();
  }
}