import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/styles/text_style.dart' as custom_text_style;
import '../../../core/utilities/image.dart';
// import '../../../core/utilities/screen.dart'; // screen.dart was not used directly
import '../../../routes/app_pages.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/container_button.dart';
import '../../../widgets/input_custom.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});
  final keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool showKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black);
    final fillColor = Theme.of(context).inputDecorationTheme.fillColor ?? (isDark ? Colors.grey[850]! : AppTheme.inputBoxColor);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Logo
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: showKeyboard ? 100 : context.screenHeight * .25,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    AppImage.logo,
                    width: 80,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ),
            // Title
            Container(
              child: 'sign_up_to_soundflow'.tr
                  .text
                  .color(Theme.of(context).textTheme.bodyMedium?.color)
                  .style(custom_text_style.TGTextStyle.header)
                  .make(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // UserName
                        _buildLabel('user_name'.tr, textColor),
                        Dimes.height10,
                        InputCustom(
                          fillColor: fillColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          controller: controller.fullnameController,
                        ),
                        Dimes.height20,

                        // Email
                        _buildLabel('Email', textColor),
                        Dimes.height10,
                        InputCustom(
                          fillColor: fillColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          controller: controller.emailController,
                        ),
                        Dimes.height20,

                        // Password
                        _buildLabel('password'.tr, textColor),
                        Dimes.height10,
                        InputCustom(
                          fillColor: fillColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          isPassword: true,
                          isShowSuffixIcon: true,
                          controller: controller.passwordController,
                          validator: (password) => controller.validatePassword(password),
                        ),
                        Dimes.height20,

                        // Confirm Password
                        _buildLabel('confirm_password'.tr, textColor),
                        Dimes.height10,
                        InputCustom(
                          fillColor: fillColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          isPassword: true,
                          isShowSuffixIcon: true,
                          controller: controller.confirmPasswordController,
                          validator: (confirmPassword) => controller.validateConfirmPassword(confirmPassword),
                        ),
                        Dimes.height15,

                        // Sign up button
                        ContainerButton(
                          child: Obx(() => AppButton(
                            'sign_up'.tr,
                            color: Colors.transparent,
                            loading: controller.isLoading.value,
                            onPressed: controller.onPressSignUpButton,
                          )),
                        ),
                        Dimes.height15,

                        // Divider
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('or'.tr),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        Dimes.height15,

                        // Continue with Phone and Google
                        _continueWithPhone(onPressed: () {}),
                        Dimes.height5,
                        _continueWithGoogle(),
                        Dimes.height15,

                        // Go to Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            'already_have_an_account?'.tr
                                .text
                                .color(textColor)
                                .size(16)
                                .medium
                                .make(),
                            Obx(() => AppButton(
                              'login'.tr,
                              type: ButtonType.text,
                              fontSize: 16,
                              axisSize: MainAxisSize.min,
                              textColor: AppTheme.primary,
                              loading: controller.isLoading.value || controller.isGoogleLoading.value,
                              onPressed: (controller.isLoading.value || controller.isGoogleLoading.value)
                                  ? null
                                  : controller.goToLogin,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      alignment: Alignment.centerLeft,
      child: text.text.color(color).style(custom_text_style.TGTextStyle.body3).make(),
    );
  }

  Widget _continueWithPhone({required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImage.phone, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              "continue_with_phone".tr,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueWithGoogle() {
    return Obx(() => TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: (controller.isLoading.value || controller.isGoogleLoading.value)
          ? null
          : controller.signInWithGoogle,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isGoogleLoading.value)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
              )
            else
              Image.asset(AppImage.google, width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              controller.isGoogleLoading.value ? "processing...".tr : "continue_with_google".tr,
              style: TextStyle(
                fontSize: 16,
                color: Get.isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
