import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../models/duration_state.dart';

class AudioPlayerManager {
  AudioPlayerManager({required this.songUrl});
  final AudioPlayer player = AudioPlayer();
  Stream<DurationState>? durationState;
  String songUrl;
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      if (_isInitialized) return;
      await player.setAudioSource(AudioSource.uri(Uri.parse(songUrl)), preload: true);
      await player.load();
      _isInitialized = true;

      durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
            (position, playbackEvent) => DurationState(
          progress: position,
          buffered: playbackEvent.bufferedPosition,
          total: playbackEvent.duration!,
        ),
      );
    } catch (e) {
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

extension ImmediatePlayExtension on AudioPlayerManager {
  Future<void> playSongImmediately(String url) async {
    try {
      if (songUrl == url && player.playing) return;
      await updateSongUrl(url);
      await player.play();
    } catch (e) {
      debugPrint('Error playing song immediately: $e');
      rethrow;
    }
  }
}