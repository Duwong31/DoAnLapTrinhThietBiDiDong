import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../controllers/otp_controller.dart';



class OtpLoginView extends GetView<OtpLoginController> {
  const OtpLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate OTP field size based on screen width
    final otpFieldSize = (screenWidth - (24.0 * 2) - (10 * 5)) / 6;

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
              vertical: screenHeight * 0.0002,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'ENTER YOUR CODE',
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: screenWidth * 0.065,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange[800],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.01),
                // Phone number text
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: 'We sent a 6-digit code to ',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                      letterSpacing: 0.005,
                      color: const Color(0xFF1A202C),
                    ),
                    children: [
                      TextSpan(
                        text: '[${controller.phoneNumber}]',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                          letterSpacing: 0.005,
                          color: const Color(0xFF1A202C),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                // OTP input fields
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: otpFieldSize,
                        height: otpFieldSize,
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller.otpControllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontFamily: "Noto Sans",
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF64748B),
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintStyle: TextStyle(
                              fontFamily: "Noto Sans",
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF90A3BF),
                            ),
                          ),
                          onChanged: (value) {
                             if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          onTap: () {
                            if (controller.otpControllers[index].text == "0") {
                              controller.otpControllers[index].clear();
                            }
                          },
                          onSubmitted: (_) {
                            if (index == 5) {
                              controller.verifyOTP();
                            }
                          },
                          onEditingComplete: () {
                            if (index == 5) {
                              controller.verifyOTP();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                
                // Resend OTP timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Gửi lại ',
                      style: TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    Obx(() {
                      return controller.secondsRemaining.value == 0
                          ? GestureDetector(
                              onTap: () => controller.resendOTP(),
                              child: Text(
                                'OTP',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans',
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange[800],
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Text(
                              '(${controller.secondsRemaining.value}s)',
                              style: TextStyle(
                                fontFamily: 'Noto Sans',
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: Colors.orange[800],
                              ),
                            );
                    }),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // Continue button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                  child: Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () => controller.verifyOTP(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        fixedSize: Size(screenWidth * 0.3, screenHeight * 0.07), // 👈 Chiều ngang cố định
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
                          letterSpacing: 0.005,
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
    );
  }
}
