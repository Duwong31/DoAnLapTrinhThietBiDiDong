import 'package:get/get.dart';

import '../controllers/search_page_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPageController>(
      () => SearchPageController(),
    );
  }
}
