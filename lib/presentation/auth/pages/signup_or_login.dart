import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/login.dart';
import 'package:soundflow/presentation/auth/pages/signup.dart';

class StartPage extends StatelessWidget{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(         
            children: [
              const SizedBox(height: 300),
              Image.asset(
                AppVectors.logo,
                width: 80,
                color: AppColors.primary, 
              ),

              const SizedBox(height: 20),

              const Text(
                "Sound your life.",
                style: TextStyle(
                  fontSize: 30,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              //SIGN UP BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BasicButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignupPage()
                      )
                    );
                  }, 
                  title: 'Sign up free',
                ),
              ),
              const SizedBox(height: 16),
              //LOG IN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.deepOrange, 
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()
                      )
                    );
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              ),
              
            ],
          ),          
        ),
      ),
    );
  }
}