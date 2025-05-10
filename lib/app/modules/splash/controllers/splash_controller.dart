import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';

import '../../../core/utilities/utilities.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() async {
    // Check if token exists and is valid
    final token = Preferences.getString(StringUtils.token);
    if (token == null || token.isEmpty) {
      // No token, go to welcome screen
      Get.offAllNamed(Routes.welcome);
      return;
    }

    try {
      // Create a new Dio instance for token validation
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      
      // Make a test API call to validate token
      final response = await dio.get(
        'https://soundflow.click/api/auth/me',
        options: Options(validateStatus: (status) => status != null && status < 500)
      );

      if (response.statusCode == 200) {
        // Token is valid, go to dashboard
        Get.offAllNamed(Routes.dashboard);
      } else {
        // Token is invalid, clear data and go to welcome screen
        await Preferences.clear();
        await GetStorage().erase();
        Get.offAllNamed(Routes.welcome);
      }
    } catch (e) {
      // Any error means token is invalid
      await Preferences.clear();
      await GetStorage().erase();
      Get.offAllNamed(Routes.welcome);
    }
    super.onReady();
  }
}
