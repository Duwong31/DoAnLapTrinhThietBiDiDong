import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../models/artist.dart';

class ArtistController extends GetxController {
  final artistList = <ArtistModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = ''.obs;

  final List<String> artistIds = [
    '2w9zwq3AktTeYYMuhMjju8',
    '2JVLB6xMAa3vXDD89dktLZ',
    '0du5cEVh5yTK9QJze8zA0C',
    '3Z73qbDrey1ubsAofhOoz6',
    '3zE5jV6Uw9hhdWCXM8hS3j',
    '5t1D0pmHVT0FmuCMAPsGqo',
    '7tYKF4w9nC0nq9CsPZTHyP',
    '4w6T2GcMFd9ZEsOuZ5RDxg',
    '06HL4z0CvFAxyc27GXpf02',
    '4ypou4nriO8G6UiKe570cz',
    '1Xyo4u8uXC1ZmMpatF05PJ',
    '699OTQXzgjhIYAHMy9RyPD',
    '5K4W6rqBFWDnAN6FQUkS6x',
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

        print('📦 Fetching chunk: $chunk');
        await _fetchArtistChunk(chunk);
      }

      print('✅ Total artists fetched: ${artistList.length}');
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('❌ Error fetching artists: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchArtistChunk(List<String> ids) async {
    final url = Uri.parse(
      'https://spotify23.p.rapidapi.com/artists/?ids=${ids.join(',')}',
    );

    final headers = {
      'X-RapidAPI-Key': 'd6e121976bmsh15032ff06cf1319p1b5915jsn87fe28db57d7',
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
          print('🎤 Fetched: ${artist.name}');
        }
      } else {
        print('⚠️ Unexpected response format for chunk: $ids');
      }
    } else {
      print('❌ API error: ${response.statusCode} - IDs: $ids');
    }
  }
}