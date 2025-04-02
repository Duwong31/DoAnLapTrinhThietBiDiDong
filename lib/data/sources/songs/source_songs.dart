import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:soundflow/data/models/songs/all_songs.dart';
import 'package:http/http.dart' as http;

abstract interface class DataSource {
  Future<List<SongList>?> loadData();
}

class RemoteDataSource implements DataSource {
  @override
  Future<List<SongList>?> loadData() async {
    final url = 'https://thantrieu.com/resources/braniumapis/songs.json';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final bodyContent = utf8.decode(response.bodyBytes);
      var songWrapper = jsonDecode(bodyContent) as Map;
      var songList = songWrapper['songs'] as List;
      List<SongList> songs = songList.map((song) => SongList.fromJson(song)).toList();
      return songs;
    } else {
      return null;
    }
  }

}

class LocalDataSource implements DataSource {
  @override
  Future<List<SongList>?> loadData() async {
    final String response = await rootBundle.loadString('assets/json/all_song.json');
    final jsonBody = jsonDecode(response) as Map;
    final songList = jsonBody['songs'] as List;
    List<SongList> songs = songList.map((song) => SongList.fromJson(song)).toList();
    return songs;
  }

}