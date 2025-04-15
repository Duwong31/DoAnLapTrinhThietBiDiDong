import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_page_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                          controller.isSearching.value
                              ? Icons.arrow_back
                              : Icons.search,
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
                            hintText: "Search for songs, artists...",
                            hintStyle: TextStyle(
                                color: Theme.of(context).hintColor),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => Expanded(
                child: controller.isSearching.value
                    ? _buildSearchResultView()
                    : _buildDefaultView(),
              )),
            ],
          ),
        ),
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
              "Recent searches",
              style: Theme.of(Get.context!)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (controller.recentSearches.isNotEmpty)
              TextButton(
                onPressed: controller.clearRecentSearches,
                child: const Text("Clear all", style: TextStyle(color: Colors.red)),
              ),
          ],
        )),
        const SizedBox(height: 10),
        Obx(() {
          if (controller.recentSearches.isEmpty) {
            return const Text("No recent searches");
          }
          return Expanded(
            child: ListView.builder(
              itemCount: controller.recentSearches.length,
              itemBuilder: (context, index) {
                final searchItem = controller.recentSearches[index];
                return ListTile(
                  leading: Icon(Icons.history,
                      color: Theme.of(context).iconTheme.color),
                  title: Text(searchItem),
                  trailing: IconButton(
                    icon: Icon(Icons.close,
                        color: Theme.of(context).iconTheme.color),
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
        return const Center(
          child: Text("🔍 Nhập từ khóa để hiển thị gợi ý"),
        );
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
                errorBuilder: (context, error, stackTrace) => Icon(Icons.music_note),
              ),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            onTap: () {
              controller.searchTextController.text = song.title;
              controller.saveSearch(song.title);
              controller.startSearch();
              // TODO: navigate to detail or play screen
            },
          );
        },
      );
    });
  }
}
