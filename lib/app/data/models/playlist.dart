// C:\work\SoundFlow\lib\app\data\models\playlist.dart
import 'package:flutter/foundation.dart'; // Cho listEquals

class Playlist {
  final int id;         
  final String name;       
  final List<dynamic> trackIds;

  Playlist({
    required this.id,
    required this.name,
    this.trackIds = const [], // Mặc định là list rỗng
  });

  // Getter tiện lợi để lấy ID của track đầu tiên (nếu có)
  // Trả về String? (có thể null nếu không có track)
  String? get firstTrackId {
    if (trackIds.isNotEmpty && trackIds.first != null) {
      // Chuyển đổi ID sang String một cách an toàn
      return trackIds.first.toString();
    }
    return null; // Trả về null nếu list rỗng hoặc phần tử đầu là null
  }

  // Hàm tạo factory để parse dữ liệu từ Map (thường là JSON từ API)
  factory Playlist.fromMap(Map<String, dynamic> map) {
    // Log dữ liệu map nhận được để debug
    // print("Parsing Playlist from map: $map");

    List<dynamic> ids = []; // Khởi tạo list rỗng

    // Kiểm tra an toàn trước khi truy cập metadata và track_ids
    if (map['metadata'] != null && map['metadata'] is Map) {
      final meta = map['metadata'] as Map<String, dynamic>;
      if (meta['track_ids'] != null && meta['track_ids'] is List) {
        ids = meta['track_ids'] as List<dynamic>;
        // print("Found track_ids: $ids");
      } else {
        // print("metadata found, but 'track_ids' is missing or not a List.");
      }
    } else {
      // print("metadata field is missing or not a Map.");
    }

    return Playlist(
      // Lấy id từ map, đảm bảo là int, fallback về 0 nếu null hoặc lỗi parse
      id: map['id'] is int ? map['id'] : (int.tryParse(map['id']?.toString() ?? '0') ?? 0),
      // Lấy name, fallback về 'Untitled Playlist' nếu null
      name: map['name']?.toString() ?? 'Untitled Playlist',
      // Gán list trackIds đã lấy được
      trackIds: ids,
    );
  }

  // (Tùy chọn) Ghi đè phương thức == và hashCode để so sánh đối tượng
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Playlist &&
        other.id == id &&
        other.name == name &&
        listEquals(other.trackIds, trackIds);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ trackIds.hashCode;
  int get trackCount => trackIds.length;
  
   @override
   String toString() {
      return 'Playlist(id: $id, name: $name, trackIds: $trackIds)';
   }
}