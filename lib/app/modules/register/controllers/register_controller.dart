import 'package:dartz/dartz.dart'; // Cần import dartz
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import service (chỉ dùng cho Google) và models
import '../../../data/services/auth_firebase_service.dart'; 

// Import Repository (dùng cho signup thường)
import '../../../data/repositories/repositories.dart'; // <<< THÊM IMPORT REPO

// Import utilities và routes
import '../../../routes/app_pages.dart';
import '../../../core/utilities/validator/validator.dart'; // *** Import validator nếu cần ***


class RegisterController extends GetxController {
  // --- Dependencies ---
  // Sử dụng Repo cho signup thường (giống LoginController)
  final AuthRepository authRepository = Repo.auth; // <<< SỬ DỤNG REPO
  // Giữ lại authService chỉ cho Google Sign In
  final authServiceForGoogle = AuthFirebaseServiceImpl(); // <<< ĐỔI TÊN CHO RÕ RÀNG

  // --- State ---
  final formKey = GlobalKey<FormState>(); // Key cho Form validation
  final _isLoading = false.obs; // Loading state cho signup thường
  bool get isLoading => _isLoading.value;
  final isGoogleLoading = false.obs; // Loading state cho Google
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // --- Input Data (Giống LoginController) ---
  // Giá trị sẽ được cập nhật từ View thông qua formKey.currentState?.save()
  String? fullname;
  String? email;
  String? password;
  String? confirmPassword; 

  // --- Methods ---

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // --- Validation Methods (Giữ nguyên) ---
   String? fullnameValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your full name";
    }
    return null;
  }

  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your Email";
    }
    if (!GetUtils.isEmail(value)) {
      return "Invalid entered Email";
    }
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Password";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

   String? confirmPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return "Please confirm your Password";
    }
    // Kiểm tra với biến password đã được save
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // --- Core Logic Helper for Standard Signup (Tương tự login() trong LoginController) ---
  // Gọi đến Repository thay vì service Firebase trực tiếp
  Future<Either<String, String>> signup() async {
    // Đảm bảo các giá trị đã được lưu từ form
    if (fullname == null || email == null || password == null || confirmPassword == null) {
       return const Left('Form data is incomplete.');
    }
    // Kiểm tra mật khẩu trùng khớp trước khi gửi đi
    if (password != confirmPassword) {
      return const Left('Password and Confirm Password do not match!');
    }

    try {
      // Gọi phương thức mới trong Repository
      final response = await Repo.auth.register(
          email!.trim(),
          fullname!.trim(),
          true
      );
      return Right(response); // Wrap the response in a Right to match the Either type
    } catch (e) {
      // Bắt các lỗi không mong muốn khác (mặc dù repo nên trả về Either)
      return Left('An unexpected error occurred during signup: ${e.toString()}');
    }
  }


  // --- Button Press Handler (Tương tự onPressLoginButton) ---
  void onPressSignUpButton() async {
    final currentState = formKey.currentState;
    if (currentState == null) return;

    // 1. Lưu dữ liệu từ Form
    currentState.save();

    // 2. Validate Form
    if (!currentState.validate()) {
      return;
    }

    // 3. Bắt đầu loading và gọi logic đăng ký qua Repository
    _isLoading.value = true;
    final result = await signup(); // Gọi hàm signup() dùng Repo
    _isLoading.value = false;

    // 4. Xử lý kết quả trả về từ Repository (API)
    result.fold(
      (failureMessage) {
        // Hiển thị lỗi
        Get.snackbar(
          'Sign Up Failed',
          failureMessage, // Thông báo lỗi từ API
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      },
      (successMessage) {
        // Hiển thị thành công và điều hướng
        Get.snackbar(
          'Success',
          successMessage, // Thông báo thành công từ API
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        goToLogin(); // Điều hướng đến trang đăng nhập
      },
    );
  }


  // --- Google Sign In Logic (Giữ nguyên - gọi trực tiếp service Firebase) ---
  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true;
    try {
      // Gọi trực tiếp service Firebase cho Google Sign In
      final userCredential = await authServiceForGoogle.loginWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        Get.snackbar(
          'Success',
          'Logged in with Google successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Điều hướng đến màn hình chính
        Get.offAllNamed(Routes.dashboard); // Hoặc Routes.home
      } else {
        // Xử lý lỗi/hủy bỏ
        Get.snackbar(
          'Error',
          'Google Sign-in failed or cancelled. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Bắt lỗi không mong muốn
      Get.snackbar(
        'Error',
        'An unexpected error occurred during Google Sign-In: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // --- Navigation (Giữ nguyên) ---
  void goToLogin() {
    Get.offNamed(Routes.login);
  }

  // --- Lifecycle ---
  @override
  void onClose() {
    // Không còn TextEditingController để dispose
    super.onClose();
  }
}