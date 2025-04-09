import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/list_controller.dart';

class ListPageView extends GetView<ListController> {
  const ListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ Khó'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => controller.clearWords(),
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: textController,
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: "Tìm kiếm từ khó...",
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final word = textController.text.trim();
                      if (word.isNotEmpty) {
                        controller.addWord(word);
                        textController.clear();
                      }
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // hiển thị danh sách từ khó
            Expanded(
              child: Obx(() {
                final words = controller.filteredWords;
                if (words.isEmpty) {
                  return const Center(child: Text('Không có từ khó nào.'));
                }
                return ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    return ListTile(
                      title: Text(word),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => controller.removeWord(word),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}