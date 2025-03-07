import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/appbar/app_bar.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/common/widgets/button/google_btn.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/signup.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 30
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
                AppVectors.logo,
                width: 80,
                color: AppColors.primary, 
              ),
            SizedBox(height: 20),
            _loginText(),

            SizedBox(height: 20),
            myTitle('Phone Number'),
            SizedBox(height: 5),
            _phoneNumberField(),

            SizedBox(height: 15),
            myTitle('Password'),
            SizedBox(height: 5),
            _passwordField(),

            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            SizedBox(height: 20),

            BasicButton(
              onPressed: (){
                
              }, 
              title: 'Log in'),
            SizedBox(height: 5),
            Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('or'),
                      ),
                      Expanded(child: Divider(color: Colors.grey)),
                    ],
            ),
            SizedBox(height: 5),
            GoogleButton(onPressed: (){}),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignupPage()
                      )
                    );
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, 
                    ),
                  ),
                ),
              ],
            )

        ],
        ),
      ),
    );
  }
  Widget _loginText(){
    return const Text(
      'Log in to SoundFlow',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 32
      ),
      textAlign: TextAlign.center,
    );
  }
  
  Widget _phoneNumberField(){
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffE6E6E6),
      ),
    );
  }Widget _passwordField(){
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffE6E6E6),
      ),
    );
  }
  Widget myTitle(title){
    return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16
                ),
              ),
            );
  }
}