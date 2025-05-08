import 'package:get/get.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/http_client/http_client.dart';
import '../../../data/services/song_service.dart';
import '../controller/favorite_controller.dart';

// Trong file favorite_bindings.dart hoặc binding tương ứng
class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiClient()); // Đảm bảo ApiClient được đăng ký
    Get.lazyPut(() => SongService(Get.find<ApiClient>()));
    Get.lazyPut(() => UserRepository(Get.find<ApiClient>()));
    Get.lazyPut(() => FavoriteController());
  }
}
