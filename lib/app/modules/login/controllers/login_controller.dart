import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../core/utilities/validator/validator.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/auth_firebase_service.dart';
import '../../../packages/intl_phone_field/phone_number.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final authService = AuthFirebaseServiceImpl();
  final formKey = GlobalKey<FormState>();
  bool get isLoading => _isLoading.value;

  PhoneNumber? phoneNumber;
  String? email;
  String? password;

  @override
  void onReady() {
    Preferences.clear();
    super.onReady();
  }

  String? emailValidation(String? email) {
    String? result;
    if (email == null || email.isEmpty) {
      result = "Please enter your Email";
      return result;
    }
    result = EmailValidator("Invalid entered Email").validate(email);
    return result;
  }

  String? passwordValidation(String? password) {
    String? result;
    if (password == null || password.isEmpty) {
      result = "Please enter Password";
      return result;
    }
    return result;
  }

  Future<bool> login() async {
    return Repo.auth.sendEmailPassword(email!, password!);
  }
  Future<void> signInWithGoogle() async {
    isGoogleLoading.value = true; // Use specific loading state
    try {
      final userCredential = await authService.loginWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        Get.snackbar(
          'Success',
          'Logged in with Google successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.dashboard);
      } else {
        
        Get.snackbar(
          'Error',
          'Google Sign-in failed or cancelled. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent, 
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Catch unexpected errors during the process
      Get.snackbar(
        'Error',
        'An unexpected error occurred during Google Sign-In: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false; // Stop Google loading indicator
    }
  }
  void onPressLoginButton() async {
    if (await login()) {
      goToHomeView();
    }
    //
  }

  void onPressSignupButton() {
    goToRegisterView();
  }

  void onPressForgotPassword() {
    goToRecoveryAccountView();
  }

  void goToRegisterView() {
    Get.toNamed(Routes.register);
  }

  void goToHomeView() {
    Get.toNamed(Routes.home);
  }

  void goToRecoveryAccountView() {}
}
