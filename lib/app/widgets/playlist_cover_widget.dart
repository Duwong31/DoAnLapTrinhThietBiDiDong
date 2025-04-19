// lib/app/widgets/playlist_cover_widget.dart
import 'package:flutter/material.dart';
// Không cần import Repository/Model Song ở đây nữa

class PlaylistCoverWidget extends StatelessWidget {
  final String? firstTrackId;

  const PlaylistCoverWidget({Key? key, required this.firstTrackId}) : super(key: key);

  // Widget helper để hiển thị icon mặc định
  Widget _buildDefaultIcon() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: const Center(
        child: Icon(Icons.music_note_rounded, size: 40, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- Trường hợp 1: Không có track ID ---
    if (firstTrackId == null || firstTrackId!.isEmpty) {
      return _buildDefaultIcon();
    }

    // --- Trường hợp 2: Có track ID -> Tạo URL và hiển thị ảnh ---
    // Tạo URL ảnh trực tiếp từ ID
    final String imageUrl = 'https://thantrieu.com/resources/arts/$firstTrackId.webp';
    print("PlaylistCoverWidget: Generated image URL: $imageUrl");

    // Hiển thị ảnh bằng Image.network
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      // Vẫn giữ loadingBuilder và errorBuilder cho Image.network
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print("PlaylistCoverWidget: Error loading image $imageUrl: $error");
        return _buildDefaultIcon(); // Lỗi load ảnh -> Hiển thị icon mặc định
      },
    );
  }
}