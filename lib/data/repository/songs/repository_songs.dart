import '../../models/songs/all_songs.dart';
import '../../sources/songs/source_songs.dart';

abstract interface class Repository{
  Future<List<Song>?> loadData();
}

class DefaultRepository implements Repository{
  final _localDataSource = LocalDataSource();
  final _remoteDataSource = RemoteDataSource();

  @override
  Future<List<Song>?> loadData() async{
    List<Song> songs = [];
    await _remoteDataSource.loadData().then((remoteSongs) {
      if(remoteSongs != null){
        _localDataSource.loadData().then((localSongs) {
          if(localSongs != null){
            songs = remoteSongs + localSongs;
          }
        });
      }else{
        songs.addAll(remoteSongs!.toList());
      }
    });
    return songs;
  }
}
