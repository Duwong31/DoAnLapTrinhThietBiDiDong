import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/instance_manager.dart';

import '../../core/utilities/app_utils.dart';
import '../../modules/profile/controllers/profile_controller.dart';

class FirebaseAnalyticService {
  FirebaseAnalyticService._();
  factory FirebaseAnalyticService() => _instance;
  static final FirebaseAnalyticService _instance = FirebaseAnalyticService._();

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static void logLogin() {
    try {
      analytics.logLogin(loginMethod: 'Phone');
    } catch (e) {
      AppUtils.log(e);
    }
  }

  static void logEvent(String name, {Map<String, dynamic>? params}) {
    try {
      if (Get.isRegistered<ProfileController>()) {
        // final user = Get.find<ProfileController>().user;
        AppUtils.log('FirebaseAnalytics\n'
            'name: $name\n'
            'parameters: $params\n');
      }
    } catch (e) {
      AppUtils.log(e);
    }
  }
}
