import '../../../models/song.dart';
import '../sources/source_songs.dart';

abstract interface class Repository {
  Future<List<Song>?> loadData({int page, int perPage});
}

class DefaultRepository implements Repository {
  // final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadData({int page = 1, int perPage = 10}) async {
    List<Song> songs = [];

    final remoteSongs = await _remoteDataSource.loadData(page: page, perPage: perPage);
    // final localSongs = await _localDataSource.loadData(page: page, perPage: perPage);

    if (remoteSongs != null) {
      songs.addAll(remoteSongs);
    }

    // if (localSongs != null) {
    //   songs.addAll(localSongs);
    // }

    return songs;
  }
}
