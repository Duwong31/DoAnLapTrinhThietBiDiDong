// C:\work\SoundFlow\lib\app\modules\login\controllers\login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart'; // Không cần GetStorage nữa nếu chỉ dùng cho token session
// import 'package:shared_preferences/shared_preferences.dart'; // Không cần trực tiếp SharedPreferences

import '../../../core/utilities/preferences.dart';
import '../../../core/utilities/string.dart';
import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';

/// Global controllers to prevent disposal during navigation
final Map<String, TextEditingController> _globalControllers = {};

class LoginController extends GetxController {
  // --- Controllers ---
  TextEditingController get emailController =>
      _globalControllers['login_email'] ??= TextEditingController();

  TextEditingController get passwordController =>
      _globalControllers['login_password'] ??= TextEditingController();

  // --- State Variables ---
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  // final rememberMe = false.obs; // <-- XÓA BIẾN NÀY
  final deviceName = "test_device".obs; // Consider getting the actual device name/ID

  // --- Dependencies ---
  final AuthRepository _authRepository = Repo.auth;
  final isReadyForInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("LoginController initialized");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Nếu cần pre-fill email từ arguments (ví dụ sau khi đăng ký)
      // if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      //   final emailArg = Get.arguments['email'];
      //   if (emailArg != null && emailArg is String) {
      //     emailController.text = emailArg;
      //   }
      // }
      isReadyForInput.value = true;
    });

    // _checkLoginStatus(); // Hàm này không còn cần thiết vì root.dart đã xử lý điều hướng ban đầu
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // void toggleRememberMe() { // <-- XÓA HÀM NÀY
  //   rememberMe.value = !rememberMe.value;
  // }

  // --- Validation --- (Giữ nguyên)
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
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

  // --- Formatting --- (Giữ nguyên)
  String formatEmail(String email) {
    return email.trim();
  }

  // --- Check Login Status ---
  // Future<void> _checkLoginStatus() async { // <-- XÓA HOẶC BỎ TRỐNG HÀM NÀY
     // Không cần làm gì ở đây nữa, root.dart đã kiểm tra Preferences.isAuth()
  // }

  // --- Updated State Saving (Loại bỏ Remember Me) ---
  Future<void> _saveLoginState(String token, Map<String, dynamic> user) async {
    // await Preferences.setBool('rememberMe', rememberMe.value); // <-- XÓA

    if (user['id'] != null) {
      Preferences.setString(StringUtils.currentId, user['id'].toString());
    }

    if (user['email'] != null) {
      Preferences.setString(StringUtils.email, user['email']);
    } else {
      debugPrint("Warning: Email missing in user data during saveLoginState");
    }

    // Luôn lưu token và refresh token vào SharedPreferences
    Preferences.setString(StringUtils.token, token);
    debugPrint("Lưu token vào SharedPreferences: ${token.substring(0, 10)}...");

    if (user['refresh_token'] != null) {
      Preferences.setString(StringUtils.refreshToken, user['refresh_token']);
      debugPrint("Lưu refresh token vào SharedPreferences.");
    } else {
      await Preferences.remove(StringUtils.refreshToken); // Xóa token cũ nếu API không trả về cái mới
      debugPrint("API không trả về refresh token, đã xóa refresh token cũ (nếu có) khỏi SharedPreferences.");
    }

    // Không cần logic lưu email để tự động điền nữa
    // if (rememberMe.value) { // <-- XÓA KHỐI IF NÀY
    //   if (user['email'] != null) {
    //     await Preferences.setString('remembered_email', user['email']);
    //   }
    // } else {
    //   await Preferences.remove('remembered_email');
    // }
  }


  // --- Updated Login Logic --- (Giữ nguyên phần còn lại)
  Future<void> login() async {
    if (!isReadyForInput.value) {
       debugPrint("Login attempt before input is ready.");
       return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    final emailValidation = validateEmail(email);
    if (emailValidation != null) {
      Get.snackbar('Lỗi', emailValidation, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[100], colorText: Colors.red[800]);
      return;
    }

    final passwordValidation = validatePassword(password);
    if (passwordValidation != null) {
      Get.snackbar('Lỗi', passwordValidation, snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[100], colorText: Colors.red[800]);
      return;
    }

    isLoading.value = true;

    try {
      final formattedEmail = formatEmail(email);
      final response = await _authRepository.login(formattedEmail, password, deviceName.value);

      if (response != null && response['status'] == 1) {
        String? accessToken = response['access_token'];
        Map<String, dynamic>? userData = response['user'];

        if (accessToken != null && accessToken.isNotEmpty && userData != null) {
          await _saveLoginState(accessToken, userData); // Gọi hàm lưu đã được cập nhật
          Get.offAllNamed(Routes.dashboard);
          return;
        } else {
          Get.snackbar('Lỗi', 'Phản hồi đăng nhập không hợp lệ.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.orange[100], colorText: Colors.orange[800]);
        }
      } else {
        Get.snackbar('Lỗi Đăng Nhập', response?['message'] ?? 'Email hoặc mật khẩu không đúng.', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[100], colorText: Colors.red[800]);
      }
    } catch (e) {
      debugPrint('Lỗi đăng nhập Exception: $e');
      Get.snackbar('Lỗi Hệ Thống', 'Đã xảy ra sự cố. Vui lòng thử lại.\nError: ${e.toString()}', snackPosition: SnackPosition.TOP, backgroundColor: Colors.red[100], colorText: Colors.red[800]);
    } finally {
       isLoading.value = false;
    }
  }


  // --- Navigation Methods --- (Giữ nguyên)
  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void goToRegisterView() {
    Get.toNamed('/register');
  }

  // --- Google Sign-In Placeholder --- (Giữ nguyên)
  void signInWithGoogle() {
    debugPrint("Google Sign-In initiated (Not Implemented)");
    Get.snackbar('Thông báo', 'Chức năng đăng nhập Google đang được phát triển.');
  }

  // --- Cleanup --- (Giữ nguyên)
  @override
  void onClose() {
    debugPrint("LoginController being closed");
    super.onClose();
  }

  static void cleanupControllers() {
    debugPrint("Cleaning up global login controllers...");
    _globalControllers.forEach((key, controller) {
      debugPrint("Disposing controller: $key");
      controller.dispose();
    });
    _globalControllers.clear();
  }
}