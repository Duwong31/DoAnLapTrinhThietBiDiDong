import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../bindings/favorite_bindings.dart';
import '../controller/favorite_controller.dart';

class FavoriteView extends StatefulWidget {
  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final FavoriteController _controller = Get.find<FavoriteController>();

  @override
  void initState() {
    super.initState();
    _controller.fetchFavoriteSongs();
    ever(_controller.favoriteSongIds, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    FavoriteBinding().dependencies();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Favorite tracks',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.labelColor, size: 30),
              onPressed: _controller.refreshFavorites,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(Icons.search, size: 30),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: _controller.searchSongs,
                      decoration: const InputDecoration(
                        hintText: "Search Tracks",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }

              if (_controller.filteredSongs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No liked tracks',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (_controller.searchKeyword.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'No results found for "${_controller.searchKeyword.value}"',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _controller.refreshFavorites,
                color: Theme.of(context).primaryColor,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _controller.filteredSongs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final song = _controller.filteredSongs[index];
                    return Dismissible(
                      key: Key(song.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          await _controller.toggleFavorite(song.id);
                          return false;
                        }
                        return false;
                      },
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Get.toNamed(
                            Routes.songs_view,
                            arguments: {
                              'playingSong': song.copyWith(
                                isFavorite: _controller.isFavorite(song.id),
                              ),
                              'songs': _controller.filteredSongs,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).cardColor,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: song.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  width: 50,
                                  height: 50,
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.music_note,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            title: Text(
                              song.title,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              song.artist,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Obx(() {
                              final isFav = _controller.isFavorite(song.id);
                              return IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    key: ValueKey<bool>(isFav),
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                ),
                                onPressed: () => _controller.toggleFavorite(song.id),
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}