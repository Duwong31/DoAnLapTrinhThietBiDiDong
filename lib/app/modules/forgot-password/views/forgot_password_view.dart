import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Bỏ comment nếu bạn muốn nút back mặc định
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: SizedBox(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.35,
                      child: Image.asset(
                        AppImage.otpPhone, // Bạn có thể muốn đổi ảnh này
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    // Đã thay đổi tiêu đề
                    'forgot_your_password?'.tr,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode ? Colors.white : Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    // Đã thay đổi hướng dẫn
                    'enter_your_email_or_phone_number_below_to_receive_your_password_reset_instructions.'
                        .tr,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.9,
                    ),
                    child: TextFormField(
                      controller: controller.inputController,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'enter_email_or_phone_number'.tr,
                        hintStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          color: isDarkMode
                              ? Colors.grey[500]
                              : const Color(0xFFC9A895),
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[800]
                            : const Color(0xFFFFF5EF),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppTheme.primary.withOpacity(0.7),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.018,
                        ),
                      ),
                      validator: controller.validateInput,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          disabledBackgroundColor:
                              AppTheme.primary.withOpacity(0.5),
                          minimumSize: Size(
                            screenWidth * 0.8,
                            screenHeight * 0.06,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                'send_code'.tr,
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
