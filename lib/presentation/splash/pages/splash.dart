
import 'package:flutter/material.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/signup_or_login.dart';

import '../../../common/widgets/tabbar/tabbar.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();
    redirect();
    // Future.delayed(const Duration(seconds: 3)).then((value) {
    //   Navigator.of(context).pushReplacement(
    //     CupertinoPageRoute(builder: (ctx) => const Stả()));
    // });
    // }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              AppVectors.logo,
              width: 80,
              color: AppColors.primary,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'from DHPT',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> redirect() async{
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;//use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const StartPage()));
  }
  

} 