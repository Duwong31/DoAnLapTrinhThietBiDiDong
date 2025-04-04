import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/core/styles/style.dart';
import 'app/core/utilities/preferences.dart';
import 'app/data/services/firebase_analytics_service.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/zoom_transition.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return GestureDetector(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.getCollectionTheme().copyWith(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
        title: 'SoundFlow',
        initialRoute: Preferences.isAuth() ? Routes.dashboard : Routes.splash,
        getPages: AppPages.routes,
        customTransition: ZoomTransitions(),
        navigatorObservers: [FirebaseAnalyticService.observer],
        routingCallback: (_) {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
      ),
      onTap: () {
        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
  }
}
