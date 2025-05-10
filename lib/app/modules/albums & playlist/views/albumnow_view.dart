import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/albumnow_controller.dart';

class AlbumNow extends GetView<AlbumNowController> {
  const AlbumNow({super.key});

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

        // Kiểm tra album rỗng
        if (album.isEmpty) {
          return const Scaffold(
            body: Center(
              child: Text("Album information not found."),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            elevation: 0.1,
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              album['name'] ?? 'Album',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 20,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Dimes.width10,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(album['name'] ?? '',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Dimes.height8,
                            Text(
                              (album['artists'] != null && album['artists'].isNotEmpty)
                                  ? album['artists'][0]['name'] ?? 'Unknown Artist'
                                  : 'Unknown Artist',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Dimes.height8,
                            Text(
                              '${album['total_tracks'] ?? 0} tracks • ${album['release_date'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          song.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.music_note),
                        ),
                      ),
                      title: Text(song.title),
                      subtitle: Text(song.artist),
                      trailing: Text(
                        "${(song.duration / 60000).toStringAsFixed(2)} min",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        // Get.toNamed(Routes.songs_view);
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
