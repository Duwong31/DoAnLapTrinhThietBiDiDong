import 'package:get/get.dart';

import '../../../core/utilities/utilities.dart';
import '../../../core/utilities/validator/validator.dart';
import '../../../data/repositories/repositories.dart';
import '../../../packages/intl_phone_field/phone_number.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _isLoading = false.obs;

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
