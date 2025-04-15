import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpLoginController>(
      () => OtpLoginController(),
    );
  }
}
