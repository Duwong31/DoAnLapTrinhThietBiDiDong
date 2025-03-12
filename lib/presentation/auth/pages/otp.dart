import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/reset_password.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({super.key});

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  void _onNextPressed() {
    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ResetPasswordPage(),
                    ),
                  );
    // ignore: unused_local_variable
    String otp = _otpControllers.map((e) => e.text).join(); // User OTP
    
  }

  void _onResendPressed() {
    
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double otpBoxSize = (screenWidth * 0.12).clamp(40.0, 50.0);

    return Scaffold(
      appBar: BasicBackButton(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tiêu đề
            const Text(
              "Enter your code",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // Hàng nhập OTP
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Focus(
                      onKeyEvent: (FocusNode node, KeyEvent event) {
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.backspace) {
                          if (_otpControllers[index].text.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                            _otpControllers[index - 1].clear();
                            return KeyEventResult.handled;
                          }
                        }
                        return KeyEventResult.ignored;
                      },
                      child: SizedBox(
                        width: otpBoxSize,
                        height: otpBoxSize,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: screenWidth < 350 ? 18 : 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Mô tả
            Center(
              child: Text(
                "We sent a 6-digit code to 0908969499.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth < 350 ? 14 : 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Nút Next
            Center(
              child: SizedBox(
                width: screenWidth * 0.4,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontSize: screenWidth < 350 ? 16 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Nút Resend Code với icon
            Center(
              child: TextButton.icon(
                onPressed: _onResendPressed,
                icon: const Icon(Icons.refresh, color: Colors.black),
                label: Text(
                  "Resend code",
                  style: TextStyle(
                    fontSize: screenWidth < 350 ? 14 : 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
