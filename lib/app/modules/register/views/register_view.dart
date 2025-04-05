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

    return Scaffold(
        // appBar: BackToStartPage(), // Assuming this is a custom widget
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
                      width: 80),
                  ),
                ),
              ),
              Container(
                child: 'Sign up to SoundFlow'
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
                          child: 'UserName'
                              .text
                              .style(custom_text_style.TGTextStyle.body3)
                              .make(),
                        ),
                        Dimes.height10,
                        InputCustom(
                            fillColor: AppTheme.inputBoxColor,  
                            contentPadding: const EdgeInsets.all(Dimes.size15),
                            onChanged: (String fullname) {
                              controller.fullname = fullname;
                            },
                            validator: (fullname) =>
                                controller.emailValidation(fullname)),
                        Dimes.height20,
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
                              controller.email = email;
                            },
                            validator: (email) =>
                                controller.emailValidation(email)),
                        Dimes.height20,
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
                            controller.password = password;
                          },
                          validator: (password) =>
                              controller.passwordValidation(password)),
                        Dimes.height20,
                        Container(
                          alignment: Alignment.centerLeft,
                          child: 'Confirm Password'
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
                          onChanged: (String confirmPassword) {
                            controller.confirmPassword = confirmPassword;
                          },
                          validator: (confirmPassword) =>
                              controller.confirmPasswordValidation(confirmPassword)),
                        Dimes.height15,
                        ContainerButton(
                          child: Obx(() => AppButton(
                                'Sign up',
                                color: Colors.transparent,
                                loading: controller.isLoading,                               
                                onPressed: () {
                                  keyform.currentState!.validate();
                                  controller.onPressSignUpButton();
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
                        Dimes.height15,
                        _continueWithPhone(onPressed: (){}),
                        _continueWithGoogle(),
                        Dimes.height15,
                        // Go to Login
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
                                    loading: controller.isLoading,
                                    onPressed: controller.goToLogin,
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
  
