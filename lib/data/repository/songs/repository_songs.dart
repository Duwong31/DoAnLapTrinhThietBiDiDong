import '../../models/songs/all_songs.dart';
import '../../sources/songs/source_songs.dart';

abstract interface class Repository {
  Future<List<SongList>?> loadData();
}

class DefaultRepository implements Repository {
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<SongList>?> loadData() async {
    List<SongList> songs = [];
    await _remoteDataSource.loadData().then((remoteSongs) {
      if (remoteSongs == null) {
        _localDataSource.loadData().then((localSongs) {
          if (localSongs != null) {
            songs.addAll(localSongs);
          }
        });
      } else {
        songs.addAll(remoteSongs);
      }
    });
    return songs;
  }
}