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
                      key: controller.formKey,
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
                              controller: controller.fullnameController,
                            ),
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
                              // onChanged: (String email) {
                              // controller.emailController.text = email;
                              // },
                              // validator: (email) =>
                              //     controller.validateEmail(email),
                              controller: controller.emailController,
                          ),
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
                            controller: controller.passwordController,
                            validator: (password) =>
                                controller.validatePassword(password),),
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
                            controller: controller.confirmPasswordController,
                            validator: (confirmPassword) =>
                                controller.validateConfirmPassword(confirmPassword),),
                          Dimes.height15,
                          ContainerButton(
                            child: Obx(() => AppButton(
                                  'Sign up',
                                  color: Colors.transparent,
                                  loading: controller.isLoading.value,                               
                                  onPressed: () {
                                    // keyform.currentState!.validate();
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
                          Dimes.height5,
                          _continueWithGoogle(),
                          Dimes.height15,
                          // Go to Login
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                'Already have an account?'
                                    .text
                                    .color(AppTheme.subtitleColor)
                                    .size(16)
                                    .medium
                                    .make(),
                                Obx(() => AppButton(
                                      'Login',
                                      type: ButtonType.text,
                                      fontSize: 16,
                                      axisSize: MainAxisSize.min,
                                      textColor: AppTheme.primary,
                                      loading: controller.isLoading.value || controller.isGoogleLoading.value,
                                      onPressed: (controller.isLoading.value || controller.isGoogleLoading.value) ? null : controller.goToLogin,
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
    // Xem xét loại bỏ nếu không hỗ trợ đăng ký/đăng nhập bằng SĐT ở màn này
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Bỏ padding mặc định của TextButton
        shape: RoundedRectangleBorder( // Thêm bo góc cho hiệu ứng nhấn
           borderRadius: BorderRadius.circular(8),
        )
      ),
      onPressed: onPressed, // Logic xử lý sẽ ở đây
      child: Container(
        height: 48,
        // width: double.infinity, // Chiếm hết chiều ngang nếu cần
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.phone, // Đảm bảo đường dẫn ảnh đúng
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12), // Tăng khoảng cách
            const Text(
              "Continue with phone", // Sửa tiếng Việt
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500, // Đậm hơn một chút
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _continueWithGoogle() {
    return Obx(() => TextButton( // Wrap bằng Obx để disable khi đang loading
      style: TextButton.styleFrom(
         padding: EdgeInsets.zero,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(8),
        )
      ),
      // Gọi hàm signInWithGoogle của controller
      // Disable nút khi đang loading (cả loading thường và google)
      onPressed: (controller.isLoading.value || controller.isGoogleLoading.value) ? null : controller.signInWithGoogle,
      child: Container(
        height: 48,
        // width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Hiển thị loading indicator nếu isGoogleLoading = true
            if (controller.isGoogleLoading.value)
             const SizedBox(
                 width: 20,
                 height: 20,
                 child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary)
             )
            else
             Image.asset(
               AppImage.google, // Đảm bảo đường dẫn ảnh đúng
               width: 24,
               height: 24,
             ),

            const SizedBox(width: 12),
            Text(
              controller.isGoogleLoading.value ? "processing..." : "Continue withGoogle", // Thay đổi text khi loading
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ));
  }
  }
    
