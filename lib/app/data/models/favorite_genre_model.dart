import 'package:flutter/foundation.dart';

class FavoriteGenreResponse {
  final int status;
  final FavoriteGenreData data;

  FavoriteGenreResponse({
    required this.status,
    required this.data,
  });

  factory FavoriteGenreResponse.fromJson(Map<String, dynamic> json) {
    debugPrint(">>> [FavoriteGenreResponse.fromJson] Raw JSON: $json");
    try {
      final result = FavoriteGenreResponse(
        status: json['status'] as int,
        data: FavoriteGenreData.fromJson(json['data'] as Map<String, dynamic>),
      );
      debugPrint(">>> [FavoriteGenreResponse.fromJson] Parsed result: $result");
      return result;
    } catch (e, stack) {
      debugPrint(">>> [FavoriteGenreResponse.fromJson] Error parsing: $e");
      debugPrint(">>> [FavoriteGenreResponse.fromJson] Stack trace: $stack");
      rethrow;
    }
  }

  @override
  String toString() {
    return 'FavoriteGenreResponse{status: $status, data: $data}';
  }
}

class FavoriteGenreData {
  final int userId;
  final String favoriteGenre;
  final Map<String, int> genreStats;
  final List<String> trackIds;

  FavoriteGenreData({
    required this.userId,
    required this.favoriteGenre,
    required this.genreStats,
    required this.trackIds,
  });

  factory FavoriteGenreData.fromJson(Map<String, dynamic> json) {
    debugPrint(">>> [FavoriteGenreData.fromJson] Raw JSON: $json");
    try {
      final result = FavoriteGenreData(
        userId: json['user_id'] as int,
        favoriteGenre: json['favorite_genre'] as String,
        genreStats: Map<String, int>.from(json['genre_stats'] as Map),
        trackIds: List<String>.from(json['track_ids'] as List),
      );
      debugPrint(">>> [FavoriteGenreData.fromJson] Parsed result: $result");
      return result;
    } catch (e, stack) {
      debugPrint(">>> [FavoriteGenreData.fromJson] Error parsing: $e");
      debugPrint(">>> [FavoriteGenreData.fromJson] Stack trace: $stack");
      rethrow;
    }
  }

  @override
  String toString() {
    return 'FavoriteGenreData{userId: $userId, favoriteGenre: $favoriteGenre, genreStats: $genreStats, trackIds: $trackIds}';
  }
} 