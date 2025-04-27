import 'package:get/get.dart';

import '../controller/like_controller.dart';

class LikeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikeController>(
          () => LikeController(),
    );
  }
}
