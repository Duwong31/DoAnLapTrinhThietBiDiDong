import 'package:get/get.dart';
import '../../../../models/song.dart';
import '../../../data/sources/source_songs.dart';

class HomeController extends GetxController {
  final RemoteDataSource _dataSource = RemoteDataSource();
  final RxList<Song> songs = <Song>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (songs.isEmpty) {
      loadSongs();
    }
  }

  Future<void> loadSongs() async {
    try {
      final result = await _dataSource.loadData(page: 1, perPage: 6);
      if (result != null) {
        songs.assignAll(result);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load songs');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}