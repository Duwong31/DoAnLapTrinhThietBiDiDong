import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/styles/text_style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../core/widgets/background_widget.dart';
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
      body: BackgroundWidget(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: showKeyboard ? 100 : context.screenHeight * .25,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(AppImage.logo),
                ),
              ),
            ),
            Container(
              child: 'Welcome Back'.text.style(TGTextStyle.header).make(),
            ),
            Container(
              child: 'Login to access your account'
                  .text
                  .style(TGTextStyle.body2)
                  .make(),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: keyform,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'Enter Your Email'
                              .text
                              .style(TGTextStyle.body3)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                            fillColor: AppTheme.inputBoxColor,
                            contentPadding: const EdgeInsets.all(Dimes.size15),
                            onChanged: (String email) {
                              controller.email = email;
                            },
                            validator: (email) =>
                                controller.emailValidation(email)),
                        Dimes.height30,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'Enter Your Password'
                              .text
                              .style(TGTextStyle.body3)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                            fillColor: AppTheme.inputBoxColor,
                            contentPadding: const EdgeInsets.all(Dimes.size15),
                            isPassword: true,
                            isShowSuffixIcon: true,
                            onChanged: (String password) {
                              controller.password = password;
                            },
                            validator: (password) =>
                                controller.passwordValidation(password)),
                        Container(
                          alignment: Alignment.topRight,
                          child: Obx(() => AppButton(
                                'Forgot Password?',
                                type: ButtonType.text,
                                axisSize: MainAxisSize.min,
                                fontSize: 12,
                                textColor: AppTheme.primary,
                                loading: controller.isLoading,
                                onPressed: controller.goToRecoveryAccountView,
                              )),
                        ),
                        Dimes.height15,
                        ContainerButton(
                          child: Obx(() => AppButton(
                                'Login',
                                color: Colors.transparent,
                                loading: controller.isLoading,
                                onPressed: () {
                                  keyform.currentState!.validate();
                                  controller.onPressLoginButton();
                                },
                              )),
                        ),
                        Dimes.height15,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            'Don\'t have an account?'
                                .text
                                .color(AppTheme.appBarTintColor)
                                .size(12)
                                .medium
                                .make(),
                            Obx(() => AppButton(
                                  'Sign up',
                                  type: ButtonType.text,
                                  fontSize: 12,
                                  axisSize: MainAxisSize.min,
                                  textColor: AppTheme.primary,
                                  loading: controller.isLoading,
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
}
