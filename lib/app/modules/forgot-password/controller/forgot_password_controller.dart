import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';


final Map<String, TextEditingController> _globalControllers = {};

class ForgotPasswordController extends GetxController {

  late final GlobalKey<FormState> formKey;
  
  TextEditingController get phoneController => 
      _globalControllers['forgot_phone'] ??= TextEditingController();
      
  final AuthRepository _authRepository = Repo.auth;
  final isLoading = false.obs;
  final phoneText = ''.obs;
  final isReadyForInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    
    debugPrint("ForgotPasswordController initialized");
    
    phoneController.addListener(() {
      phoneText.value = phoneController.text;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isReadyForInput.value = true;
    });
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String formatPhoneNumber(String phone) {
    phone = phone.trim();
    if (RegExp(r'^0[0-9]{9}$').hasMatch(phone)) {
      return '+84${phone.substring(1)}';
    }
    return phone;
  }

  Future<void> onSubmit() async {
    if (!isReadyForInput.value) return;
    
    final phoneValue = phoneController.text;
    // final phoneValidation = validatePhone(phoneValue);
    
    // if (phoneValidation != null) {
    //   Get.snackbar(
    //     'Lỗi',
    //     phoneValidation,
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.red[100],
    //     colorText: Colors.red[800],
    //   );
    //   return;
    // }

    try {
      // isLoading.value = true;
      // final formattedPhone = formatPhoneNumber(phoneValue);
      
      // debugPrint('Gửi request forgot password với số điện thoại: $formattedPhone');
      // final response = await _authRepository.forgotPassword(formattedPhone);
      
      // debugPrint('Response từ forgot password: $response');
      
      // if (response != null && response['status'] == 1) {
      //   if (response['user_id'] != null) {
      //     final storedPhone = formattedPhone;
      //     final storedUserId = response['user_id'].toString();
          
      //     final Map<String, dynamic> args = {
      //       'phone': storedPhone,
      //       'userId': storedUserId,
      //       'isResetPassword': true,
      //     };

          //hide OTP
          // if (storedOtp != null) {
          //   Get.snackbar(
          //     'Mã OTP',
          //     'Mã OTP của bạn là: $storedOtp',
          //     snackPosition: SnackPosition.TOP,
          //     backgroundColor: Colors.green[100],
          //     colorText: Colors.green[800],
          //     duration: const Duration(seconds: 4),
          //   );
            
          //   await Future.delayed(const Duration(milliseconds: 500));
          // }

          // await Get.toNamed(Routes.otpLogin, arguments: args);
    //       await Get.toNamed(Routes.otpLogin);
          
    //     } else {
    //       Get.snackbar(
    //         'Lỗi',
    //         'Không nhận được thông tin người dùng',
    //         snackPosition: SnackPosition.TOP,
    //         backgroundColor: Colors.red[100],
    //         colorText: Colors.red[800],
    //       );
    //     }
    //   } else {
    //     Get.snackbar(
    //       'Lỗi',
    //       response?['message'] ?? 'Không thể gửi mã OTP',
    //       snackPosition: SnackPosition.TOP,
    //       backgroundColor: Colors.red[100],
    //       colorText: Colors.red[800],
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('Lỗi khi gửi OTP: $e');
    //   Get.snackbar(
    //     'Lỗi',
    //     'Không thể gửi mã OTP: $e',
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.red[100],
    //     colorText: Colors.red[800],
    //   );
    // } finally {
    //   isLoading.value = false;
    // }
    final dummyArgs = {
      'phone': '+841234567890',
      'userId': 'test_user_id',
      'isResetPassword': true,
    };
    await Get.toNamed(Routes.otpLogin, arguments: dummyArgs);
  } catch (e) {
    debugPrint('Lỗi khi test next: $e');
  } finally {
    isLoading.value = false;
  }
  }

  @override
  void onClose() {
    debugPrint("ForgotPasswordController being closed");
    super.onClose();
  }

  static void cleanupControllers() {
    if (_globalControllers.containsKey('forgot_phone')) {
      _globalControllers['forgot_phone']?.dispose();
      _globalControllers.remove('forgot_phone');
    }
  }
}
