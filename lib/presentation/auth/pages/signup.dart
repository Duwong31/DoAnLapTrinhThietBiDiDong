import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_btn_to_start.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/common/widgets/button/google_btn.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/login.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: BackToStartPage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Use relative padding based on screen size
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.05,
              horizontal: size.width * 0.075,
            ),
            child: Center(
              // Constrain max width for larger screens
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
                    _signupText(),
                    const SizedBox(height: 20),
                    myTitle('Username'),
                    const SizedBox(height: 5),
                    _usernameField(),
                    const SizedBox(height: 15),
                    myTitle('Phone Number'),
                    const SizedBox(height: 5),
                    _phoneNumberField(),
                    const SizedBox(height: 15),
                    myTitle('Password'),
                    const SizedBox(height: 5),
                    _passwordField(),
                    const SizedBox(height: 15),
                    myTitle('Confirm Password'),
                    const SizedBox(height: 5),
                    _cfmPassField(),
                    const SizedBox(height: 40),
                    BasicButton(
                      onPressed: () {
                        // Sign up action
                      },
                      title: 'Sign up',
                    ),
                    const SizedBox(height: 15),
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
                    const SizedBox(height: 15),
                    GoogleButton(onPressed: () {}),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
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
                                builder: (BuildContext context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
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

  Widget _signupText() {
    return const Text(
      'Sign up to SoundFlow',
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  // Helper function to build unified input decorations
  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(icon, color: AppColors.primary)
          : null,
      filled: true,
      fillColor: const Color(0xffE6E6E6),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(30),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  Widget _usernameField() {
    return TextField(
      decoration: _inputDecoration(
        hint: 'Enter your username',
        icon: Icons.person,
      ),
    );
  }

  Widget _phoneNumberField() {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(
        hint: 'Enter your phone number',
        icon: Icons.phone,
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      obscureText: true,
      decoration: _inputDecoration(
        hint: 'Enter your password',
        icon: Icons.lock,
      ),
    );
  }

  Widget _cfmPassField() {
    return TextField(
      obscureText: true,
      decoration: _inputDecoration(
        hint: 'Confirm your password',
        icon: Icons.lock_outline,
      ),
    );
  }

  Widget myTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
  