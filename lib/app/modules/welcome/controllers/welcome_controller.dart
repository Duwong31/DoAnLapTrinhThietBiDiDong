import 'dart:async';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../routes/app_pages.dart';

class WelcomeController extends GetxController {
  final RxInt indexPage = 0.obs;
  Timer? _timer;
  PageController pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (indexPage.value < 2) {
        indexPage.value++;
      } else {
        indexPage.value = 0;
      }
      pageController.animateToPage(
        indexPage.value,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    super.onInit();
  }

  void toLoginPage() {
    Get.offNamed(Routes.login);
  }
  void toSignUpPage() {
    Get.offNamed(Routes.register);
  }

  @override
  void onClose() => _timer?.cancel();
}

