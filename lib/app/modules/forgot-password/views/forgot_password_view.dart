import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../controller/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
                  // Responsive image container
                  Center(
                    child: SizedBox(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.35,
                      child: Image.asset(
                        AppImage.otpPhone,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Title text with responsive font size
                  Text(
                    'Enter Phone Number',
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Phone input field with constraints
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.9,
                    ),
                    child: TextFormField(
                      controller: controller.phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '0000000000',
                        hintStyle: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          height: 2,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFDCC7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      validator: controller.validatePhone,
                    ),
                  ),
                  Dimes.height5,
                  // Continue button with responsive size
                  const Text('We\'ll send you a code to confirm your phone number',  textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
                  Dimes.height15,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    child: ElevatedButton(
                      onPressed: controller.onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        minimumSize: Size(
                          screenWidth * 0.8,
                          screenHeight * 0.05,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Bottom padding to ensure scrollability
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
