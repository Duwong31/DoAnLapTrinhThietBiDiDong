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


  Stream<PlayerState> get playerStateStream => player.playerStateStream;
  bool get isPlaying => player.playing;
  bool get isShuffle => _isShuffle;
  LoopMode get loopMode => _loopMode;

  AudioService._internal() : player = AudioPlayer() {
    Get.put<AudioPlayer>(player, permanent: true);
    player.positionStream.listen((position) {
      currentPosition = position;
    });

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
  }

  factory AudioService() => _instance;

  Future<void> setPlaylist(List<Song> songs, {int startIndex = 0}) async {
    this.songs = songs;
    currentIndex = startIndex;
    currentSong = songs.isNotEmpty ? songs[startIndex] : null;

    final audioSources = songs
        .map((song) => AudioSource.uri(Uri.parse(song.source)))
        .toList();

    await player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: startIndex,
    );

    if (currentPosition != null) {
      await player.seek(currentPosition!);
    }
  }

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

  int _getRandomIndex() {
    if (songs.length <= 1) return 0;
    int newIndex;
    do {
      newIndex = Random().nextInt(songs.length);
    } while (newIndex == currentIndex);
    return newIndex;
  }

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

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  void setShuffle(bool isShuffle) {
    _isShuffle = isShuffle;
    player.setShuffleModeEnabled(isShuffle);
  }

  void setLoopMode(LoopMode loopMode) {
    _loopMode = loopMode;
    player.setLoopMode(loopMode);
  }

  Future<void> playNextSong() => _playNextSong();
  Future<void> playPreviousSong() => _playPreviousSong();

  Future<void> dispose() async => await player.dispose();
}