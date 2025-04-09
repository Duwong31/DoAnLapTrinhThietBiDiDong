import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';


/// Global controllers to prevent disposal during navigation
final Map<String, TextEditingController> _globalControllers = {};

class ResetPasswordController extends GetxController {
  // Thêm formKey vào controller
  late final GlobalKey<FormState> formKey;
  
  TextEditingController get passwordController => 
      _globalControllers['reset_password'] ??= TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final AuthRepository _authRepository = Repo.auth;
  final isReadyForInput = false.obs;
  
  late String userId;
  late String phone;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    // Khởi tạo formKey
    formKey = GlobalKey<FormState>();
    
    debugPrint("ResetPasswordController initialized");
    _initializeData();
    
    // Mark controller as ready for input after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isReadyForInput.value = true;
    });
  }

  void _initializeData() {
    try {
      if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
        userId = Get.arguments['userId'] ?? '';
        phone = Get.arguments['phone'] ?? '';
        otp = Get.arguments['otp'] ?? '';
        debugPrint('ResetPasswordController received userId: $userId, phone: $phone, otp: $otp');
      } else {
        userId = '';
        phone = '';
        otp = '';
        debugPrint('ResetPasswordController received no arguments or invalid format');
      }
      
      if (phone.isEmpty || otp.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar(
            'Cảnh báo',
            'Thông tin không đầy đủ. Vui lòng thử lại từ đầu.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange[100],
            colorText: Colors.orange[800],
          );
        });
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  bool isPasswordValid(String password) {
    return password.length >= 6;
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

  Future<void> resetPassword() async {
    if (!isReadyForInput.value) return;
    
    final password = passwordController.text;
    
    if (!isPasswordValid(password)) {
      Get.snackbar(
        'Lỗi',
        'Vui lòng nhập mật khẩu có ít nhất 6 ký tự',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }
    
    if (phone.isEmpty || otp.isEmpty) {
      Get.snackbar(
        'Lỗi',
        'Thông tin không đầy đủ để đặt lại mật khẩu',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }
      
    try {
      isLoading.value = true; 
      
      final response = await _authRepository.resetPassword(
        phone,
        otp,
        password,
        password
      ); 
      
      if (response['status'] == 1) {
        // Store data before navigation
        final storedPhone = phone;
        
        Get.snackbar(
          'Thành công',
          'Đặt lại mật khẩu thành công',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(seconds: 2));
        
        // Clear password field
        passwordController.clear();
        
        // Navigate to login
        Get.offAllNamed(
          '/login',
          arguments: {'phone': storedPhone}
        );
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Lỗi',
          response['message'] ?? 'Không thể đặt lại mật khẩu',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Chi tiết lỗi đặt lại mật khẩu: $e');
      
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Lỗi',
          'Không thể đặt lại mật khẩu: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    }
  }

  @override
  void onClose() {
    debugPrint("ResetPasswordController being closed");
    super.onClose();
  }

  static void cleanupControllers() {
    if (_globalControllers.containsKey('reset_password')) {
      _globalControllers['reset_password']?.dispose();
      _globalControllers.remove('reset_password');
    }
  }
} 