import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../controllers/reset_password_controller.dart';


class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Bạn có thể bỏ comment dòng này nếu muốn nút back
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06,
              ),
              child: Form(
                key: controller.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: SizedBox(
                        height: screenHeight * 0.15,
                        width: screenWidth * 0.3,
                        child: Image.asset(
                          AppImage.resetPassword,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Title text with responsive font size
                    Text(
                      'PICK A NEW PASSWORD', // Nên dùng i18n cho các chuỗi text
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Password field
                    Obx(() => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.9, // Giữ nguyên ràng buộc chiều rộng tối đa
                      ),
                      child: TextFormField(
                        controller: controller.passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: 'Enter new password', // Nên dùng i18n
                          hintStyle: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            height: 2,
                            // Chỉnh màu hint text dễ nhìn hơn
                            color: const Color(0xFF9E9E9E), // Ví dụ: màu xám
                          ),
                          filled: true,
                           // Chỉnh màu nền field dễ nhìn hơn
                          fillColor: const Color(0xFFF5F5F5), // Ví dụ: xám nhạt
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.018, // Có thể giảm padding dọc một chút
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600], // Chỉnh màu icon rõ hơn
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        validator: controller.validatePassword,
                      ),
                    )),

                    SizedBox(height: screenHeight * 0.02),

                    Obx(() => ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.9,
                      ),
                      child: TextFormField(
                        controller: controller.confirmPasswordController, // Use the new controller
                        obscureText: !controller.isConfirmPasswordVisible.value, // Use the new visibility state
                        decoration: InputDecoration(
                          hintText: 'Confirm new password', // i18n
                          hintStyle: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            height: 2,
                            color: const Color(0xFF9E9E9E),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.018,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value // Use the new visibility state
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[600],
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility, // Use the new toggle method
                          ),
                        ),
                        validator: controller.validateConfirmPassword, // Use the new validator
                      ),
                    )),

                    SizedBox(height: screenHeight * 0.04),
                    // Submit button - ĐÃ CHỈNH SỬA KÍCH THƯỚC
                    Obx(() => Padding(

                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.25, 
                      ),
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (controller.formKey.currentState!.validate()) {
                                  controller.resetPassword();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, 
                          // Bỏ minimumSize để nút tự điều chỉnh theo padding và content
                          // minimumSize: Size(screenWidth * 0.8, screenHeight * 0.07),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06, 
                            vertical: screenHeight * 0.02, 
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100), 
                          ),
                          disabledBackgroundColor: Colors.grey,
                           elevation: 3, // Thêm chút đổ bóng
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 24.0, // Cỡ chữ ~24
                                width: 24.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'Confirm', // Nên dùng i18n
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: screenWidth * 0.045, 
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    )),

                    // Bottom padding
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}