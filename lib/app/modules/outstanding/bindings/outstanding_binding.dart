import 'package:get/get.dart';

import '../controllers/outstanding_controller.dart';

class OutstandingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OutstandingController>(
      () => OutstandingController(),
    );
  }
}
