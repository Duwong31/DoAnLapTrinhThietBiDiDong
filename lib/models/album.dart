class AlbumModel {
  final String id;
  final String title;
  final String imageUrl;
  final String artist;

  AlbumModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.artist,
  });

  factory AlbumModel.fromSpotifyJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] ?? '',
      title: json['name'] ?? '',
      imageUrl: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['url'] ?? ''
          : '',
      artist: (json['artists'] != null && json['artists'].isNotEmpty)
          ? json['artists'][0]['name'] ?? ''
          : '',
    );
  }
}
