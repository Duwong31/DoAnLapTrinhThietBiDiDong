import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/styles/style.dart';
import 'app/core/utilities/encry_data.dart';
import 'app/core/utilities/utilities.dart';
import 'app/data/http_client/http_client.dart';
import 'app/data/providers/notification_provider.dart';
import 'app/modules/ songs/bindings/audio_service.dart';
import 'app/modules/profile/controllers/profile_controller.dart';
import 'app/modules/setting/controllers/setting_controller.dart';
import 'app/widgets/messages.dart'; // ✅ thêm dòng này
import 'root.dart';

Future<void> initServices() async {
  Get.log('starting services ...');
  await Firebase.initializeApp();
  await Preferences.setPreferences();
  await NotificationProvider.initialize();

  EncryptData.init();
  if (Preferences.isAuth()) {
    await Get.putAsync(
      () => ProfileController().getUserDetail(),
      permanent: true,
    );
  }
  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Preferences.setPreferences();

  final flavor = await getFlavorSettings();
  switch (flavor) {
    case 'dev':
      ApiClient.setBaseUrl('https://soundflow.click');
      break;
    default:
      ApiClient.setBaseUrl('https://soundflow.click');
  }

  await GetStorage.init();
  Get.put(ThemeController());

  AudioService();
  runApp(const RootApp());

  EncryptData.init();
  await NotificationProvider.initialize();

  if (Preferences.isAuth()) {
    await Get.putAsync(
      () => ProfileController().getUserDetail(),
      permanent: true,
    );
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Get.log('All services started...');
}

Future<String?> getFlavorSettings() async {
  const methodChannel = MethodChannel('flavor');
  final flavor = await methodChannel.invokeMethod('flavor');
  return flavor;
}
