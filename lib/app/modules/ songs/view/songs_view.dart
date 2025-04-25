import 'package:flutter/cupertino.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../models/duration_state.dart';
import '../../../../models/song.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../bindings/audio_service.dart';
import '../controllers/songs_controller.dart';

class NowPlaying extends StatelessWidget {
  final Song playingSong;
  final List<Song> songs;

  const NowPlaying({
    super.key,
    required this.playingSong,
    required this.songs,
  });

  factory NowPlaying.fromRoute() {
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};

    // Kiểm tra playingSong
    if (arguments['playingSong'] == null || arguments['playingSong'] is! Song) {
      throw Exception("Invalid song data");
    }
    // Kiểm tra songs
    if (arguments['songs'] == null || arguments['songs'] is! List<Song>) {
      throw Exception("Invalid songs list data");
    }
    return NowPlaying(
      playingSong: arguments['playingSong'] as Song,
      songs: arguments['songs'] as List<Song>,
    );
  }


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

class _NowPlayingPageState extends State<NowPlayingPage> {
  late final NowPlayingController _controller = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initAudioPlayer().then((_) {
        _controller.playRotationAnim();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;

    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: CupertinoNavigationBar(
        trailing: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: IconButton(
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                items: [
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.download),
                      title: Text("Download"),
                    ),
                    onTap: () {

                    },
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.playlist_add),
                      title: Text("Add to playlist"),
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.person),
                      title: Text("View artist"),
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.block),
                      title: Text("Block"),
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: const ListTile(
                      leading: Icon(Icons.report),
                      title: Text("Report error"),
                    ),
                    onTap: () {},
                  ),
                ],
              );
            },
            icon: const Icon(Icons.more_horiz),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context, _controller.song);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 40,
            ),
          ),
        ),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: Themes(),
        ),

        // Đĩa hình tròn cho nền
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 25, top: 100),
            child: GetBuilder<NowPlayingController>(
              builder: (controller) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<Song>(            // sử dụng Stream để đồng bộ (tự động cập nhật khi có thay đổi)
                      stream: controller.currentSongStream,
                      initialData: controller.song,
                      builder: (context, snapshot) {
                        final song = snapshot.data!;
                        return RotationTransition(
                          turns: controller.imageAnimController.drive(
                            Tween(begin: 0.0, end: 1.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(radius),
                            child: FadeInImage(
                              placeholder: const AssetImage("assets/image/img.png"),
                              image: song.image.startsWith('http')
                                  ? NetworkImage(song.image)
                                  : const AssetImage("assets/image/img.png") as ImageProvider,
                              width: screenWidth - delta,
                              height: screenWidth - delta,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                                "assets/image/img.png",
                                width: screenWidth - delta,
                                height: screenWidth - delta,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.share_rounded,
                                size: 20,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                            const SizedBox(width: 10),
                            StreamBuilder<Song>(
                              stream: _controller.currentSongStream,
                              initialData: _controller.song,
                              builder: (context, snapshot) {
                                final song = snapshot.data!;
                                return Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        song.title,
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          color: Theme.of(context).textTheme.bodyMedium!.color,
                                          fontFamily: 'Roboto',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Center(
                                        child: Text(
                                          song.artist,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: Theme.of(context).textTheme.bodyMedium!.color,
                                            fontFamily: 'Roboto',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                size: 20,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 20),
                      child: StreamBuilder<DurationState>(                // sử dụng Stream để đồng bộ (tự động cập nhật khi có thay đổi)
                        stream: Stream.periodic(const Duration(milliseconds: 100), (_) => DurationState(
                          progress: controller.player.position,
                          buffered: controller.player.bufferedPosition,
                          total: controller.player.duration ?? Duration.zero,
                        )),
                        builder: (context, snapshot) {
                          if (!controller.isPlayerReady || !snapshot.hasData) {
                            return ProgressBar(
                              progress: Duration.zero,
                              buffered: Duration.zero,
                              total: Duration.zero,
                              timeLabelTextStyle: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                                fontSize: 12,
                              ),
                            );
                          }

                          final durationState = snapshot.data!;
                          return ProgressBar(
                            progress: durationState.progress,
                            total: durationState.total,
                            buffered: durationState.buffered,
                            onSeek: (duration) => controller.player.seek(duration),
                            barHeight: 8.0,
                            barCapShape: BarCapShape.round,
                            baseBarColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
                            progressBarColor: Colors.white,
                            bufferedBarColor: Colors.grey.withAlpha((0.3 * 255).toInt()),
                            thumbColor: Colors.white,
                            thumbGlowColor: Colors.green.withAlpha((0.3 * 255).toInt()),
                            thumbRadius: 10.0,
                            timeLabelLocation: TimeLabelLocation.sides,
                            timeLabelTextStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 12),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                color: controller.isShuffle ? Colors.white : Colors.black,
                              ),
                              onPressed: controller.setShuffle,
                              iconSize: 35,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.skip_previous_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () => controller.setPreviousSong(widget.songs),
                              iconSize: 60,
                            ),
                            StreamBuilder<PlayerState>(
                              stream: controller.player.playerStateStream,
                              builder: (context, snapshot) {
                                if (!controller.isPlayerReady || !snapshot.hasData) {
                                  return Container(
                                    margin: const EdgeInsets.all(1.0),
                                    width: 48,
                                    height: 48,
                                    child: const CircularProgressIndicator(),
                                  );
                                }

                                final playState = snapshot.data!;
                                final processingState = playState.processingState;
                                final playing = playState.playing;

                                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
                                  return Container(
                                    margin: const EdgeInsets.all(1.0),
                                    width: 48,
                                    height: 48,
                                    child: const CircularProgressIndicator(),
                                  );
                                }

                                if (processingState == ProcessingState.completed) {
                                  // controller.stopRotationAnim();
                                  controller.setNextSong(widget.songs);
                                  return IconButton(
                                    icon: const Icon(Icons.replay, color: Colors.black),
                                    onPressed: () async {
                                      await controller.player.seek(Duration.zero);
                                      await controller.player.play();
                                      controller.playRotationAnim();
                                    },
                                    iconSize: 48,
                                  );
                                }
                                return IconButton(
                                  icon: Icon(
                                    playing ? Icons.pause : Icons.play_arrow_sharp,
                                    color: Colors.black,
                                  ),
                                  onPressed: () async {
                                    if (playing) {
                                      await controller.player.pause();
                                      controller.pauseRotationAnim();
                                    } else {
                                      await controller.player.play();
                                      controller.playRotationAnim();
                                    }
                                  },
                                  iconSize: 48,
                                );
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.skip_next_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () => controller.setNextSong(widget.songs),
                              iconSize: 60,
                            ),
                            IconButton(
                              icon: Icon(
                                controller.loopMode == LoopMode.one
                                    ? Icons.repeat_one
                                    : controller.loopMode == LoopMode.all
                                    ? Icons.repeat_on_outlined
                                    : Icons.repeat,
                                color: controller.loopMode == LoopMode.off ? Colors.black : Colors.white,
                              ),
                              onPressed: controller.setRepeatSong,
                              iconSize: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}