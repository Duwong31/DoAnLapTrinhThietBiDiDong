import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';

/// Global controllers (xem xét lại nếu thực sự cần thiết với GetX)
final Map<String, TextEditingController> _globalControllers = {};

class ResetPasswordController extends GetxController {
  late final GlobalKey<FormState> formKey;

  TextEditingController get passwordController =>
      _globalControllers['reset_password'] ??= TextEditingController();
  TextEditingController get confirmPasswordController =>
      _globalControllers['reset_confirm_password'] ??= TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;
  final AuthRepository _authRepository = Repo.auth;
  // final isReadyForInput = false.obs; // Có thể không cần

  // --- Lưu trữ thông tin từ arguments ---
  String? email; // Sẽ có giá trị nếu reset qua email
  String? phone; // Sẽ có giá trị nếu reset qua phone
  late String userId; // Giữ lại nếu cần (ví dụ để hiển thị thông tin user)

  // --- Cờ xác định phương thức reset ---
  bool get isEmailReset => email != null && email!.isNotEmpty;
  bool get isPhoneReset => phone != null && phone!.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    debugPrint("ResetPasswordController initialized");
    _initializeData();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   isReadyForInput.value = true;
    // });
  }

  void _initializeData() {
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        userId = args['userId'] ?? '';
        email = args['email'];
        phone = args['phone'];
        // --- KHÔNG LẤY OTP TỪ ARGUMENTS ---
        // otp = args['otp'] ?? ''; // Xóa dòng này

        debugPrint('ResetPasswordController received - userId: $userId, email: $email, phone: $phone');

        // --- BỎ KIỂM TRA OTP, CHỈ CẦN USERID VÀ EMAIL/PHONE ---
        if (userId.isEmpty || (!isEmailReset && !isPhoneReset)) {
          throw Exception("Incomplete information received for password reset (missing userId or email/phone).");
        }
      } else {
         throw Exception("Arguments are missing for password reset.");
      }
    } catch (e) {
      debugPrint('Error initializing reset password data: $e');
       WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Error',
            'Could not prepare password reset. Please try the process again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red[100],
            colorText: Colors.red[800],
          );
          Get.offAllNamed(Routes.forgotPassword);
       });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
   void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // --- Validation giữ nguyên ---
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // Thêm regex nếu cần
    // final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$');
    // if (!passwordRegex.hasMatch(value)) {
    //   return 'Password requires uppercase & special char.';
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword() async {
    // if (!isReadyForInput.value) return; // Bỏ nếu không dùng

    if (!formKey.currentState!.validate()) {
      return;
    }

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // --- BỎ KIỂM TRA OTP ---
    if (!isEmailReset && !isPhoneReset) {
      _showErrorSnackbar('Error', 'Incomplete information to reset password.');
      return;
    }

    try {
      isLoading.value = true;
      dynamic response;

      if (isEmailReset) {
        debugPrint('Calling resetPasswordEmail API with email: $email');
        response = await _authRepository.resetPasswordEmail(
          email!,
          // --- KHÔNG GỬI OTP ---
          password,
          confirmPassword
        );
      } else if (isPhoneReset) {
        debugPrint('Calling resetPassword (phone) API with phone: $phone');
        response = await _authRepository.resetPassword(
          phone!,
          // --- KHÔNG GỬI OTP ---
          password,
          confirmPassword
        );
      } else {
         throw Exception("Cannot determine reset method (email or phone).");
      }

      debugPrint('Reset Password API response: $response');

      if (response != null && response['status'] == 1) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Password reset successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 2),
        );
        await Future.delayed(const Duration(seconds: 2));
        passwordController.clear();
        confirmPasswordController.clear();
        Get.offAllNamed(Routes.login, arguments: {
           if (isEmailReset) 'email': email,
           if (isPhoneReset) 'phone': phone,
        });
      } else {
        _showErrorSnackbar('Error', response?['message'] ?? 'Could not reset password.');
      }
    } catch (e) {
      debugPrint('Error resetting password: $e');
      _showErrorSnackbar('Error', 'Could not reset password: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
     Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
   }

  @override
  void onClose() {
    debugPrint("ResetPasswordController being closed");
    // cleanupControllers(); // Xem xét lại việc gọi cleanup ở đây
    super.onClose();
  }

  // --- Cleanup Controllers (Xem xét lại sự cần thiết) ---
  static void cleanupControllers() {
    if (_globalControllers.containsKey('reset_password')) {
      _globalControllers['reset_password']?.dispose();
      _globalControllers.remove('reset_password');
      debugPrint("Disposed reset_password controller");
    }
    if (_globalControllers.containsKey('reset_confirm_password')) {
      _globalControllers['reset_confirm_password']?.dispose();
      _globalControllers.remove('reset_confirm_password');
      debugPrint("Disposed reset_confirm_password controller");
    }
  }
}