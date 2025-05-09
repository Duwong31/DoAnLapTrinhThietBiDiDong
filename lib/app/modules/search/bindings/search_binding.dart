import 'package:get/get.dart';
import '../controllers/search_page_controller.dart';
import '../../favorite/controller/favorite_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchPageController>(
          () => SearchPageController(),
    );
    // Thêm dòng này để đảm bảo FavoriteController có sẵn
    Get.lazyPut<FavoriteController>(
          () => FavoriteController(),
      fenix: true, // Giữ controller sống khi không dùng đến
    );
  }
}