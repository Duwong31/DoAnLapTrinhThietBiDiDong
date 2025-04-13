import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart'; // Đảm bảo đường dẫn đúng

class OtpLoginController extends GetxController {
  // ---->> THAY ĐỔI: Sử dụng một controller duy nhất <<----
  final TextEditingController pinController = TextEditingController();
  // final List<TextEditingController> otpControllers =
  //     List.generate(6, (index) => TextEditingController()); // Dòng cũ

  final secondsRemaining = 60.obs;
  Timer? timer;
  final isLoading = false.obs;

  final AuthRepository _authRepository = Repo.auth;

  String? email;
  String? phoneNumber;
  late String userId;
  final isResetPassword = false.obs;
  final isTestMode = false.obs;
  static const String deviceName = "test_device";

  String get contactInfo {
    // ... (giữ nguyên)
     if (email != null && email!.isNotEmpty) {
      return email!;
    } else if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      return phoneNumber!;
    } else {
      return "your contact";
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    // ... (giữ nguyên logic nhận arguments)
    try {
      final args = Get.arguments as Map<String, dynamic>?;
      if (args != null) {
        email = args['email'];
        phoneNumber = args['phone'];
        userId = args['userId'] ?? '';
        isResetPassword.value = args['isResetPassword'] ?? false;
        isTestMode.value = args['isTestMode'] ?? false;

        if (userId.isEmpty) {
          throw Exception("User ID is missing in arguments.");
        }

        if (!isTestMode.value || (phoneNumber != null && phoneNumber!.isNotEmpty)) {
           startTimer();
        } else {
          secondsRemaining.value = 0;
        }

      } else {
         throw Exception("Arguments are missing.");
      }
    } catch (e) {
      debugPrint('Error initializing OTP data: $e');
      Get.snackbar('Error', 'Could not load verification data. Please try again.',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    // ---->> THAY ĐỔI: Dispose controller duy nhất <<----
    pinController.dispose();
    // for (var controller in otpControllers) { // Dòng cũ
    //   controller.dispose();
    // }
    super.onClose();
  }

  void startTimer() {
    // ... (giữ nguyên)
    timer?.cancel();
    secondsRemaining.value = 60;
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer?.cancel();
      }
    });
  }

  Future<void> verifyOTP() async {
    if (isLoading.value) return;

    // ---->> THAY ĐỔI: Lấy OTP từ controller duy nhất <<----
    String otp = pinController.text;
    // String otp = otpControllers.map((controller) => controller.text).join(); // Dòng cũ

    // Kiểm tra độ dài
    if (otp.length != 6) {
      _showErrorSnackbar('Error', 'Please enter the complete 6-digit code.');
      return;
    }

    // --- Xử lý chế độ Test Mode cho Email ---
    if (isTestMode.value && email != null && email!.isNotEmpty) {
      if (otp == '123456') {
        // ... (giữ nguyên logic điều hướng cho test mode)
        debugPrint("Test Mode (Email): OTP '123456' accepted. Navigating to reset password.");
        timer?.cancel();
        final Map<String, dynamic> resetArgs = {
          'email': email,
          'userId': userId,
          'otp': otp,
        };
        await Get.toNamed(Routes.resetPassword, arguments: resetArgs);
      } else {
         _showErrorSnackbar('Verification Error', 'Invalid OTP entered (Test Mode).');
      }
      return;
    }
    // --- Kết thúc xử lý Test Mode ---

    // --- Xử lý gửi OTP qua Phone (hoặc Email không phải test mode) ---
    if (userId.isEmpty) {
      // ... (giữ nguyên)
      _showErrorSnackbar('Error', 'User information not found.');
      return;
    }

    try {
      // ... (giữ nguyên logic gọi API và xử lý response)
      isLoading.value = true;
      debugPrint('Sending OTP verification with userId: $userId, otp: $otp');
      final response = await _authRepository.verifyOtp(userId, otp, deviceName);
      debugPrint('OTP verification response: $response');

       if (response != null && response['status'] == 1) {
        timer?.cancel();

        if (isResetPassword.value) {
           debugPrint("OTP Verified for Reset Password. Navigating to reset password screen.");
           final Map<String, dynamic> resetArgs = {
             if (phoneNumber != null && phoneNumber!.isNotEmpty) 'phone': phoneNumber,
             if (email != null && email!.isNotEmpty) 'email': email,
             'userId': userId,
            //  'otp': otp,
           };
           await Get.toNamed(Routes.resetPassword, arguments: resetArgs);

        } else {
           debugPrint("OTP Verified for Registration/Verification. Navigating to success/home.");
           if (response['access_token'] != null) {
              // Lưu token...
           }
           await Get.offAllNamed(Routes.home);
        }

      } else {
         _showErrorSnackbar(
          'Verification Error',
          response?['message'] ?? 'Incorrect OTP or it has expired.',
        );
      }
    } catch (e) {
       debugPrint('OTP verification error: $e');
      _showErrorSnackbar('Verification Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOTP() async {
    // ... (giữ nguyên logic resendOTP)
    if (isLoading.value || secondsRemaining.value > 0) return;

    if (isTestMode.value && email != null && email!.isNotEmpty) {
        debugPrint("Test Mode (Email): Resend OTP skipped.");
        Get.snackbar('Info', 'Resend is disabled in test mode.', snackPosition: SnackPosition.TOP);
        return;
    }

    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
       try {
        isLoading.value = true;
        debugPrint('Requesting resend OTP for phone: $phoneNumber');
        final response = await _authRepository.resendOtp(phoneNumber!);
        debugPrint('Resend OTP response: $response');

        if (response != null && response['status'] == 1) {
          startTimer();
          _clearOtpFields(); // Xóa controller duy nhất
          Get.snackbar(
            'Success',
            response['message'] ?? 'A new OTP has been sent.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
          );
        } else {
          _showErrorSnackbar('Error', response?['message'] ?? 'Could not resend OTP.');
        }
      } catch (e) {
        debugPrint('Error resending OTP: $e');
        _showErrorSnackbar('Error', 'Could not resend OTP: $e');
      } finally {
        isLoading.value = false;
      }
    } else if (email != null && email!.isNotEmpty) {
        debugPrint('Resend OTP for email requested, but no dedicated API exists yet.');
        _showErrorSnackbar('Not Available', 'Resending OTP via email is not currently supported.');
    } else {
         _showErrorSnackbar('Error', 'Contact information not found.');
    }
  }

  void _clearOtpFields() {
    // ---->> THAY ĐỔI: Xóa controller duy nhất <<----
    pinController.clear();
    // for (var controller in otpControllers) { // Dòng cũ
    //   controller.clear();
    // }
  }

   void _showErrorSnackbar(String title, String message) {
    // ... (giữ nguyên)
     Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
   }
}