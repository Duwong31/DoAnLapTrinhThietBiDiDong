import 'package:get/get.dart';

import '../../../data/services/song_service.dart';
import '../../favorite/controller/favorite_controller.dart';
import '../controllers/library_controller.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteController());
    Get.lazyPut<LibraryController>(
      () => LibraryController(),
    );
  }
}
