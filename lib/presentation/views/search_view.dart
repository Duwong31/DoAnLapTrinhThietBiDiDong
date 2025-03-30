import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/appbar/appbar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  List<String> suggestions = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _fetchSuggestions();
  }

  // 🔹 Lấy danh sách tìm kiếm gần đây từ SharedPreferences
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  // 🔹 Gọi API để lấy danh sách gợi ý tìm kiếm
  Future<void> _fetchSuggestions() async {
    // Giả lập API call
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      suggestions = ["Pop", "Rock", "Hip-hop", "Jazz", "EDM"]; // Dữ liệu giả lập từ API
    });
  }

  // 🔹 Lưu tìm kiếm vào SharedPreferences
  Future<void> _saveSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();

    if (!recentSearches.contains(query)) {
      setState(() {
        recentSearches.insert(0, query);
      });
      await prefs.setStringList('recentSearches', recentSearches);
    }
  }

  // 🔹 Xóa một mục khỏi lịch sử tìm kiếm
  Future<void> _removeSearch(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches.removeAt(index);
    });
    await prefs.setStringList('recentSearches', recentSearches);
  }

  // 🔹 Xóa toàn bộ lịch sử tìm kiếm
  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches.clear();
    });
    await prefs.remove('recentSearches');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Search"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  _saveSearch(value);
                  _searchController.clear();
                },
                decoration: const InputDecoration(
                  hintText: "Search for songs, artists...",
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.search, color: Colors.black54),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Suggestions for you
            const Text(
              "Suggestions for you",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: suggestions.map((item) => _buildSuggestionChip(item)).toList(),
            ),

            const SizedBox(height: 20),

            // 🔹 Recent searches
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent searches",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (recentSearches.isNotEmpty)
                  TextButton(
                    onPressed: _clearRecentSearches,
                    child: const Text("Clear all", style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final searchItem = recentSearches[index];
                  return ListTile(
                    leading: const Icon(Icons.history, color: Colors.grey),
                    title: Text(searchItem),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => _removeSearch(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tạo Chip cho Suggestion
  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        _saveSearch(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black)),
      ),
    );
  }
}
