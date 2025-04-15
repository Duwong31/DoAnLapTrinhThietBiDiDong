
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/auth_firebase_service.dart';
import '../../../data/repositories/repositories.dart'; 
import '../../../routes/app_pages.dart';
// import '../../../core/utilities/validator/validator.dart'; // Bỏ comment nếu dùng

class RegisterController extends GetxController {
  // --- Dependencies ---
  final AuthRepository _authRepository = Repo.auth;
  final authServiceForGoogle = AuthFirebaseServiceImpl();

  // --- State ---
  final formKey = GlobalKey<FormState>(); // Key cho Form validation
  final isLoading = false.obs;
  final isGoogleLoading = false.obs; // Loading state cho Google
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // --- Input Controllers (Sử dụng Controllers thay vì lưu biến trực tiếp) ---
  final fullnameController = TextEditingController(); // Thêm controller cho fullname
  final emailController = TextEditingController();
  final passwordController = TextEditingController(); // Thêm controller cho password
  final confirmPasswordController = TextEditingController(); // Thêm controller cho confirm password

  // --- Constants ---
  // static const String deviceName = "test_device"; // Lấy device name động nếu có thể
  late String deviceName; // Khai báo để khởi tạo trong onInit

  // --- Methods ---

  @override
  void onInit() {
    super.onInit();
    // Lấy device name/ID thực tế ở đây nếu có thể
    // Ví dụ đơn giản:
    deviceName = GetPlatform.isAndroid ? "android_device" : GetPlatform.isIOS ? "ios_device" : "web_device";
    // Hoặc sử dụng package device_info_plus để lấy ID cụ thể
  }


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // --- Validation Methods ---
  // Sử dụng trực tiếp trong TextFormField hoặc InputCustom thay vì gọi từ controller
  // Ví dụ validator cho TextFormField: validator: (value) => validateFullname(value),
  String? validateFullname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập họ tên"; // Sửa tiếng Việt
    }
    return null;
  }

  String? validateEmail(String? value) { // Sửa kiểu trả về thành String?
    if (value == null || value.trim().isEmpty) {
      return "Vui lòng nhập Email"; // Sửa tiếng Việt
    }
    if (!GetUtils.isEmail(value.trim())) {
      return "Email không hợp lệ"; // Sửa tiếng Việt
    }
    return null; // Trả về null nếu hợp lệ
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng nhập mật khẩu"; // Sửa tiếng Việt
    }
    if (value.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự"; // Sửa tiếng Việt
    }
    // Thêm kiểm tra độ phức tạp nếu backend yêu cầu (ví dụ: chữ hoa, ký tự đặc biệt)
    // final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{6,}$');
    // if (!passwordRegExp.hasMatch(value)) {
    //   return 'Mật khẩu cần chữ hoa, ký tự đặc biệt'; // Sửa tiếng Việt
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Vui lòng xác nhận mật khẩu"; // Sửa tiếng Việt
    }
    // Kiểm tra với passwordController trực tiếp
    if (value != passwordController.text) {
      return "Mật khẩu không khớp"; // Sửa tiếng Việt
    }
    return null;
  }

  Future<void> _performEmailSignup() async { 
    final name = fullnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    isLoading.value = true;
    try {
      debugPrint('Gửi yêu cầu đăng ký cho email: $email với device: $deviceName');

      // *** Gọi API chỉ với email và deviceName ***
      final response = await _authRepository.register(
        name,
        email, 
        password,
        deviceName, 
      );
      debugPrint('Phản hồi đăng ký: $response');

  
      if (response["status"] == true) {
        // String otp = response["data"]["otp"]?.toString() ?? ''; 
        // String userId = response["data"]["user_id"]?.toString() ?? '';

        // debugPrint('Nhận được otp: $otp, userId: $userId');
        // debugPrint('Nhận được userId: $userId');


        // if (userId.isEmpty) {
        //   Get.snackbar(
        //     "Lỗi đăng ký",
        //     "Không nhận được thông tin user_id từ server.",
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Colors.red[100],
        //     colorText: Colors.red[800],
        //   );
        //   // Không set isLoading = false ở đây vì có finally
        //   return; // Thoát sớm nếu không có userId
        // }
        Get.snackbar(
            "Đăng ký thành công",
            response["message"] ?? "Tài khoản của bạn đã được tạo. Vui lòng đăng nhập.", 
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
          );

        Get.offAllNamed(
          Routes.login,
          arguments: {
            'email': email, 
            // 'userId': userId,
            // 'isResetPassword': false, 
          },
        );
      } else {
        // Hiển thị lỗi từ server
        Get.snackbar(
          "Đăng ký thất bại",
          response["message"] ?? "Có lỗi xảy ra, vui lòng thử lại.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } on DioException catch (e) {
      debugPrint('DioException khi đăng ký: $e');
      debugPrint('DioException response: ${e.response?.data}');
      String apiError = "Lỗi không xác định từ máy chủ.";
      if (e.response?.data is Map && e.response!.data['message'] != null) {
        apiError = e.response!.data['message'];
      } else if (e.response?.data != null) {
        apiError = e.response!.data.toString();
      } else if (e.message != null) {
        apiError = e.message!;
      }
      Get.snackbar(
        "Lỗi Máy Chủ", // Sửa tiêu đề
        apiError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    } catch (e) {
      debugPrint('Lỗi đăng ký không xác định: $e');
      Get.snackbar(
        "Lỗi Hệ Thống", // Sửa tiêu đề
        "Đã xảy ra lỗi không mong muốn: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isLoading.value = false; // Luôn tắt loading ở cuối
    }
  }


  // --- Button Press Handler (Xử lý nhấn nút Đăng ký) ---
  void onPressSignUpButton() {
    final currentState = formKey.currentState;
    if (currentState == null) {
      debugPrint("Form state is null");
      return;
    }

    if (!currentState.validate()) {
      debugPrint("Form validation failed");
      // Tự động hiển thị lỗi trên các trường Input
      return;
    }
    _performEmailSignup(); // Gọi hàm helper đã tạo
  }


  // --- Google Sign In Logic (Giữ nguyên) ---
  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      final userCredential = await authServiceForGoogle.loginWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        Get.snackbar(
          'Thành công', // Sửa tiếng Việt
          'Đăng nhập bằng Google thành công!', // Sửa tiếng Việt
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Routes.dashboard); // Điều hướng đến dashboard
      } else {
        // Người dùng có thể đã hủy bỏ
        Get.snackbar(
          'Thông báo', // Sửa tiêu đề
          'Đăng nhập Google thất bại hoặc đã bị hủy.', // Sửa tiếng Việt
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Bắt lỗi không mong muốn
      Get.snackbar(
        'Lỗi', // Sửa tiếng Việt
        'Đã xảy ra lỗi không mong muốn khi đăng nhập Google: ${e.toString()}', // Sửa tiếng Việt
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // --- Navigation ---
  void goToLogin() {
    // Có thể dùng Get.back() nếu màn đăng ký được mở từ đăng nhập
    // Hoặc dùng offNamed để xóa màn đăng ký khỏi stack
    Get.offNamed(Routes.login);
  }

  // --- Cleanup ---
  @override
  void onClose() {
    // Dispose controllers để tránh rò rỉ bộ nhớ
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}