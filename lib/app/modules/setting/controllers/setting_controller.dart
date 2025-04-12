import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/styles/style.dart';

class SettingController extends GetxController {
  // Không cần xử lý dữ liệu phức tạp khi chỉ hiển thị văn bản tĩnh
}

// Themes setting
class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;

  void toggleTheme() {
    themeMode.value = themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}

// Language setting
class LanguageController extends GetxController {
  final _locale = const Locale('en', 'US').obs; // Mặc định là tiếng Anh
  final box = GetStorage();

  Locale get selectedLocale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    final savedLangCode = box.read('locale');
    if (savedLangCode == 'vi_VN') {
      _locale.value = const Locale('vi', 'VN');
      Get.updateLocale(_locale.value);
    }
  }

  void changeLanguage(Locale locale) {
    _locale.value = locale;
    Get.updateLocale(locale);
    box.write('locale', '${locale.languageCode}_${locale.countryCode}');
  }
}