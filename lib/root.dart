import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/styles/style.dart';
import 'app/core/utilities/preferences.dart';
import 'app/data/services/firebase_analytics_service.dart';
import 'app/modules/setting/controllers/setting_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/zoom_transition.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>(); // 👈 Gọi lại controller

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getCollectionTheme().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        darkTheme: ThemeData.dark(), // 👉 hoặc tuỳ chỉnh darkTheme riêng
        themeMode: themeController.themeMode.value, // 🔥 Cho phép đổi theme
        title: 'SoundFlow',
        initialRoute: Preferences.isAuth() ? Routes.dashboard : Routes.splash,
        getPages: AppPages.routes,
        customTransition: ZoomTransitions(),
        navigatorObservers: [FirebaseAnalyticService.observer],
        routingCallback: (_) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
      )),
    );
  }
}
