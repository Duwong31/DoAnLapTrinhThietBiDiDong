import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/repositories.dart';
import '../../../routes/app_pages.dart';

// Giữ lại _globalControllers nếu bạn dùng nó ở nơi khác, nếu không có thể bỏ
final Map<String, TextEditingController> _globalControllers = {};

class ForgotPasswordController extends GetxController {
  late final GlobalKey<FormState> formKey;

  // Đổi tên controller cho phù hợp hơn
  TextEditingController get inputController =>
      _globalControllers['forgot_input'] ??= TextEditingController();

  final AuthRepository _authRepository = Repo.auth;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    formKey = GlobalKey<FormState>();
    debugPrint("ForgotPasswordController initialized");
  }

  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  bool _isPhoneNumber(String input) {
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    return phoneRegex.hasMatch(input);
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or phone number';
    }
    if (!_isEmail(value) && !_isPhoneNumber(value)) {
      return 'Invalid email or phone number format';
    }
    return null;
  }

  String formatPhoneNumber(String phone) {
    phone = phone.trim();
    if (_isPhoneNumber(phone)) {
      return '+84${phone.substring(1)}';
    }
    return phone;
  }

  Future<void> onSubmit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    final inputValue = inputController.text.trim();

    if (_isEmail(inputValue)) {
      // ---->>> GỌI HÀM ĐÃ ĐƯỢC SỬA ĐỔI <<<----
      await _checkEmailAndProceed(inputValue);
    } else if (_isPhoneNumber(inputValue)) {
      // Giữ nguyên logic gửi OTP qua phone nếu bạn muốn
      final formattedPhone = formatPhoneNumber(inputValue);
      await _sendOtpViaPhone(formattedPhone);
      // Hoặc bạn cũng có thể tạo hàm _checkPhoneAndProceed tương tự nếu muốn test cả phone
    } else {
      _showErrorSnackbar('Error', 'Invalid input format.');
    }
  }

  // ----- HÀM MỚI ĐỂ KIỂM TRA EMAIL VÀ CHUYỂN HƯỚNG (THAY THẾ _sendOtpViaEmail) -----
  Future<void> _checkEmailAndProceed(String email) async {
    try {
      isLoading.value = true;
      debugPrint('Checking if email exists (temporary mode): $email');

      // *** Vẫn gọi API forgotPasswordEmail để backend kiểm tra email tồn tại ***
      // Backend sẽ cố gửi mail và có thể báo lỗi (do mạng bị chặn),
      // nhưng nếu email tồn tại, nó vẫn sẽ trả về status: 1 và user_id (dựa theo code Laravel của bạn).
      // Nếu email không tồn tại, nó sẽ trả về lỗi 'email_not_found'.
      final response = await _authRepository.forgotPasswordEmail(email);

      debugPrint('Response from checking email existence: $response');

      // --- Xử lý response trong chế độ tạm thời ---
      if (response != null) {
          // Trường hợp 1: Email tồn tại (Backend trả về status 1, bất kể gửi mail thành công hay không)
          if (response['status'] == 1 && response['user_id'] != null) {
              debugPrint("Email exists. Navigating to OTP screen (temporary mode).");
              final storedUserId = response['user_id'].toString();
              final Map<String, dynamic> args = {
                  'email': email, // Gửi email để màn hình OTP biết context
                  'userId': storedUserId,
                  'isResetPassword': true,
                   // Bạn có thể thêm một flag để màn hình OTP biết đây là chế độ test
                  'isTestMode': true,
              };
              // Chuyển màn hình OTP
              await Get.toNamed(Routes.otpLogin, arguments: args);
          }
          // Trường hợp 2: Email không tồn tại (Backend trả về lỗi cụ thể)
          else if (response['status'] == 0 && response['message'] == 'email_not_found') {
              _showErrorSnackbar('Error', 'Email not found in the database.');
          }
          // Trường hợp 3: Các lỗi khác từ backend (ví dụ: lỗi server không mong muốn khác ngoài việc gửi mail)
          else {
              _showErrorSnackbar('Error', response['message'] ?? 'An unknown error occurred while checking email.');
          }
      } else {
        // Trường hợp response là null (có thể do lỗi mạng không bắt được trong repo)
        _showErrorSnackbar('Error', 'Could not connect to the server to check email.');
      }

    } catch (e) {
      // Bắt các lỗi không mong muốn khác (DioError, etc.)
      debugPrint('Error checking email existence: $e');
      _showErrorSnackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }
  // -----------------------------------------------------------------------------

  // Hàm xử lý gửi OTP qua Phone (Giữ nguyên hoặc sửa đổi tương tự nếu cần test)
  Future<void> _sendOtpViaPhone(String formattedPhone) async {
    try {
      isLoading.value = true;
      debugPrint('Sending forgot password request via phone: $formattedPhone');
      final response = await _authRepository.forgotPassword(formattedPhone);
      debugPrint('Response from forgot password phone: $response');

      if (response != null && response['status'] == 1) {
        if (response['user_id'] != null) {
          final storedUserId = response['user_id'].toString();
          final Map<String, dynamic> args = {
            'phone': formattedPhone,
            'userId': storedUserId,
            'isResetPassword': true,
          };
          await Get.toNamed(Routes.otpLogin, arguments: args);
        } else {
          _showErrorSnackbar('Error', 'User information not received.');
        }
      } else {
        _showErrorSnackbar('Error', response?['message'] ?? 'Could not send OTP via phone.');
      }
    } catch (e) {
      debugPrint('Error sending OTP via phone: $e');
      _showErrorSnackbar('Error', 'Could not send OTP via phone: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red[100],
      colorText: Colors.red[800],
    );
  }

  @override
  void onClose() {
    debugPrint("ForgotPasswordController being closed");
    super.onClose();
  }

  static void cleanupControllers() {
    if (_globalControllers.containsKey('forgot_input')) {
      _globalControllers['forgot_input']?.dispose();
      _globalControllers.remove('forgot_input');
    }
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../data/repositories/repositories.dart';
// import '../../../routes/app_pages.dart';

// // Giữ lại _globalControllers nếu bạn dùng nó ở nơi khác, nếu không có thể bỏ
// final Map<String, TextEditingController> _globalControllers = {};

// class ForgotPasswordController extends GetxController {
//   late final GlobalKey<FormState> formKey;

//   // Đổi tên controller cho phù hợp hơn
//   TextEditingController get inputController =>
//       _globalControllers['forgot_input'] ??= TextEditingController();

//   final AuthRepository _authRepository = Repo.auth;
//   final isLoading = false.obs;
//   // Bỏ phoneText và isReadyForInput nếu không còn dùng
//   // final phoneText = ''.obs;
//   // final isReadyForInput = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     formKey = GlobalKey<FormState>();
//     debugPrint("ForgotPasswordController initialized");

//     // Bỏ listener nếu không dùng phoneText
//     // phoneController.addListener(() {
//     //   phoneText.value = phoneController.text;
//     // });

//     // Bỏ nếu không dùng isReadyForInput
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   isReadyForInput.value = true;
//     // });
//   }

//   // Hàm kiểm tra xem input có phải là email không
//   bool _isEmail(String input) {
//     // Regex đơn giản để kiểm tra email (có thể dùng regex phức tạp hơn nếu cần)
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     return emailRegex.hasMatch(input);
//   }

//   // Hàm kiểm tra xem input có phải là số điện thoại (dạng 10 số bắt đầu bằng 0)
//   bool _isPhoneNumber(String input) {
//     final phoneRegex = RegExp(r'^0[0-9]{9}$');
//     return phoneRegex.hasMatch(input);
//   }


//   // Hàm validation mới cho cả email và phone
//   String? validateInput(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email or phone number';
//     }
//     // Kiểm tra nếu không phải email và cũng không phải phone (theo format đơn giản)
//     if (!_isEmail(value) && !_isPhoneNumber(value)) {
//        return 'Invalid email or phone number format';
//     }
//     return null; // Hợp lệ
//   }

//   // Giữ lại hàm format số điện thoại
//   String formatPhoneNumber(String phone) {
//     phone = phone.trim();
//     // Chỉ format nếu nó đúng là dạng số điện thoại Việt Nam 10 số
//     if (_isPhoneNumber(phone)) {
//       return '+84${phone.substring(1)}';
//     }
//     // Trả về nguyên gốc nếu không phải dạng cần format
//     return phone;
//   }

//   Future<void> onSubmit() async {
//     // Bỏ if (!isReadyForInput.value) return; nếu không dùng nữa

//     // Validate form trước
//     if (!formKey.currentState!.validate()) {
//       return; // Dừng nếu validation thất bại
//     }

//     final inputValue = inputController.text.trim();

//     // Xác định loại input và gọi API tương ứng
//     if (_isEmail(inputValue)) {
//       await _sendOtpViaEmail(inputValue);
//     } else if (_isPhoneNumber(inputValue)) {
//       final formattedPhone = formatPhoneNumber(inputValue);
//       await _sendOtpViaPhone(formattedPhone);
//     } else {
//       // Trường hợp này không nên xảy ra do đã validate, nhưng để phòng ngừa
//        Get.snackbar(
//         'Error',
//         'Invalid input format.',
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//       );
//     }
//   }

//   // Hàm xử lý gửi OTP qua Email
//   Future<void> _sendOtpViaEmail(String email) async {
//      try {
//       isLoading.value = true;
//       debugPrint('Sending forgot password request via email: $email');
//       // Gọi API forgotPasswordEmail
//       final response = await _authRepository.forgotPasswordEmail(email);

//       debugPrint('Response from forgot password email: $response');

//       if (response != null && response['status'] == 1) {
//         // Thành công, chuyển sang màn hình OTP
//         // Cần đảm bảo API trả về user_id
//         if (response['user_id'] != null) {
//            final storedUserId = response['user_id'].toString();

//            // Tạo arguments để gửi sang màn hình OTP
//            // Quan trọng: Gửi 'email' thay vì 'phone'
//            final Map<String, dynamic> args = {
//              'email': email, // Gửi email
//              'userId': storedUserId,
//              'isResetPassword': true,
//            };

//            // Chuyển màn hình với arguments
//            await Get.toNamed(Routes.otpLogin, arguments: args);

//         } else {
//            _showErrorSnackbar('Error', 'User information not received.');
//         }

//       } else {
//         // Xử lý lỗi từ API
//          _showErrorSnackbar('Error', response?['message'] ?? 'Could not send OTP via email.');
//       }
//     } catch (e) {
//       debugPrint('Error sending OTP via email: $e');
//       _showErrorSnackbar('Error', 'Could not send OTP via email: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Hàm xử lý gửi OTP qua Phone
//   Future<void> _sendOtpViaPhone(String formattedPhone) async {
//     try {
//       isLoading.value = true;
//       debugPrint('Sending forgot password request via phone: $formattedPhone');
//       // Gọi API forgotPassword (cho phone)
//       final response = await _authRepository.forgotPassword(formattedPhone);

//       debugPrint('Response from forgot password phone: $response');

//       if (response != null && response['status'] == 1) {
//          // Thành công, chuyển sang màn hình OTP
//          // Cần đảm bảo API trả về user_id
//         if (response['user_id'] != null) {
//           final storedUserId = response['user_id'].toString();

//           // Tạo arguments để gửi sang màn hình OTP
//           // Gửi 'phone'
//           final Map<String, dynamic> args = {
//             'phone': formattedPhone, // Gửi phone đã format
//             'userId': storedUserId,
//             'isResetPassword': true,
//           };

//           // Chuyển màn hình với arguments
//           await Get.toNamed(Routes.otpLogin, arguments: args);

//         } else {
//           _showErrorSnackbar('Error', 'User information not received.');
//         }
//       } else {
//          // Xử lý lỗi từ API
//         _showErrorSnackbar('Error', response?['message'] ?? 'Could not send OTP via phone.');
//       }
//     } catch (e) {
//       debugPrint('Error sending OTP via phone: $e');
//        _showErrorSnackbar('Error', 'Could not send OTP via phone: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Helper function để hiển thị snackbar lỗi
//   void _showErrorSnackbar(String title, String message) {
//      Get.snackbar(
//         title,
//         message,
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//       );
//   }


//   @override
//   void onClose() {
//     debugPrint("ForgotPasswordController being closed");
//     // Không cần gọi cleanupControllers trừ khi bạn chắc chắn cần nó
//     // cleanupControllers();
//     super.onClose();
//   }

//   // Cập nhật cleanup nếu cần
//   static void cleanupControllers() {
//     if (_globalControllers.containsKey('forgot_input')) {
//       _globalControllers['forgot_input']?.dispose();
//       _globalControllers.remove('forgot_input');
//     }
//   }
// }