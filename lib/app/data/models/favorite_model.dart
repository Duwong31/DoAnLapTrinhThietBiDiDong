import '../../core/styles/style.dart';

class FavoriteResponse {
  final bool success;
  final List<String> songIds;
  final String? message;

  FavoriteResponse({required this.success, required this.songIds, this.message});

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('Raw FavoriteResponse JSON: $json');
    try {
      return FavoriteResponse(
        success: json['success'] as bool? ?? false,
        songIds: List<String>.from(json['track_ids'] ?? json['song_ids'] ?? []),
        message: json['message'] as String?,
      );
    } catch (e) {
      debugPrint('Error parsing FavoriteResponse: $e');
      throw Exception('Invalid favorites response format');
    }
  }
}