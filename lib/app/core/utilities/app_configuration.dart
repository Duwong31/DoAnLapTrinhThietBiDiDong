// import 'package:flutter/material.dart';

// class AppConfig extends InheritedWidget {
//   AppConfig({
//     Key? key,
//     required this.appName,
//     required this.flavorName,
//     required this.apiUrl,
//     required Widget child,
//   }) : super(key: key, child: Material(child: child)) {
//     _globalKey = key as GlobalKey;
//   }

//   final String appName;
//   final AppFlavor flavorName;
//   final String apiUrl;

//   static final navigatorKey = GlobalKey<NavigatorState>();
//   static late GlobalKey _globalKey;
//   static GlobalKey get globalKey => _globalKey;

//   static AppConfig get instance => _globalKey.currentContext!
//       .dependOnInheritedWidgetOfExactType(aspect: AppConfig)!;

//   bool get isDevelopment => flavorName == AppFlavor.development;

//   @override
//   bool updateShouldNotify(InheritedWidget oldWidget) => false;
// }

// enum AppFlavor { development, staging, production }
