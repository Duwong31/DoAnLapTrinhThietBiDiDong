import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundflow/data/models/songs/all_songs.dart';
import 'package:soundflow/presentation/songs/songs_model.dart';

class AllSongsView extends StatefulWidget {
  const AllSongsView({super.key});

  @override
  State<AllSongsView> createState() => _AllSongsViewState();
}

class _AllSongsViewState extends State<AllSongsView> {
  List<SongList> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget getListView() {
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
        parent: this,
        song: songs[index]
    );
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      setState(() {
        songs.addAll(songList);
      });
    });
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({super.key, required this.parent, required this.song});

  final _AllSongsViewState parent;
  final SongList song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/userclone.png',
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/userclone.png',
              width: 48,
              height:  48,
            );
          },
        ),
      ),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
        icon: Icon(Icons.more_vert_outlined),
          onPressed: () {
          //
          },
      ),
    );
  }
}