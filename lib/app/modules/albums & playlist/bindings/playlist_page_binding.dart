import 'package:get/get.dart';

import '../controllers/playlist_page_controller.dart';


class PlayListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayListController>(
          () => PlayListController(),
          fenix: true,
    );
  }
}