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
    // Retrieve screen dimensions for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: BackToStartPage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Dynamic padding based on screen size
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.05,
              horizontal: size.width * 0.075,
            ),
            child: Center(
              // Constrain maximum width for larger screens
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const ForgotPassPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    BasicButton(
                      onPressed: () {
                        // Handle login action
                      },
                      title: 'Log in',
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

  // Header text for the page
  Widget _loginText() {
    return const Text(
      'Log in to SoundFlow',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Unified input decoration for a consistent look across fields
  InputDecoration _inputDecoration({
    required String hintText,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
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

  // Phone number text field with phone icon and proper keyboard type
  Widget _phoneNumberField() {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(
        hintText: 'Enter your phone number',
        icon: Icons.phone,
      ),
    );
  }

  // Password text field with lock icon and obscured text
  Widget _passwordField() {
    return TextField(
      obscureText: true,
      decoration: _inputDecoration(
        hintText: 'Enter your password',
        icon: Icons.lock,
      ),
    );
  }

  // Helper method to display a title for each field
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
