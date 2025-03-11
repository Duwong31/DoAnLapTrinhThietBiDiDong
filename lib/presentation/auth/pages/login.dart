import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_btn_to_start.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/common/widgets/button/google_btn.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/forgot_password.dart';
import 'package:soundflow/presentation/auth/pages/signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve screen dimensions
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: BackToStartPage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Use dynamic padding based on screen size
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.05,
              horizontal: size.width * 0.075,
            ),
            child: Center(
              // Constrain max width on larger screens (e.g., tablets or web)
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppVectors.logo,
                      width: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    _loginText(),
                    const SizedBox(height: 20),
                    myTitle('Phone Number'),
                    const SizedBox(height: 5),
                    _phoneNumberField(),
                    const SizedBox(height: 15),
                    myTitle('Password'),
                    const SizedBox(height: 5),
                    _passwordField(),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const ForgotPassPage()
                              )
                            );
                        },
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.blueAccent,
                          ),
                        ),               
                      ),
                    ),
                    const SizedBox(height: 5),
                    BasicButton(
                      onPressed: () {
                        // Handle login action
                      },
                      title: 'Log in',
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or'),
),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    GoogleButton(onPressed: () {}),
                    const SizedBox(height: 30),
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
                                builder: (BuildContext context) => const SignupPage(),
                              ),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Log in to SoundFlow',
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 32,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _phoneNumberField() {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffE6E6E6),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffE6E6E6),
      ),
    );
  }

  Widget myTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}