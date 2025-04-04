import 'package:get/get.dart';

import '../../../core/utilities/utilities.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    if (Preferences.getString(StringUtils.token) == null) {
      Get.offAllNamed(Routes.welcome);
    } else {
      Get.offAllNamed(Routes.dashboard);
    }
    super.onReady();
  }
}
