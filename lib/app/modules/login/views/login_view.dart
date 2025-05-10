import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/styles/text_style.dart' as custom_text_style;
import '../../../core/utilities/utilities.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/container_button.dart';
import '../../../widgets/input_custom.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({super.key});
  final keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<LoginController>()) {
      Get.lazyPut(() => LoginController());
    }
    final bool showKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.titleLarge?.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: showKeyboard ? 100 : context.screenHeight * .25,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                      AppImage.logo,
                      width: 80),
                ),
              ),
            ),
            Container(
              child: 'log_in_to_soundFlow'.tr
                  .text
                  .style(custom_text_style.TGTextStyle.header)
                  .color(theme.textTheme.bodyLarge?.color)
                  .make(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: keyform,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'Email'
                              .text
                              .style(custom_text_style.TGTextStyle.body3)
                              .color(theme.textTheme.bodyLarge?.color)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                          fillColor: isDark ? Colors.grey[800] : AppTheme.inputBoxColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          onChanged: (String email) {
                            controller.emailController.text = email;
                          },
                          validator: (email) =>
                              controller.validateEmail(email),
                        ),
                        Dimes.height20,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'password'.tr
                              .text
                              .style(custom_text_style.TGTextStyle.body3)
                              .color(theme.textTheme.bodyLarge?.color)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                          fillColor: isDark ? Colors.grey[800] : AppTheme.inputBoxColor,
                          contentPadding: const EdgeInsets.all(Dimes.size15),
                          isPassword: true,
                          isShowSuffixIcon: true,
                          onChanged: (String password) {
                            controller.passwordController.text = password;
                          },
                          validator: (password) =>
                              controller.validatePassword(password),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Obx(() => AppButton(
                            'forgot_password?'.tr,
                            type: ButtonType.text,
                            axisSize: MainAxisSize.min,
                            fontSize: 12,
                            textColor: AppTheme.primary,
                            loading: controller.isLoading.value,
                            onPressed: controller.goToForgotPassword,
                          )),
                        ),
                        Dimes.height10,
                        ContainerButton(
                          child: Obx(() => AppButton(
                            'login'.tr,
                            color: Colors.transparent,
                            loading: controller.isLoading.value,
                            onPressed: () {
                              final isValid = keyform.currentState?.validate() ?? false;

                              if (isValid) {
                                controller.login(); 
                              } else {
        
                              }
                              // Get.toNamed(Routes.dashboard);
                            },
                          )),
                        ),
                        Dimes.height15,
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.grey)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('or'.tr),
                            ),
                            const Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        // _continueWithPhone(context, onPressed: () {}),
                        _continueWithGoogle(context),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            "don't_have_an_account?".tr
                                .text
                                .color(AppTheme.subtitleColor)
                                .size(16)
                                .medium
                                .make(),
                            Obx(() => AppButton(
                              'sign_up'.tr,
                              type: ButtonType.text,
                              fontSize: 16,
                              axisSize: MainAxisSize.min,
                              textColor: AppTheme.primary,
                              loading: controller.isLoading.value,
                              onPressed: controller.goToRegisterView,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _continueWithPhone(BuildContext context, {required VoidCallback onPressed}) {
  //   final isDark = Theme.of(context).brightness == Brightness.dark;
  //   return TextButton(
  //     onPressed: onPressed,
  //     child: Container(
  //       height: 48,
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: isDark ? Colors.grey[800] : Colors.grey[200],
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Image.asset(
  //             AppImage.phone,
  //             width: 24,
  //           ),
  //           Dimes.width8,
  //           Text(
  //             "continue_with_phone".tr,
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: isDark ? Colors.white70 : Colors.black87,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _continueWithGoogle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextButton(
      onPressed: () async {
        controller.signInWithGoogle();
      },
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.google,
              width: 24,
            ),
            Dimes.width8,
            Text(
              "continue_with_google".tr,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
