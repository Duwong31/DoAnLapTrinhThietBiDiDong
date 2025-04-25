class SongCollection {
  final String id;
  final String title;
  final String album;             // Tên album chứa bài hát này
  final String artist;            // Nghệ sĩ/ca sĩ thể hiện bài hát
  final String source;
  final String image;
  final int duration;
  final List<Song> songs;

  SongCollection({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.image,
    required this.duration,
    required this.songs,
  });

  factory SongCollection.fromJson(Map<String, dynamic> json) {
    var songList = (json['songs'] as List)
        .map((songJson) => Song.fromJson(songJson))
        .toList();

    return SongCollection(
      id: json['id'],
      title: json['title'],
      album: json['album'],
      artist: json['artist'],
      source: json['source'],
      image: json['image'],
      duration: json['duration'],
      songs: songList,
    );
  }
}

class Song {
  final String id;
  final String title;
  final String album;
  final String artist;
  final String source;
  final String image;
  final int duration;

  Song({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.source,
    required this.image,
    required this.duration,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'],
      album: json['album'],
      artist: json['artist'],
      source: json['source'],
      image: json['image'],
      duration: int.tryParse(json['duration'].toString()) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Song{id: $id, title: $title, album: $album, artist: $artist, duration: $duration}';
  }
}



//
// class Song {
//   Song({
//     required this.id,
//     required this.title,
//     required this.album,
//     required this.artist,
//     required this.source,
//     required this.image,
//     required this.duration,       // Thời lượng bài hát
//   });
//
//   factory Song.fromJson(Map<String, dynamic> json) {
//     return Song(
//       id: json['id'].toString(),               // Đảm bảo id luôn là String
//       title: json['title'],
//       album: json['album'] ,
//       artist: json['artist'] ,
//       source: json['source'] ,
//       image: json['image'] ,
//       duration: int.tryParse(json['duration'].toString()) ?? 0,       // Tránh lỗi parse
//
//     );
//   }
//
//   String id;
//   String title;
//   String album;
//   String artist;
//   String source;
//   String image;
//   int duration;
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is Song && runtimeType == other.runtimeType && id == other.id;
//
//   @override
//   int get hashCode => id.hashCode;
//
//   @override
//   String toString() {
//     return 'Song{id: $id, title: $title, album: $album, artist: $artist, source: $source, image: $image, duration: $duration}';
//   }
// }
// phong song model
class SongModel {
  final String id;
  final String title;
  final int duration;
  final String source;
  final String artist;
  final String image;

  SongModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.source,
    required this.artist,
    required this.image,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['id']?.int() ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? 0,
      source: json['preview'] ?? '',
      artist: json['artist']?['name'] ?? '',
      image: json['album']?['cover_medium'] ?? '',
    );
  }
}