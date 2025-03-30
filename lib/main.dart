import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soundflow/core/configs/theme/app_theme.dart';
import 'package:soundflow/presentation/splash/pages/splash.dart';
import 'package:soundflow/service_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  // HydratedBloc.storage = await HydratedStorage.build(
  //   storageDirectory: kIsWeb 
  //   ? HydratedStorage.webStorageDirectory 
  //   : await getApplicationDocumentsDirectory(),
  // );
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  ); 
  await initializeDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage()
    );
  }
}
