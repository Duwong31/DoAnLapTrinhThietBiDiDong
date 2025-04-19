import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../controllers/albumnow_controller.dart';

class AlbumNow extends GetView<AlbumNowController> {
  const AlbumNow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AlbumNowController>(
      builder: (controller) {
        if (controller.isLoading.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final album = controller.album;
        final songs = controller.songs;

        return Scaffold(
          appBar: AppBar(
            title: Text(album['name'] ?? 'Album'),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album Info
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          (album['images'] != null && album['images'].isNotEmpty)
                              ? album['images'][0]['url'] ?? ''
                              : '',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.error),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(album['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(
                              (album['artists'] != null && album['artists'].isNotEmpty)
                                  ? album['artists'][0]['name'] ?? 'Unknown Artist'
                                  : 'Unknown Artist',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${album['total_tracks']} tracks • ${album['release_date']}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                // Songs List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.music_note),
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: Text(
                        "${(song.duration / 60000).toStringAsFixed(2)} min",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        print('Tapped on: ${song.title}');
                        // TODO: Play preview or navigate
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}