import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utilities/preferences.dart';
import '../../../core/utilities/string.dart';
import '../../../data/repositories/repositories.dart';

/// Global controllers to prevent disposal during navigation
final Map<String, TextEditingController> _globalControllers = {};

class LoginController extends GetxController {
  // Use getters instead of direct controller references
  TextEditingController get emailController =>
      _globalControllers['login_email'] ??= TextEditingController();

  TextEditingController get passwordController =>
      _globalControllers['login_password'] ??= TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final deviceName = "test_device".obs;
  final autoFilledemail = ''.obs;

  final AuthRepository _authRepository = Repo.auth;
  final isReadyForInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("LoginController initialized");

    // Defer controller updates to after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pre-fill email if coming from password reset
      if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
        final email = Get.arguments['email'];
        if (email != null && email is String) {
          final formattedemail =
              email.startsWith('+84') ? '0${email.substring(3)}' : email;

          // Update the controller safely after the build
          emailController.text = formattedemail;
          autoFilledemail.value = formattedemail;
        }
      }

      // Mark controller as ready for input after initialization
      isReadyForInput.value = true;
    });
    
    _checkLoginStatus();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
    return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  String formatEmail(String email) {
    email = email.trim();
    if (RegExp(r'^0[0-9]{9}$').hasMatch(email)) {
      return '+84${email.substring(1)}';
    }
    return email;
  }

  // Check login status (Auto-login if "Remember Me" is enabled)
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    rememberMe.value = prefs.getBool('rememberMe') ?? false;

    if (rememberMe.value && Preferences.isAuth()) {
      Get.offAllNamed('/home');
    }
  }

  Future<void> _saveLoginState(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe.value);

    if (user['id'] != null) {
      Preferences.setString(StringUtils.currentId, user['id'].toString());
    }

    if (user['email'] != null) {
      Preferences.setString(StringUtils.email, user['email']);
    }

    if (rememberMe.value) {
      Preferences.setString(StringUtils.token, token);

      if (user['refresh_token'] != null) {
        Preferences.setString(StringUtils.refreshToken, user['refresh_token']);
      }
    } else {
      final box = GetStorage();
      await box.write('access_token', token);
    }
  }

  Future<void> login() async {
    if (!isReadyForInput.value) return;

    final email = emailController.text;
    final password = passwordController.text;

    final emailValidation = validateEmail(email);
    if (emailValidation != null) {
      Get.snackbar(
        'Lỗi',
        emailValidation,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    final passwordValidation = validatePassword(password);
    if (passwordValidation != null) {
      Get.snackbar(
        'Lỗi',
        passwordValidation,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      isLoading.value = true;
      final formattedemail = formatEmail(email);

      final response = await _authRepository.login(
          formattedemail, password, deviceName.value);

      if (response != null && response['status'] == 1) {
        // Handle successful login
        String? accessToken = response['access_token'];
        Map<String, dynamic>? userData = response['user'];

        if (accessToken != null && userData != null) {
          await _saveLoginState(accessToken, userData);
          await Get.offAllNamed('/home');
        } else {
          Get.snackbar(
            'Lỗi',
            'Thiếu thông tin đăng nhập',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
          );
          isLoading.value = false;
        }
      } else {
        Get.snackbar(
          'Lỗi',
          response?['message'] ?? 'Đăng nhập thất bại',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint('Lỗi đăng nhập: $e');
      Get.snackbar(
        'Lỗi',
        'Đăng nhập thất bại: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      isLoading.value = false;
    }
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void goToRegisterView() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    debugPrint("LoginController being closed");
    super.onClose();
  }

  static void cleanupControllers() {
    _globalControllers.forEach((_, controller) {
      controller.dispose();
    });
    _globalControllers.clear();
  }

  void signInWithGoogle() {

  }
  
}
