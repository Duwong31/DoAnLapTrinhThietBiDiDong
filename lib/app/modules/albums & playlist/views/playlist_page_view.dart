// C:\work\SoundFlow\lib\app\modules\albums & playlist\views\playlist_page_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/playlist_cover_widget.dart';
import '../controllers/playlist_page_controller.dart';
import '../../../data/models/playlist.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key}) : super(key: key);

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final PlayListController controller = Get.find<PlayListController>();
  late final List<Song> _songs = [];
  Song? _currentlyPlaying;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'PlayList',
          style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Theme.of(context).iconTheme.color),
            tooltip: 'Refresh',
            onPressed: () => controller.fetchPlaylists(),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Obx(() {
              if (controller.isLoadingPlaylists.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.playlists.isEmpty) {
                return const Center(child: Text("No playlists found."));
              }
              return _buildLazyGridView(context);
            }),
          ),
          StreamBuilder<Song>(
            stream: AudioService().currentSongStream,
            builder: (context, snapshot) {
              final current = snapshot.data ?? AudioService().currentSong;
              if (current == null) return const SizedBox.shrink();
              return Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: MiniPlayer(
                  key: ValueKey(current.id),
                  song: current,
                  songs: _songs,
                  onTap: () async {
                    final returnedSong = await Get.toNamed(
                      Routes.songs_view,
                      arguments: {'playingSong': current, 'songs': _songs},
                    );
                    setState(() {
                      _currentlyPlaying = returnedSong ?? AudioService().currentSong;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLazyGridView(BuildContext context) {
    final items = controller.playlists;

    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final Playlist item = items[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.playlistnow, arguments: item);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: PlaylistCoverWidget(firstTrackId: item.firstTrackId),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
