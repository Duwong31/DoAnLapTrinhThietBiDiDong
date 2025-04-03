import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../common/widgets/ThemeData/themes.dart';
import '../../../data/models/songs/all_songs.dart';
import 'audio_player_manager.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key,required this.playingSong,required this.songs});

  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      playingSong: playingSong,
      songs: songs,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.playingSong,
    required this.songs,
  });

  final Song playingSong;
  final List<Song> songs;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _imageAnimController;
  late AudioPlayerManager _audioPlayerManager;
  late int _selectedItemIndex;
  late Song _song;
  double _currentAnimationPosition = 0.0;
  bool _isPlayerReady = false;


  @override
  void initState(){
    super.initState();
    _song = widget.playingSong;
    _selectedItemIndex = widget.songs.indexOf(widget.playingSong);

    _imageAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 12000),
    );

    _audioPlayerManager = AudioPlayerManager(songUrl: _song.source);
    _initAudioPlayer();

    // Sử dụng addPostFrameCallback để đảm bảo build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayerManager.init();
      if (mounted) setState(() {});
    });
  }

  // _initAudioPlayer
  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayerManager.init();
      if (mounted) {
        setState(() => _isPlayerReady = true);
      }
    } catch (e) {
      debugPrint('Player init error: $e');
      if (mounted) {
        setState(() => _isPlayerReady = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to initialize player'))
        );
      }
    }
  }

  @override
  void dispose() {
    _audioPlayerManager.dispose();
    _controller.dispose(); // Quan trọng: phải dispose controller
    _imageAnimController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;

      // thanh Tabbar
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent, // Đảm bảo Scaffold không che gradient
      navigationBar: CupertinoNavigationBar(
        trailing: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IconButton(
              onPressed: (){
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.download),
                        title: Text("Download"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.favorite_border),
                        title: Text("Add to my favorite"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.playlist_add),
                        title: Text("Add to playlist"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.comment),
                        title: Text("Comment"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.person),
                        title: Text("View artist"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.block),
                        title: Text("Block"),
                      ),
                      onTap: (){

                      },
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.report),
                        title: Text("Report error"),
                      ),
                      onTap: (){

                      },
                    ),
                  ],
                );
              },
              icon: Icon(Icons.more_horiz),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_down_outlined,
              size: 40,
              )
          ),
        ),
      ),

      // Đĩa và gán màu cho background từ filed themes.dart
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: Themes(),       // Áp dụng gradient từ themes.dart
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent, // Đảm bảo Scaffold không che gradient
          body: Padding(
            padding: const EdgeInsets.only(bottom: 25,top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage(
                      placeholder: AssetImage("assets/image/img.png"),
                      image: _song.image.startsWith('http')
                          ? NetworkImage(_song.image)
                          : AssetImage(_song.image) as ImageProvider,
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/image/img.png",
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),

                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.only(top: 30,left: 5,right: 5),
                  child: SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                            onPressed: (){

                            },
                            icon: Icon(
                              Icons.share_rounded,
                              size: 20,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                        ),

                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                _song.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                    fontFamily: 'Roboto',
                                    ),
                                maxLines: 2,  // Giới hạn số dòng
                                overflow: TextOverflow.ellipsis,  // Nếu quá dài thì cắt bỏ
                                ),
                              SizedBox(height: 5),
                              Center(
                                child: Text(
                                  _song.artist,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium!.color,
                                    fontFamily: 'Roboto',
                                    overflow: TextOverflow.ellipsis, // Nếu quá dài thì cắt bỏ
                                  ),
                                  maxLines: 2, // Giới hạn số dòng
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 10),
                        IconButton(
                            onPressed: (){

                            },
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              size: 20,
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                          )
                        )
                      ]
                    ),
                  ),
                ),

                // thanh điều khiển _progressBar
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30,
                      left: 30,
                      right: 30 ,
                      bottom: 20
                  ),
                  child: _progressBar(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                      bottom: 12
                  ),
                  child: _mediaButtons(),
                )
              ]
            ),
          ),
        ),
      )
    );
  }

  // thanh tiến trình _progressBar
  StreamBuilder<DurationState> _progressBar(){
    return StreamBuilder<DurationState>(
        stream: _audioPlayerManager.durationState,
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return ProgressBar(
              progress: Duration.zero,
              buffered: Duration.zero,
              total: Duration.zero,
            );
          }

          if (!_isPlayerReady) {
            return LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            );
          }

          final durationState = snapshot.data;
          final progress = durationState?.progress ?? Duration.zero;
          final buffered = durationState?.buffered ?? Duration.zero;
          final total = durationState?.total ?? _audioPlayerManager.player.duration ?? Duration.zero;

          // Thêm trạng thái loading nếu cần
          if (total == Duration.zero) {
            return LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
            );
          }

          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            onSeek: (duration) {
              if (total > Duration.zero) {
                _audioPlayerManager.player.seek(duration);
              }
            },
            barHeight: 8.0,
            barCapShape: BarCapShape.round,
            baseBarColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
            progressBarColor: Colors.white,
            bufferedBarColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
            thumbColor: Colors.white,
            thumbGlowColor: Colors.green.withAlpha((0.3 * 255).toInt()),
            thumbRadius: 10.0,
            timeLabelLocation: TimeLabelLocation.sides, // Hiển thị thời gian
            timeLabelTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 12,
          ));
        });
  }

  // _mediaButtons
  Widget _mediaButtons(){
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
              function: null,
              icon: Icons.shuffle,
              color: Colors.black,
              size: 35
          ),
          MediaButtonControl(
              function: _setPreviousSong,
              icon: Icons.skip_previous_outlined,
              color: Colors.black,
              size: 60
          ),
          _playButton(),
          MediaButtonControl(
              function: _setNextSong,
              icon: Icons.skip_next_outlined,
              color: Colors.black,
              size: 60
          ),
          MediaButtonControl(
              function: null,
              icon: Icons.repeat,
              color: Colors.black,
              size: 35
          ),
        ],
      ),
    );
  }

  // _playButton
  StreamBuilder<PlayerState> _playButton(){
    return StreamBuilder(
        stream: _audioPlayerManager.player.playerStateStream,
        builder: (context,snapshot){

          if (!_isPlayerReady) {
            return Container(
              margin: const EdgeInsets.all(1.0),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }

          final playState = snapshot.data;
          final processingState = playState?.processingState;
          final playing = playState?.playing;

          // Thêm trạng thái đang load metadata
          if (_audioPlayerManager.player.duration == null) {
            return Container(
              margin: const EdgeInsets.all(1.0),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }

          if(processingState == ProcessingState.loading || processingState == ProcessingState.buffering){
            _pauseRotationAnim();
            return Container(
              margin: const EdgeInsets.all(1.0),
              width: 48,
              height: 48,
              child: const CircularProgressIndicator(),
            );
          }
          else if (playing != true){
            return MediaButtonControl(
              function: (){
                _audioPlayerManager.player.play();
              },
              icon: Icons.play_arrow_sharp,
              color: Colors.black,
              size: 48,
            );
          }
          else if (processingState != ProcessingState.completed){
            _playRotationAnim();
            return MediaButtonControl(
              function: (){
                _audioPlayerManager.player.pause();
                _pauseRotationAnim();
              },
              icon: Icons.pause,
              color: Colors.black,
              size: 48,
            );
          }
          else{
            if(processingState == ProcessingState.completed){
              _stopRotationAnim();
              _resetRotationAnim();
            }
            return MediaButtonControl(
              function: (){
                _audioPlayerManager.player.seek(Duration.zero);
                _playRotationAnim();
              },
              icon: Icons.replay,
              color: Colors.black,
              size: 48,
            );
          }
        }
    );
  }

  // Chuyển nhạc về trước (bên trái)
  void _setNextSong(){
    ++_selectedItemIndex;
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _resetRotationAnim();
    setState(() {
      _song = nextSong;
    });
  }

  // chuyển nhạc về sau (bên phải)
  void _setPreviousSong(){
    --_selectedItemIndex;
    final nextSong = widget.songs[_selectedItemIndex];
    _audioPlayerManager.updateSongUrl(nextSong.source);
    _resetRotationAnim();
    setState(() {
      _song = nextSong;
    });
  }

  void _playRotationAnim(){
    _imageAnimController.forward(from: _currentAnimationPosition);
    _imageAnimController.repeat();
  }

  void _pauseRotationAnim(){
    _stopRotationAnim();
    _currentAnimationPosition = _imageAnimController.value;
  }

  void _stopRotationAnim(){
    _imageAnimController.stop();
  }

  void _resetRotationAnim(){
    _currentAnimationPosition = 0.0;
    _imageAnimController.value = _currentAnimationPosition;
  }
}



class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });

  final void Function()? function;
  final IconData icon;
  final Color color;
  final double size;

  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: widget.function,
        icon: Icon(widget.icon,color: widget.color),
        iconSize: widget.size,
        color: widget.color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
