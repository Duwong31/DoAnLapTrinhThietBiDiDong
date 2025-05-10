import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../ songs/bindings/audio_service.dart';
import '../../ songs/view/MiniPlayer.dart';
import '../../home/controllers/home_controller.dart';
import '../../../../models/song.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/search_page_controller.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final SearchPageController controller = Get.put(SearchPageController());
  final AudioService _audioService = Get.find<AudioService>();
  final HomeController homeController = Get.find<HomeController>(); // Lưu dưới dạng biến instance
  late List<Song> _songs;

  @override
  void initState() {
    super.initState();
    _songs = homeController.songs.toList();
    if (_audioService.currentSong != null) {
      _navigateToMiniPlayer(_audioService.currentSong!, _audioService.currentPlaylist);
    }
  }

  Future<void> _navigateToMiniPlayer(Song song, List<Song> allSongs) async {
    await _audioService.setPlaylist(allSongs, startIndex: allSongs.indexOf(song));
    await _audioService.player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Obx(
                        () => Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).inputDecorationTheme.fillColor ??
                            Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              controller.isSearching.value ? Icons.arrow_back : Icons.search,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              controller.isSearching.value
                                  ? controller.stopSearch()
                                  : controller.startSearch();
                            },
                          ),
                          Expanded(
                            child: TextField(
                              controller: controller.searchTextController,
                              autofocus: controller.isSearching.value,
                              onTap: controller.startSearch,
                              onChanged: controller.onSearchChanged,
                              decoration: InputDecoration(
                                hintText: "search_hint".tr,
                                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimes.height20,
                  Obx(() => Expanded(
                    child: controller.isSearching.value
                        ? _buildSearchResultView()
                        : _buildDefaultView(),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "recent_searches".tr,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (controller.recentSearches.isNotEmpty)
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: Text("clear_all".tr, style: const TextStyle(color: Colors.red)),
              ),
          ],
        )),
        Dimes.height10,
        Obx(() {
          if (controller.recentSearches.isEmpty) {
            return Text("no_recent_searches".tr);
          }
          return Expanded(
            child: ListView.builder(
              itemCount: controller.recentSearches.length,
              itemBuilder: (context, index) {
                final searchItem = controller.recentSearches[index];
                return ListTile(
                  leading: Icon(Icons.history, color: Theme.of(context).iconTheme.color),
                  title: Text(searchItem),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Theme.of(context).iconTheme.color),
                    onPressed: () => controller.removeSearch(index),
                  ),
                  onTap: () {
                    controller.searchTextController.text = searchItem;
                    controller.onSearchChanged(searchItem);
                    controller.startSearch();
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSearchResultView() {
    return Obx(() {
      final results = controller.suggestions;
      if (results.isEmpty) {
        return Center(child: Text("enter_keyword_to_show_suggestions".tr));
      }
      return ListView.separated(
        itemCount: results.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final song = results[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                song.image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              // FocusManager.instance.primaryFocus?.unfocus();

              controller.searchTextController.text = song.title;
              controller.saveSearch(song.title);
              controller.startSearch();
              _songs = results; // Cập nhật _songs với kết quả tìm kiếm
              _navigateToMiniPlayer(song, results);
            },
          );
        },
      );
    });
  }
}