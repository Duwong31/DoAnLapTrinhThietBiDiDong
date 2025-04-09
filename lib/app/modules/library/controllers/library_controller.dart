import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryItem {
  final String? id;
  final String? title;
  final String? description;
  final String? imageUrl;
  final DateTime? createdAt;

  LibraryItem({
    this.id,
    this.title,
    this.description,
    this.imageUrl,
    this.createdAt,
  });

  factory LibraryItem.fromJson(Map<String, dynamic> json) {
    return LibraryItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class ListController extends GetxController {
  final RxList<String> hardWords = <String>[].obs;
  final RxString searchQuery = ''.obs;

  static const String _key = 'hard_words';

  @override
  void onInit() {
    super.onInit();
    loadWords();
  }

  Future<void> loadWords() async {
    final prefs = await SharedPreferences.getInstance();
    final words = prefs.getStringList(_key) ?? [];
    hardWords.assignAll(words);
  }

  Future<void> addWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    if (!hardWords.contains(word)) {
      hardWords.add(word);
      await prefs.setStringList(_key, hardWords);
    }
  }

  Future<void> removeWord(String word) async {
    final prefs = await SharedPreferences.getInstance();
    hardWords.remove(word);
    await prefs.setStringList(_key, hardWords);
  }

  Future<void> clearWords() async {
    final prefs = await SharedPreferences.getInstance();
    hardWords.clear();
    await prefs.remove(_key);
  }

  void setSearchQuery(String value) {
    searchQuery.value = value;
  }

  List<String> get filteredWords {
    return hardWords
        .where((word) =>
        word.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
