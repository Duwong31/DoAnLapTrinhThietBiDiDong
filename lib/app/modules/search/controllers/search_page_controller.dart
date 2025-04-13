import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchItem {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? createdAt;

  SearchItem({
    this.id,
    this.title,
    this.description,
    this.createdAt,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class SearchPageController extends GetxController {
  final RxList<String> suggestions = <String>[].obs;
  final RxList<String> recentSearches = <String>[].obs;

  final searchTextController = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    _fetchSuggestions();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.assignAll(searches);
  }

  Future<void> _fetchSuggestions() async {
    await Future.delayed(Duration(seconds: 1));
    suggestions.assignAll(["Pop", "Rock", "Hip-hop", "Jazz", "EDM"]);
  }

  Future<void> saveSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      await prefs.setStringList('recentSearches', recentSearches);
    }
  }

  Future<void> removeSearch(int index) async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.removeAt(index);
    await prefs.setStringList('recentSearches', recentSearches);
  }

  Future<void> clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.clear();
    await prefs.remove('recentSearches');
  }
}