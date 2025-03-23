import 'package:flutter/material.dart';
import 'package:soundflow/core/configs/theme/app_colors.dart';
import 'package:soundflow/presentation/auth/pages/reset_password.dart';

class VerifySuccessPage extends StatelessWidget {
  const VerifySuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Biểu tượng check (có thể dùng Icon hoặc Image)
                Icon(
                  Icons.check_circle_outlined,
                  color: Colors.orange,
                  size: 100,
                ),
                const SizedBox(height: 20),
                
                // Tiêu đề
                Text(
                  "Verification Successful!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary ,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Dòng mô tả
                Text(
                  "Thank you for using our service",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Nút Next
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const ResetPasswordPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: Size.fromHeight(48),
                    ),
                    child: Text('Next', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}