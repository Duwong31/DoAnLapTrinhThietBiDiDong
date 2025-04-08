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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: textController,
                onSubmitted: (value) {
                  controller.saveSearch(value);
                  textController.clear();
                },
                decoration: const InputDecoration(
                  hintText: "Search for songs, artists...",
                  hintStyle: TextStyle(color: AppTheme.labelColor),
                  prefixIcon: Icon(Icons.search, color: AppTheme.labelColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),

            Dimes.height20,

            const Text(
              "Suggestions for you",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item,
                      style: const TextStyle(
                          fontSize: 14, color: AppTheme.labelColor)),
                ),
              ))
                  .toList(),
            )),

            Dimes.height20,

            // Recent searches
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent searches",
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    leading: const Icon(Icons.history, color: Colors.grey),
                    title: Text(searchItem),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
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
