import 'package:flutter/material.dart';
import 'package:soundflow/common/widgets/button/back_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Lấy chiều rộng màn hình
    double screenHeight = MediaQuery.of(context).size.height; // Lấy chiều cao màn hình

    return Scaffold(
      appBar: BasicBackButton(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: screenWidth * 0.9, // Đảm bảo không quá lớn trên màn hình rộng
            constraints: const BoxConstraints(maxWidth: 500), // Giới hạn tối đa 500px cho tablet
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Pick a new password",
                    style: TextStyle(
                      fontSize: screenWidth * 0.06, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Please enter a new password"),
                const SizedBox(height: 5),
                _buildPasswordField(_newPasswordController, _isObscureNew, (newValue) {
                  setState(() => _isObscureNew = newValue);
                }),
                const SizedBox(height: 16),
                const Text("Confirm new password"),
                const SizedBox(height: 5),
                _buildPasswordField(_confirmPasswordController, _isObscureConfirm, (newValue) {
                  setState(() => _isObscureConfirm = newValue);
                }),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Xử lý logic đổi mật khẩu ở đây
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Change password",
                      style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hàm tạo input mật khẩu với viền và icon hiển thị mật khẩu
  Widget _buildPasswordField(
      TextEditingController controller, bool isObscure, Function(bool) toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => toggleVisibility(!isObscure),
        ),
      ),
    );
  }
}
