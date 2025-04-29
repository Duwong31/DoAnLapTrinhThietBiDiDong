import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/styles/style.dart';

class SettingController extends GetxController {
  // Không cần xử lý dữ liệu phức tạp khi chỉ hiển thị văn bản tĩnh
}

// Themes setting
class ThemeController extends GetxController {
  var themeMode = ThemeMode.light.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleTheme() {
    themeMode.value =
    themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeToStorage();
  }

  void _loadThemeFromStorage() {
    final isDark = _box.read('isDarkMode') ?? false; // mặc định sáng
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void _saveThemeToStorage() {
    _box.write('isDarkMode', themeMode.value == ThemeMode.dark);
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