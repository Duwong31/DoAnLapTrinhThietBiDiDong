import 'dart:async';

import '../../data/models/songs/all_songs.dart';
import '../../data/repository/songs/repository_songs.dart';

class MusicAppViewModel {
  StreamController<List<SongList>> songStream = StreamController();

  void loadSongs() {
    final repository = DefaultRepository();
    repository.loadData().then((value) => songStream.add(value!));
  }
}