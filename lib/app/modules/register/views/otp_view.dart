import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../core/styles/style.dart';
import '../controllers/otp_controller.dart';
// Sửa tên file controller nếu cần

class OtpLoginView extends GetView<OtpLoginController> {
  const OtpLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // --- Pinput Theme ---
    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.13,
      height: screenHeight * 0.07,
      textStyle: TextStyle(
        fontSize: screenWidth * 0.05,
        fontWeight: FontWeight.w600,
        color: theme.textTheme.bodyLarge?.color ?? Colors.black,
      ),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppTheme.primary, width: 2),
      ),
    );
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: isDark ? Colors.grey[800] : const Color(0xFFE0E0E0),
      ),
    );
    // --- Kết thúc Pinput Theme ---

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('enter_verification_code'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Text(
                  "enter_code".tr,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w700,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.02),

                // ---->> BỎ Obx ở đây <<----
                Text(
                  "We sent a 6-digit code to\n${controller.contactInfo}", // Dùng trực tiếp getter
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: screenWidth * 0.038,
                    color: theme.textTheme.bodyMedium?.color,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // --- Ô nhập Pinput ---
                Center(
                  child: Pinput(
                    length: 6,
                    controller: controller.pinController, // Vẫn truyền controller
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    separatorBuilder: (index) => SizedBox(width: screenWidth * 0.02),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('PIN Entered: $pin');
                      controller.verifyOTP();
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 2,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                // --- Nút Verify (Giữ Obx) ---
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                  ),
                  child: Obx( // Obx này cần thiết
                        () => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor: AppTheme.primary,
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
                        'verify'.tr,
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
                SizedBox(height: screenHeight * 0.03),

                // --- Gửi lại OTP (Giữ Obx) ---
                Obx(() { // Obx này cần thiết
                  if (controller.isLoading.value) {
                    return const SizedBox(height: 20);
                  }
                  if (controller.secondsRemaining.value == 0) {
                    return Center(
                      child: TextButton(
                        onPressed: controller.resendOTP,
                        child: Text(
                          "resend".tr,
                          style: TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Resend code in ${controller.secondsRemaining.value}s",
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: screenWidth * 0.038,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
