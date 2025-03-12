import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_btn_to_start.dart';
import 'package:soundflow/common/widgets/button/basic_btn.dart';
import 'package:soundflow/common/widgets/button/google_btn.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // ValueNotifiers để quản lý trạng thái hiển thị mật khẩu
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isConfirmPasswordVisible = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isPasswordVisible.dispose();
    _isConfirmPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để responsive
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: BackToStartPage(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Sử dụng padding dựa theo kích thước màn hình
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.05,
              horizontal: size.width * 0.075,
            ),
            child: Center(
              // Giới hạn chiều rộng tối đa trên màn hình lớn
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo của bạn
                    Image.asset(
                      AppVectors.logo,
                      width: 80,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    _signupText(),
                    const SizedBox(height: 20),
                    myTitle('Username'),
                    _usernameField(),
                    const SizedBox(height: 15),
                    myTitle('Phone Number'),
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
                        // Xử lý logic đăng ký ở đây
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
                    // Nút Google
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

  // Text header cho trang Signup
  Widget _signupText() {
    return const Text(
      'Sign up to SoundFlow',
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
      textAlign: TextAlign.center,
    );
  }

  // Hàm tạo InputDecoration dùng chung
  InputDecoration _inputDecoration({required String hint, IconData? icon, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xff787878)) : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xffffffff),
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

  // Username field
  Widget _usernameField() {
    return TextField(
      decoration: _inputDecoration(
        hint: 'Enter your username',
        icon: Icons.person,
      ),
    );
  }

  // Phone number field
  Widget _phoneNumberField() {
    return TextField(
      keyboardType: TextInputType.phone,
      decoration: _inputDecoration(
        hint: 'Enter your phone number',
        icon: Icons.phone,
      ),
    );
  }

  // Password field với ẩn/hiện mật khẩu
  Widget _passwordField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isVisible, child) {
        return TextField(
          obscureText: !isVisible,
          decoration: _inputDecoration(
            hint: 'Enter your password',
            icon: Icons.lock,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xff787878)),
              onPressed: () {
                _isPasswordVisible.value = !isVisible;
              },
            ),
          ),
        );
      },
    );
  }

  // Confirm Password field với ẩn/hiện mật khẩu
  Widget _cfmPassField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isConfirmPasswordVisible,
      builder: (context, isVisible, child) {
        return TextField(
          obscureText: !isVisible,
          decoration: _inputDecoration(
            hint: 'Confirm your password',
            icon: Icons.lock_outline,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xff787878)),
              onPressed: () {
                _isConfirmPasswordVisible.value = !isVisible;
              },
            ),
          ),
        );
      },
    );
  }

  // Title cho từng trường nhập liệu
  Widget myTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }
}
