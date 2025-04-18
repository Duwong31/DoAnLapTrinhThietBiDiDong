import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../data/repositories/song_repository.dart';
import '../../albums & playlist/controllers/album_page_controller.dart';
import '../../albums & playlist/controllers/playlist_page_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../search/controllers/search_page_controller.dart';
import '../../setting/controllers/setting_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => NotificationsController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => SearchPageController());
    Get.lazyPut(() => ThemeController());
    Get.lazyPut(() => AlbumController());
    Get.lazyPut(() => PlayListController());
    Get.lazyPut<DefaultRepository>(() => DefaultRepository(), fenix: true);
    Get.lazyPut<UserRepository>(() => UserRepository(), fenix: true);
  }
}
