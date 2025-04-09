import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';

class OtpLoginController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());
  final secondsRemaining = 60.obs;
  Timer? timer;
  final isLoading = false.obs;

  final AuthRepository _authRepository = Repo.auth;

  // Input fields storage
  late String phoneNumber;
  late String userId;
  final isResetPassword = false.obs;
  final String countryCode = '+84';
  static const String deviceName = "test_device";

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  void _initializeData() {
    try {
      final args = Get.arguments as Map<String, dynamic>;
      phoneNumber = args['phone'] ?? '';
      userId = args['userId'] ?? '';
      isResetPassword.value = args['isResetPassword'] ?? false;

      startTimer();
    } catch (e) {
      debugPrint('Error initializing OTP data: $e');
    }
  }

  @override
  void onClose() {
    try {
      // Cancel timer
      if (timer != null) {
        timer?.cancel();
        timer = null;
      }

      for (var controller in otpControllers) {
        if (controller.text.isNotEmpty) {
          controller.clear();
        }
        controller.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing OTP controllers: $e');
    } finally {
      super.onClose();
    }
  }

  void startTimer() {
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

  Future<void> verifyOTP()async {
    Get.toNamed(Routes.successSplash);
  }
  // Future<void> verifyOTP() async {
  //   if (isLoading.value) return;

  //   String otp = otpControllers.map((controller) => controller.text).join();

  //   if (otp.length != 6) {
  //     Get.snackbar('Lỗi', 'Vui lòng nhập đủ mã OTP',
  //         snackPosition: SnackPosition.TOP);
  //     return;
  //   }

  //   if (userId.isEmpty) {
  //     Get.snackbar('Lỗi', 'Không tìm thấy thông tin người dùng',
  //         snackPosition: SnackPosition.TOP);
  //     return;
  //   }

  //   try {
  //     isLoading.value = true;
  //     debugPrint('Sending OTP verification with userId: $userId, otp: $otp');

  //     final response = await _authRepository.verifyOtp(userId, otp, deviceName);

  //     debugPrint('OTP verification response: $response');

  //     if (response['status'] == 1) {
  //       timer?.cancel();

  //       for (var controller in otpControllers) {
  //         if (controller.text.isNotEmpty) {
  //           controller.clear();
  //         }
  //       }

  //       final Map<String, String> args = {
  //         'userId': userId,
  //         'phone': phoneNumber,
  //         'otp': otp
  //       };
  //       Get.back();
  //       await Get.toNamed(Routes.successSplash, arguments: args);
        
  //     } else {
  //       Get.snackbar(
  //         'Lỗi xác thực',
  //         response['message'] ?? 'Mã OTP không đúng hoặc đã hết hạn',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.red[100],
  //         colorText: Colors.red[800],
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('OTP verification error: $e');
  //     Get.snackbar(
  //       'Lỗi xác thực',
  //       'Chi tiết lỗi: $e',
  //       snackPosition: SnackPosition.TOP,
  //       backgroundColor: Colors.red[100],
  //       colorText: Colors.red[800],
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> resendOTP() async {
    if (isLoading.value) return;

    if (phoneNumber.isEmpty) {
      Get.snackbar('Lỗi', 'Không tìm thấy thông tin số điện thoại',
          snackPosition: SnackPosition.TOP);
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('Gửi request resend OTP với số điện thoại: $phoneNumber');
      final response = await _authRepository.resendOtp(phoneNumber);
      debugPrint('Response từ resend OTP: $response');

      if (response['status'] == 1) {
        startTimer();

        for (var controller in otpControllers) {
          controller.clear();
        }

        Get.snackbar(
          'Thông báo',
          response['message'] ?? 'Đã gửi lại mã OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        Get.snackbar(
          'Lỗi',
          response['message'] ?? 'Không thể gửi lại OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi gửi lại OTP: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể gửi lại OTP: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
