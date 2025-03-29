import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soundflow/core/configs/theme/app_theme.dart';
import 'package:soundflow/presentation/splash/pages/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo các widget được khởi tạo
  await Firebase.initializeApp(); // Khởi tạo Firebase
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
