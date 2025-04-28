class ArtistModel {
  final String id;
  final String name;
  final String imageUrl;
  final String spotifyUrl;
  final int followers;
  final int popularity;
  final List<String> genres;

  ArtistModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.spotifyUrl,
    required this.followers,
    required this.popularity,
    required this.genres,
  });

  factory ArtistModel.fromJson(Map<String, dynamic> json) {
    return ArtistModel(
      id: json['id'] as String? ?? 'N/A',
      name: json['name'] as String? ?? 'Unknown Artist',
      imageUrl: (json['images'] as List?)?.isNotEmpty ?? false
          ? (json['images'][0]['url'] as String?)
          ?? 'https://i.scdn.co/image/ab6761610000e5eb8e5aec8c5a7e4a3e0d7a1b1a'
          : 'https://i.scdn.co/image/ab6761610000e5eb8e5aec8c5a7e4a3e0d7a1b1a',
      spotifyUrl: (json['external_urls'] as Map<String, dynamic>)?['spotify'] as String?
          ?? 'https://open.spotify.com',
      followers: (json['followers']?['total'] as int?) ?? 0,
      popularity: (json['popularity'] as int?) ?? 0,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}