import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  AudioPlayerManager({required this.songUrl});
  final AudioPlayer player = AudioPlayer();
  Stream<DurationState>? durationState;
  String songUrl;
  bool _isInitialized = false;


  Future <void> init() async {
    try{
      if (_isInitialized) return;

      // Cấu hình trình phát nhạc để phát bài hát từ songUrl
      await player.setAudioSource(            // setAudioSource: Cấu hình trình phát với URL của bài hát.
        AudioSource.uri(Uri.parse(songUrl)),
        preload: true,
      );
      await player.load();            // tải một trình phát phương tiện (như video, âm thanh) trước khi phát
      _isInitialized = true;


      // Quản lý tiến trình phát nhạc, buffered, và tổng thời gian bài hát
      durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
            (position, playbackEvent) => DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration,
        ),
      );
    }catch(e){
      debugPrint('Audio init error: $e');
      _isInitialized = false;
      rethrow;
    }
  }

  Future<void> updateSongUrl(String newSongUrl) async {
    if (songUrl == newSongUrl) return;

    songUrl = newSongUrl;
    _isInitialized = false;
    await init();
  }

  Future<void> dispose() async {
    await player.dispose();
    _isInitialized = false;
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    required this.total,
  });

  final Duration progress;  // Thời gian đã phát của bài hát
  final Duration buffered;  // Thời gian đã tải (buffered) của bài hát
  final Duration? total;    // Tổng thời lượng của bài hát
}
