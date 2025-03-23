import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/otp.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi trong TextField
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Kiểm tra xem đã nhập đủ 10 số chưa
  bool get _isPhoneNumberValid => _phoneController.text.length == 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicBackButton(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  //chỉ cho phép chuyển trang khi đủ 10 số,
                  if (_isPhoneNumberValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const OTPPage(),
                      ),
                    );
                  } else {
                    
                  }
                },
                style: ElevatedButton.styleFrom(
                  // Đổi màu nút thành cam nếu đủ 10 số, ngược lại màu đen
                  backgroundColor: _isPhoneNumberValid
                      ? AppColors.primary
                      : Colors.black,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
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
      controller: _phoneController, // Gắn controller để theo dõi
      keyboardType: TextInputType.number,
      inputFormatters: [
    // Chỉ cho phép nhập ký tự số
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: 'Enter your phone number',
        prefixIcon: const Icon(Icons.phone, color: Color(0xff787878)),
        filled: true,
        fillColor: AppColors.lightBackground,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepOrange),
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
        fontSize: 26,
      ),
      textAlign: TextAlign.center,
    );
  }
}
