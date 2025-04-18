import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../models/album.dart';

class AlbumController extends GetxController {
  var playlists = <AlbumModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAlbums();
  }

  void fetchAlbums() async {
    try {
      isLoading(true);

      final albumIds = [
        '62Xr5p6185023RWu1KzhcP',
        '3IBcauSj5M2A6lTeffJzdv',
        '2XGEyGU76kj55OdHWynX0S',
        '3OxfaVgvTxUTy7276t7SPU',
        '1OARrXe5sB0gyy3MhQ8h92',
        '7tzVd1fwkxsorytCBjEJkU',
        '3p4vOm7XU41jAEMtDZHiJT',
        '0P3oVJBFOv3TDXlYRhGL7s',
        '3iv1Dt4wzwNecgtK5rc0n1',
        '7zCODUHkfuRxsUjtuzNqbd',
        '2nLOHgzXzwFEpl62zAgCEC',
      ];

      final idsString = albumIds.join(',');

      final res = await http.get(
        Uri.parse('https://spotify23.p.rapidapi.com/albums/?ids=$idsString'),
        headers: {
          'X-RapidAPI-Key': 'd6e121976bmsh15032ff06cf1319p1b5915jsn87fe28db57d7',
          'X-RapidAPI-Host': 'spotify23.p.rapidapi.com',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body)['albums'] as List;
        playlists.value =
            data.map((e) => AlbumModel.fromSpotifyJson(e)).toList();
      } else {
        print("Failed to fetch albums: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching albums: $e");
    } finally {
      isLoading(false);
    }
  }
}