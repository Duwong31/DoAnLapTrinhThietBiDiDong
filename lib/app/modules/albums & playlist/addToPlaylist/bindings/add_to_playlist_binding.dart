import 'package:get/get.dart';

import '../controllers/add_to_playlist_controller.dart';

class AddToPlaylistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddToPlaylistController>(
          () => AddToPlaylistController(),
    );
  }
}