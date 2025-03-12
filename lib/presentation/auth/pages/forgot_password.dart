import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/otp.dart';

class ForgotPassPage extends StatelessWidget {
  const ForgotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicBackButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _loginText(),
              const SizedBox(height: 40),
              const Text(
                'What’s your phone number?',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _phoneNumberField(),
              const SizedBox(height: 30),
              BasicButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const OTPPage(),
                    ),
                  );
                },
                title: 'Next',
              ),
              const SizedBox(height: 20),
              const Text(
                'We\'ll send you a code to confirm your phone number',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneNumberField() {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
        prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'Let’s change your password',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 32,
      ),
      textAlign: TextAlign.center,
    );
  }
}
