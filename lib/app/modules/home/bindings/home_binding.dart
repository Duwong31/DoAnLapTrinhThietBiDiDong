import 'package:get/get.dart';

import '../../ songs/bindings/audio_service.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(),);
    Get.put(AudioService(), permanent: true);
  }
}
