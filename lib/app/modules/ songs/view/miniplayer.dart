import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/song.dart';
import '../bindings/audio_service.dart';
import '../bindings/songs_binding.dart';
import 'songs_view.dart';

class MiniPlayer extends StatefulWidget {
  final Song song;
  final List<Song> songs;
  final VoidCallback onTap;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.songs,
    required this.onTap,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with SingleTickerProviderStateMixin {
  late final AudioPlayer _player;
  late int _selectedItemIndex;
  late Song _song;
  late AnimationController _imageAnimController;
  double _currentAnimationPosition = 0.0;
  bool _isShuffle = false;
  late LoopMode _loopMode;

  @override
  void initState() {
    super.initState();
    _player = Get.find<AudioPlayer>();
    _song = widget.song;
    _selectedItemIndex = widget.songs.indexWhere((s) => s.id == _song.id);
    _loopMode = _player.loopMode;
    _isShuffle = _player.shuffleModeEnabled;

    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );

    // đồng bộ phát âm thanh giữa audioService và _player
    final audioService = AudioService();
    if (audioService.currentPosition != null) {
      _player.seek(audioService.currentPosition!);
    }

    _setupPlayerListeners();
  }

  void _setupPlayerListeners() {
    _player.playerStateStream.listen((state) {
      if (state.playing) {
        _playRotationAnim();
      } else {
        _pauseRotationAnim();
      }

      if (state.processingState == ProcessingState.completed) {
        _setNextSong();
      }
    });
  }

  Future<void> _navigateToNowPlaying() async {
    final returnedSong = await Get.to<Song>(
          () => NowPlaying(playingSong: _song, songs: widget.songs),
      binding: NowPlayingBinding(),
      arguments: {
        'songs': widget.songs,
        'currentSong': _song,
      },
    );

    if (returnedSong != null) {
      setState(() {
        _song = returnedSong;
        _selectedItemIndex = widget.songs.indexWhere((s) => s.id == _song.id);
      });
    }
  }

  void _setNextSong() {
    if (_isShuffle) {
      _selectedItemIndex = _getRandomIndex(widget.songs.length);
    } else {
      _selectedItemIndex = (_selectedItemIndex + 1) % widget.songs.length;
    }

    _updateCurrentSong(widget.songs[_selectedItemIndex]);
  }

  void _setPreviousSong() {
    if (_isShuffle) {
      _selectedItemIndex = _getRandomIndex(widget.songs.length);
    } else {
      _selectedItemIndex = (_selectedItemIndex - 1) % widget.songs.length;
      if (_selectedItemIndex < 0) _selectedItemIndex = widget.songs.length - 1;
    }

    _updateCurrentSong(widget.songs[_selectedItemIndex]);
  }

  int _getRandomIndex(int length) {
    if (length <= 1) return 0;
    int newIndex;
    do {
      newIndex = Random().nextInt(length);
    } while (newIndex == _selectedItemIndex);
    return newIndex;
  }

  void _updateCurrentSong(Song newSong) async {
    try {
      await _player.setUrl(newSong.source);
      setState(() {
        _song = newSong;
      });
      Get.find<AudioService>().currentSong = newSong;
      _resetRotationAnim();
      await _player.play();
    } catch (e) {
      print('Error updating song: $e');
    }
  }

  void _togglePlayPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  void _playRotationAnim() {
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
  }

  void _pauseRotationAnim() {
    _imageAnimController.stop();
    _currentAnimationPosition = _imageAnimController.value;
  }

  void _resetRotationAnim() {
    _currentAnimationPosition = 0.0;
    _imageAnimController.value = _currentAnimationPosition;
  }

  @override
  void dispose() {
    _imageAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return GestureDetector(
      onTap: _navigateToNowPlaying,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 4 : 6,
          vertical: isSmallScreen ? 0 : 1,
        ),
        decoration: BoxDecoration(
          color: Colors.orange[100],
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: isSmallScreen ? 5 : 10,
              blurRadius: isSmallScreen ? 5 : 17,
            ),
          ],
        ),
        child: Row(
          children: [
            RotationTransition(
              turns: _imageAnimController,
              child: Container(
                width: isSmallScreen ? 20 : 35,
                height: isSmallScreen ? 20 : 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: _song.image.startsWith('http')
                        ? NetworkImage(_song.image) as ImageProvider
                        : const AssetImage("assets/image/img.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _song.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 10 : 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _song.artist,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isSmallScreen ? 8 : 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _setPreviousSong,
              icon: const Icon(Icons.skip_previous_outlined),
              iconSize: 30,
            ),
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snapshot) {
                final playing = snapshot.data?.playing ?? false;
                return IconButton(
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    size: 33,
                  ),
                  onPressed: _togglePlayPause,
                );
              },
            ),
            IconButton(
              onPressed: _setNextSong,
              icon: const Icon(Icons.skip_next_outlined),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}