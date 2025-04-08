import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../controllers/search_page_controller.dart';

class SearchView extends GetView<SearchPageController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).inputDecorationTheme.fillColor ??
                    Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: textController,
                onSubmitted: (value) {
                  controller.saveSearch(value);
                  textController.clear();
                },
                style: Theme.of(context).textTheme.bodyMedium, // 👈 màu chữ theo theme
                decoration: InputDecoration(
                  hintText: "Search for songs, artists...",
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).iconTheme.color),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),

            Dimes.height20,

            Text(
              "Suggestions for you",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            Dimes.height10,

            Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.suggestions
                  .map((item) => GestureDetector(
                onTap: () {
                  textController.text = item;
                  controller.saveSearch(item);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .inputDecorationTheme
                        .fillColor ??
                        Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color)),
                ),
              ))
                  .toList(),
            )),

            Dimes.height20,

            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent searches",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (controller.recentSearches.isNotEmpty)
                  TextButton(
                    onPressed: controller.clearRecentSearches,
                    child: const Text("Clear all",
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            )),

            Dimes.height10,

            Obx(() => Expanded(
              child: ListView.builder(
                itemCount: controller.recentSearches.length,
                itemBuilder: (context, index) {
                  final searchItem = controller.recentSearches[index];
                  return ListTile(
                    leading: Icon(Icons.history,
                        color: Theme.of(context).iconTheme.color),
                    title: Text(searchItem,
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: IconButton(
                      icon: Icon(Icons.close,
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () => controller.removeSearch(index),
                    ),
                  );
                },
              ),
            )),
          ],
        ),
      ),
    );
  }
}
