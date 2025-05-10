class ListeningHistory {
  final String userId;
  final List<String> trackIds;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ListeningHistory({
    required this.userId,
    required this.trackIds,
    required this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory ListeningHistory.fromJson(Map<String, dynamic> json) {
    try {
      return ListeningHistory(
        userId: json['user_id']?.toString() ?? '',
        trackIds: List<String>.from(json['metadata']?['track_ids'] ?? []),
        metadata: json['metadata'] ?? {},
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      );
    } catch (e) {
      throw FormatException('Invalid ListeningHistory data: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'metadata': {
        'track_ids': trackIds,
        ...metadata,
      },
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // Phương thức tiện ích
  bool hasTrack(String trackId) => trackIds.contains(trackId);
  
  ListeningHistory copyWith({
    String? userId,
    List<String>? trackIds,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ListeningHistory(
      userId: userId ?? this.userId,
      trackIds: trackIds ?? this.trackIds,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 