import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Import Material
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import 'profile_controller.dart';
// You might need to fetch the user data here or pass it during navigation
// For now, let's assume user might be initially null

class EditProfileController extends GetxController{
  final user = Rxn<UserModel>(); // How is this user populated? Needs initialization.
  var avatar = Rx<File?>(null);
  // Manage the TextEditingController here
  late TextEditingController fullNameController;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize the controller. Fetch user data if needed first.
    // If user data comes later, you might need to update the controller text then.
    // Example: Initialize with current user value (handle null)
    _initializeUserData(); // Call a method to set up user and controller
  }

  void _initializeUserData() {
    if (Get.arguments != null && Get.arguments is UserModel) {
      user.value = Get.arguments as UserModel; // Gán UserModel nhận được cho biến user
      debugPrint(">>> [EditProfileController] Received user data: ${user.value?.fullName}");
    } else {

      debugPrint(">>> [EditProfileController] Warning: No user data received via arguments.");
    }
    fullNameController = TextEditingController(text: user.value?.fullName ?? '');

    // Optional: If user data loads asynchronously AFTER onInit, update here:
    // ever(user, (_) {
    //   fullNameController.text = user.value?.fullName ?? '';
    //   // Move cursor to end if needed after programmatic change
    //   fullNameController.selection = TextSelection.fromPosition(
    //       TextPosition(offset: fullNameController.text.length));
    // });
  }


  @override
  void onClose() {
    // Dispose the controller when the controller is closed
    fullNameController.dispose();
    super.onClose();
  }

  Future<void> changeAvatar() async {
    final picker = ImagePicker();
    // Consider adding image quality options
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      avatar.value = File(pickedFile.path);
      // Note: This only changes the display. You need to upload this file
      // and update the user's profile on the backend when 'Save' is pressed.
    }
  }

  void saveProfile() async {
    String updatedFullName = fullNameController.text.trim();

    File? newAvatarFile = avatar.value;
    if (updatedFullName.isEmpty) {
      Get.snackbar('Error', 'Full name cannot be empty');
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    // 5. Call your repository/API to update the profile
    //    - Pass the updatedFullName
    //    - If newAvatarFile is not null, upload the avatar file and pass the resulting URL/ID
    try {
      // Chuẩn bị dữ liệu gửi đi (chỉ gửi những gì muốn cập nhật)
      Map<String, dynamic> dataToUpdate = {
        'name': updatedFullName,
        // Thêm các trường khác nếu bạn có TextField và muốn cập nhật
        // 'first_name': firstNameController.text.trim(), // Ví dụ
        // 'last_name': lastNameController.text.trim(), // Ví dụ
        // 'phone': phoneController.text.trim(), // Ví dụ
        // 'bio': bioController.text.trim(), // Ví dụ
      };

      // Gọi hàm updateUserProfile từ Repository
      // Giả sử bạn đã khởi tạo Repo: import 'package:your_app/data/repositories/repositories.dart';
      final UserModel updatedUser = await Repo.user.updateUserProfile(dataToUpdate);

      // --- Xử lý khi thành công ---
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Đóng loading dialog
      }

      // Cập nhật dữ liệu user trong ProfileController (nếu có) để UI cập nhật ngay
      try {
        // Tìm ProfileController và cập nhật giá trị user
         final profileController = Get.find<ProfileController>();
         profileController.user.value = updatedUser;
         debugPrint(">>> [EditProfileController] Updated ProfileController locally.");
      } catch (e) {
         debugPrint(">>> [EditProfileController] Could not find ProfileController to update locally: $e");
         // Có thể gọi getUserDetail() ở ProfileView sau khi quay lại
      }

      Get.back(); // Quay lại màn hình ProfileView
      Get.snackbar('Success', 'Profile updated successfully'); // Thông báo thành công

      // Tùy chọn: Có thể gọi lại hàm fetch user của ProfileController sau khi quay lại
      // để đảm bảo dữ liệu là mới nhất từ server (dù đã cập nhật local)
      // Future.delayed(Duration(milliseconds: 100), () {
      //   try {
      //     Get.find<ProfileController>().getUserDetail();
      //   } catch (e) {}
      // });


    } catch (e) {
      // --- Xử lý khi thất bại ---
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Đóng loading dialog
      }

      // Hiển thị lỗi cụ thể hơn nếu có thể
      String errorMessage = 'Failed to update profile.';
      if (e is DioException && e.response?.data is Map) {
         // Cố gắng lấy message lỗi từ response API
         errorMessage = e.response!.data['message'] ?? errorMessage;
         // Bạn cũng có thể xử lý lỗi validation chi tiết hơn nếu API trả về 'errors'
         // Ví dụ: final errors = e.response!.data['errors'];
      } else {
         errorMessage = e.toString(); // Lỗi chung
      }
      debugPrint(">>> [EditProfileController] Save Profile Error: $e");
      Get.snackbar('Error', errorMessage); // Thông báo lỗi
    }
  }
}