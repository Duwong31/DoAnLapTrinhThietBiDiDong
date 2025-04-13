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

    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Forgot Your Password?',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: screenWidth * 0.055, // Tăng kích thước font một chút
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: screenHeight * 0.015), // Giảm khoảng cách
                   Text(
                    // Đã thay đổi hướng dẫn
                    'Enter your email or phone number below to receive your password reset instructions.',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600], // Màu chữ nhẹ hơn
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04), // Tăng khoảng cách
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.9,
                    ),
                    child: TextFormField(
                      // Đã đổi tên controller
                      controller: controller.inputController,
                      // Đã đổi kiểu bàn phím
                      keyboardType: TextInputType.emailAddress, // Cho phép @ và ký tự khác
                      autocorrect: false, // Tắt tự động sửa lỗi
                      decoration: InputDecoration(
                        // Đã đổi hint text
                        hintText: 'Enter Email or Phone Number',
                        hintStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: screenWidth * 0.038,
                          fontWeight: FontWeight.w400,
                          // height: 2, // Bỏ height để căn giữa tốt hơn
                          color: const Color(0xFFC9A895), // Màu hint mới
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFF5EF), // Màu nền mới nhẹ nhàng hơn
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: AppTheme.primary.withOpacity(0.7)), // Thêm icon
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.018, // Tăng padding dọc
                        ),
                      ),
                      // Đã đổi hàm validate
                      validator: controller.validateInput,
                    ),
                  ),
                  // Dimes.height5, // Có thể bỏ nếu không cần khoảng cách nhỏ này
                  // Đã thay đổi văn bản hướng dẫn phụ
                  // const Text(
                  //   'We\'ll send you a code to reset your password',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(fontSize: 12),
                  // ),
                  SizedBox(height: screenHeight * 0.04), // Tăng khoảng cách trước nút
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: Obx(
                      () => ElevatedButton(
                        // Sử dụng controller.isLoading để hiển thị trạng thái loading
                        onPressed: controller.isLoading.value ? null : controller.onSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          disabledBackgroundColor: AppTheme.primary.withOpacity(0.5), // Màu khi disable
                          minimumSize: Size(
                            screenWidth * 0.8,
                            screenHeight * 0.06, // Tăng chiều cao nút
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        // Hiển thị loading hoặc text
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
                                'Send Code', // Đổi text nút
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: screenWidth * 0.045, // Điều chỉnh font size
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