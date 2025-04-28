import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../bindings/audio_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NowPlayingController extends GetxController with SingleGetTickerProviderMixin{
  final AudioService _audioService = AudioService();
  late AnimationController _imageAnimController;
  double _currentAnimationPosition = 0.0;
  late List<Song> songs;
  late Song currentSong;
  List<String> favoriteSongIds = [];

  // Đồng bộ với AudioService
  Stream<Song> get currentSongStream => _audioService.currentSongStream;

  Song get song => _audioService.currentSong!;
  bool get isPlayerReady => _audioService.player.processingState == ProcessingState.ready;
  bool get isShuffle => _audioService.isShuffle;
  LoopMode get loopMode => _audioService.loopMode;
  AudioPlayer get player => _audioService.player;
  AnimationController get imageAnimController => _imageAnimController;    // Tạo animation controller cho hiệu ứng xoay

  NowPlayingController({
    required this.songs,
    required this.currentSong,
    required AudioPlayer player,
  });


  @override
  void onInit() {
    super.onInit();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _audioService.playerStateStream.listen((state) {
      if (state.playing) {
        _playRotationAnim();
      } else {
        _pauseRotationAnim();
      }
    });
  }

  @override
  void onClose() {
    _imageAnimController.dispose();
    super.onClose();
  }

  Future<void> initAudioPlayer() async {        // Xử lý phát nhạc
    try {
      final isSameSong = _audioService.currentSong?.id == currentSong.id;           // kiểm tra nếu bài hát hiện tại đã đúng rồi thì không cần set lại playlist
      if (!isSameSong) {
        await _audioService.setPlaylist(songs, startIndex: songs.indexOf(currentSong));
      } else {
        await _audioService.player.seek(_audioService.currentPosition ?? Duration.zero);
      }

      await _audioService.player.play();
      _playRotationAnim();
      update();
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing player: $e');
      }
    }
  }

  Future<void> fetchFavorites() async {
    final url = Uri.parse('https://your-api.com/favorites');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      favoriteSongIds = List<String>.from(data['favorites']);
      updateFavoritesInSongs();
    }
  }

  Future<void> toggleFavorite(String songId) async {
    final url = Uri.parse('https://your-api.com/favorites');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'song_id': songId}),
    );

    if (response.statusCode == 200) {
      favoriteSongIds.add(songId);
      updateFavoritesInSongs();
    } else {
      if (kDebugMode) {
        print('Failed to add favorite');
      }
    }
  }

  void updateFavoritesInSongs() {
    for (var song in songs) {
      song.isFavorite = favoriteSongIds.contains(song.id);
    }
  }

  void setRepeatSong() {
    final newMode = _audioService.loopMode == LoopMode.off
        ? LoopMode.one
        : _audioService.loopMode == LoopMode.one
        ? LoopMode.all
        : LoopMode.off;
    _audioService.setLoopMode(newMode);
    update();
  }

  void setShuffle() {
    _audioService.setShuffle(!_audioService.isShuffle);
    update();
  }

  void setNextSong(List<Song> songs) {
    _audioService.playNextSong();
    update();
  }

  void setPreviousSong(List<Song> songs) {
    _audioService.playPreviousSong();
    update();
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

  void playRotationAnim() => _playRotationAnim();
  void pauseRotationAnim() => _pauseRotationAnim();
}


