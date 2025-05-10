import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../models/artist.dart';

class ArtistController extends GetxController {
  final artistList = <ArtistModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final List<String> artistIds = [
    '3KJopZ2uUclqEtLxQg0FNn',
    '5dfZ5uSmzR7VQK0udbAVpf',
    '0aNyWetkjBvIdZvJY00yEa',
    '0slOzRzTQb1RBBVJbvRITP',
    '5HZtdKfC4xU0wvhEyYDWiY',
    '4KPyQxL1zqEiBcTwW6c9HE',
    '14W31zJumZnGDgZuPXclTJ',
    '0jF7Zlz8P5p74zcH7YwcMU',
    '5FWPIKz9czXWaiNtw45KQs',
    '4R3mugkUqCALXgkwSptTbg',
    '2mx5AAdmlMxMcrcd7AQh1j',
    '6JTiPLdbZD2e0tDsN15U1s',
    '3Cl5NZZOw8sXweFM13Y61d',
  ];

  @override
  void onInit() {
    fetchArtists();
    super.onInit();
  }

  Future<void> fetchArtists() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      artistList.clear();

      for (var i = 0; i < artistIds.length; i += 5) {
        final chunk = artistIds.sublist(
          i,
          i + 5 > artistIds.length ? artistIds.length : i + 5,
        );
        await _fetchArtistChunk(chunk);
      }

    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
  
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchArtistChunk(List<String> ids) async {
    final url = Uri.parse(
      'https://spotify23.p.rapidapi.com/artists/?ids=${ids.join(',')}',
    );

    final headers = {
      'X-RapidAPI-Key': '94b88f124fmshce6a37630b75745p1b6b7djsn0b7dbb28dd4d',
      'X-RapidAPI-Host': 'spotify23.p.rapidapi.com',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['artists'] is List) {
        final artistsJson = data['artists'] as List;

        final newArtists = artistsJson
            .map<ArtistModel>((json) => ArtistModel.fromJson(json))
            .toList();

        artistList.addAll(newArtists);

        for (var artist in newArtists) {
          
        }
      } else {
        
      }
    } else {
      
    }
  }
}