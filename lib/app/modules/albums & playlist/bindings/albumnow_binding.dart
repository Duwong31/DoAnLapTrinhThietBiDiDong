import 'package:get/get.dart';
import '../controllers/albumnow_controller.dart';

class AlbumNowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumNowController>(
            () => AlbumNowController());
  }
}
