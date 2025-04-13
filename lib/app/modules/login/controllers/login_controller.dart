import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Assuming these paths are correct for your project structure
import '../../../core/utilities/preferences.dart';
import '../../../core/utilities/string.dart';
import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart'; // Adjusted path assuming data layer

/// Global controllers to prevent disposal during navigation
final Map<String, TextEditingController> _globalControllers = {};

class LoginController extends GetxController {
  // --- Updated Controllers ---
  // Use getters instead of direct controller references
  TextEditingController get emailController =>
      _globalControllers['login_email'] ??= TextEditingController();

  TextEditingController get passwordController =>
      _globalControllers['login_password'] ??= TextEditingController();

  // Removed phoneController and autoFilledPhone

  // --- State Variables ---
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final deviceName = "test_device".obs; // Consider getting the actual device name/ID

  // --- Dependencies ---
  // Ensure AuthRepository and Repo classes are correctly defined and imported
  final AuthRepository _authRepository = Repo.auth;
  final isReadyForInput = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("LoginController initialized");

    // Defer controller updates to after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // --- Removed Pre-fill Logic for Phone ---
      // If you need to pre-fill email from arguments (e.g., after registration),
      // you can adapt the previous logic here using 'email' argument key.
      // Example:
      // if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      //   final emailArg = Get.arguments['email'];
      //   if (emailArg != null && emailArg is String) {
      //     emailController.text = emailArg;
      //   }
      // }

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

  // --- Updated Validation ---
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    // Basic email validation regex
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

  // --- Updated Formatting (Simpler for Email) ---
  String formatEmail(String email) {
    return email.trim(); // Just trim whitespace for email
  }

  // Removed formatPhoneNumber

  // Check login status (Auto-login if "Remember Me" is enabled)
  Future<void> _checkLoginStatus() async {
    // Ensure Preferences.isAuth() checks for the existence of a token appropriately
    if (await Preferences.getBool('rememberMe') ?? false) {
       rememberMe.value = true;
       // Check if a token exists (adapt this check based on your Preferences implementation)
       String? token = await Preferences.getString(StringUtils.token);
       if (token != null && token.isNotEmpty) {
         // Consider verifying token validity here before navigating
         Get.offAllNamed('/home');
       } else {
         // Clean up rememberMe if token is missing
         await Preferences.setBool('rememberMe', false);
         rememberMe.value = false;
       }
    } else {
      rememberMe.value = false;
    }
  }


  // --- Updated State Saving ---
  Future<void> _saveLoginState(String token, Map<String, dynamic> user) async {
    await Preferences.setBool('rememberMe', rememberMe.value);

    if (user['id'] != null) {
      Preferences.setString(StringUtils.currentId, user['id'].toString());
    }

    // Save email instead of phone
    if (user['email'] != null) {
      // Ensure StringUtils.email constant exists
      Preferences.setString(StringUtils.email, user['email']);
    } else {
      // Handle case where email might be missing in response (log or default)
       debugPrint("Warning: Email missing in user data during saveLoginState");
    }

    // Removed saving phone number

    if (rememberMe.value) {
       Preferences.setString(StringUtils.token, token);
       // Save refresh token if available and needed
       if (user['refresh_token'] != null) {
         Preferences.setString(StringUtils.refreshToken, user['refresh_token']);
       }
    } else {
      // If not remembering, consider if you still need to store the token temporarily.
      // GetStorage might be for session-only storage.
      final box = GetStorage(); // Or use your preferred session storage
      await box.write('access_token', token); // Session token
      // Clear persistent token if "Remember Me" is unchecked
      await Preferences.remove(StringUtils.token);
      await Preferences.remove(StringUtils.refreshToken);
    }
  }


  // --- Updated Login Logic ---
  Future<void> login() async {
    // Ensure controllers are ready (prevents issues during initialization)
    if (!isReadyForInput.value) {
       debugPrint("Login attempt before input is ready.");
       return;
    }

    final email = emailController.text;
    final password = passwordController.text;

    // Validate Email
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

    // Validate Password
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

    isLoading.value = true; // Set loading state

    try {
      final formattedEmail = formatEmail(email);

      // IMPORTANT: Ensure your _authRepository.login method now expects
      // email as the first argument instead of phone number.
      final response = await _authRepository.login(
          formattedEmail, password, deviceName.value);

      // Check response structure (adjust based on your API)
      if (response != null && response['status'] == 1) {
        String? accessToken = response['access_token'];
        Map<String, dynamic>? userData = response['user'];

        if (accessToken != null && accessToken.isNotEmpty && userData != null) {
          await _saveLoginState(accessToken, userData);
          // Navigate to home screen after successful login and state saving
          Get.offAllNamed(Routes.dashboard);
          // No need to set isLoading = false here due to navigation
          return; // Exit function after successful navigation
        } else {
          // Handle case where token or user data is missing despite status 1
          Get.snackbar(
            'Lỗi',
            'Phản hồi đăng nhập không hợp lệ.', // More specific error
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange[100],
            colorText: Colors.orange[800],
          );
        }
      } else {
        // Handle login failure (status != 1 or null response)
        Get.snackbar(
          'Lỗi Đăng Nhập', // Clearer title
          response?['message'] ?? 'Email hoặc mật khẩu không đúng.', // Default/API message
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
      }
    } catch (e) {
      // Handle exceptions during the API call or processing
      debugPrint('Lỗi đăng nhập Exception: $e');
      Get.snackbar(
        'Lỗi Hệ Thống', // More generic error for exceptions
        'Đã xảy ra sự cố. Vui lòng thử lại.\nError: ${e.toString()}', // Provide error details for debugging
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      // Ensure isLoading is always turned off if not navigated away
      // This handles cases where login fails or throws an error.
       isLoading.value = false;
    }
  }


  // --- Navigation Methods ---
  void goToForgotPassword() {
    // Ensure the forgot password flow is adapted for email if necessary
    Get.toNamed('/forgot-password');
  }

  void goToRegisterView() {
    Get.toNamed('/register');
  }

  // --- Google Sign-In Placeholder ---
  void signInWithGoogle() {
    // Implement Google Sign-In logic here
    debugPrint("Google Sign-In initiated (Not Implemented)");
     Get.snackbar('Thông báo', 'Chức năng đăng nhập Google đang được phát triển.');
  }


  // --- Cleanup ---
  @override
  void onClose() {
    debugPrint("LoginController being closed");
    // Note: Global controllers are not disposed here by design.
    // Use cleanupControllers() explicitly when appropriate (e.g., on app close).
    super.onClose();
  }

  /// Dispose controllers manually if needed (e.g., on logout or app termination)
  static void cleanupControllers() {
    debugPrint("Cleaning up global login controllers...");
    _globalControllers.forEach((key, controller) {
      debugPrint("Disposing controller: $key");
      controller.dispose();
    });
    _globalControllers.clear();
  }
   // Widget _continueWithPhone({required VoidCallback onPressed}) {
  //   // Consider removing this if phone login is deprecated in this flow
  //   return Padding( // Add padding
  //     padding: const EdgeInsets.symmetric(vertical: 5.0),
  //     child: TextButton(
  //       style: TextButton.styleFrom(padding: EdgeInsets.zero),
  //       onPressed: onPressed, // Use the passed callback
  //       child: Container(
  //         height: 48,
  //         padding: const EdgeInsets.symmetric(horizontal: 16),
  //         decoration: BoxDecoration(
  //           // Use a consistent theme color if possible
  //           color: AppTheme.inputBoxColor ?? Colors.grey[200],
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(color: Colors.grey[300]!) // Add subtle border
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Image.asset(
  //               AppImage.phone, // Ensure AppImage.phone exists
  //               width: 24,
  //               height: 24,
  //             ),
  //             const SizedBox(width: 12), // Increased spacing
  //             const Text(
  //               "Continue with phone",
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.w500, // Slightly bolder
  //                 color: Colors.black87,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}