class AlbumModel {
  final int id;
  final String title;
  final String imageUrl;
  final String artist;

  AlbumModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.artist,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      title: json['title'],
      imageUrl: json['cover_medium'],
      artist: json['artist']['name'],
    );
  }
}
