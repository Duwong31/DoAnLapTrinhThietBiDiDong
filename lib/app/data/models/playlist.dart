
class Playlist {
  final String title;
  final String imageUrl;
  // Thêm các thuộc tính khác(ví dụ: id, description, list<Song>)

  Playlist({required this.title, required this.imageUrl});

  // factory constructor fromJson nếu lấy dữ liệu từ API
  // factory Playlist.fromJson(Map<String, dynamic> json) {
  //   return Playlist(
  //     title: json['title'] ?? 'No Title',
  //     imageUrl: json['image_url'] ?? 'default_image_url',
  //   );
  // }
}