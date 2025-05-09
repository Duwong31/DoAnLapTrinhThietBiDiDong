import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/song.dart';

class SearchPageController extends GetxController {
  final searchTextController = TextEditingController();
  final isSearching = false.obs;
  final suggestions = <Song>[].obs;
  final recentSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
  }

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    searchTextController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    isSearching.value = false;
    suggestions.clear();
  }

  void onSearchChanged(String query) async {
    isSearching.value = true;

    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://thantrieu.com/resources/braniumapis/songs.json'),
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> songList = decodedJson['songs'];

        final filtered = songList
            .map((e) => Song.fromJson(e))
            .where((song) =>
        song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase()))
            .toList();

        suggestions.value = filtered;
      } else {
        print('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi kết nối hoặc phân tích: $e');
    }
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

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.assignAll(searches);
  }
}
