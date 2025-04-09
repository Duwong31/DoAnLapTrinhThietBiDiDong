import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/styles/text_style.dart' as custom_text_style;
import '../../../core/utilities/utilities.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../routes/app_pages.dart';
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
    return Scaffold(
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
              child: 'Log in to SoundFlow'
                  .text
                  .style(custom_text_style.TGTextStyle.header)
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
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                            fillColor: AppTheme.inputBoxColor,  
                            contentPadding: const EdgeInsets.all(Dimes.size15),
                            onChanged: (String email) {
                              controller.emailController.text = email;
                            },
                            validator: (email) =>
                                controller.validateEmail(email)),
                        Dimes.height30,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'Password'
                              .text
                              .style(custom_text_style.TGTextStyle.body3)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                            fillColor: AppTheme.inputBoxColor,
                            contentPadding: const EdgeInsets.all(Dimes.size15),
                            isPassword: true,
                            isShowSuffixIcon: true,
                            onChanged: (String password) {
                              controller.passwordController.text = password;
                            },
                            validator: (password) =>
                                controller.validatePassword(password)),
                        Container(
                          alignment: Alignment.topRight,
                          child: Obx(() => AppButton(
                                'Forgot Password?',
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
                                'Login',
                                color: Colors.transparent,
                                loading: controller.isLoading.value,                               
                                onPressed: () {
                                  // keyform.currentState!.validate();
                                  // controller.onPressLoginButton();
                                  Get.toNamed(Routes.dashboard);
                                },
                              )),
                        ),
                        Dimes.height15,
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('or'),
                            ),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        _continueWithPhone(onPressed: (){}),
                        _continueWithGoogle(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            'Don\'t have an account?'
                                .text
                                .color(AppTheme.subtitleColor)
                                .size(16)
                                .medium
                                .make(),
                            Obx(() => AppButton(
                                  'Sign up',
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
  Widget _continueWithPhone({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: () async{
      
        },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200], 
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.phone,
              width: 24,
            ),
            const SizedBox(width: 8),
            // Text
            const Text(
              "Continue with phone",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _continueWithGoogle() {
    return TextButton(
      onPressed: () async{
        controller.signInWithGoogle();
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200], 
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.google,
              width: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              "Continue with Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
