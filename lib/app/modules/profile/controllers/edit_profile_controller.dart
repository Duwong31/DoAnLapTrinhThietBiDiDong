import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart'; // Import Material
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/utilities/app_utils.dart';
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
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024
      );

      if (pickedFile != null) {
        avatar.value = File(pickedFile.path);
         debugPrint(">>> [EditProfileController] New avatar selected: ${avatar.value?.path}");
      } else {
         debugPrint(">>> [EditProfileController] User cancelled image picking.");
      }
    } catch (e) {
       debugPrint(">>> [EditProfileController] Image picking error: $e");
       AppUtils.toast('Could not select image. Please try again.');
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
    int? uploadedAvatarId;
    // 5. Call your repository/API to update the profile
    //    - Pass the updatedFullName
    //    - If newAvatarFile is not null, upload the avatar file and pass the resulting URL/ID
    try {
      if (newAvatarFile != null) {
         debugPrint(">>> [EditProfileController] Attempting to upload new avatar...");
         uploadedAvatarId = await Repo.user.uploadFile(newAvatarFile); // No folderId needed usually for avatar
         if (uploadedAvatarId == null) {
           // Handle upload failure specifically
           debugPrint(">>> [EditProfileController] Avatar upload failed (returned null ID).");
           throw Exception("Failed to upload avatar.");
         }
         debugPrint(">>> [EditProfileController] Avatar uploaded successfully, ID: $uploadedAvatarId");
      } else {
         debugPrint(">>> [EditProfileController] No new avatar file selected for upload.");
      }

      Map<String, dynamic> dataToUpdate = {
        'name': updatedFullName,
      };

      if (uploadedAvatarId != null) {
        dataToUpdate['avatar_id'] = uploadedAvatarId;
      }
       // If newAvatarFile is null (user didn't pick a new one),
       // we DON'T send avatar_id, preserving the existing one on the backend.
       // If you want to allow REMOVING the avatar, you'd need a separate mechanism
       // or agree on sending avatar_id: null or avatar_id: 0.

      // --- Step 3: Call the profile update API ---
      debugPrint(">>> [EditProfileController] Calling updateUserProfile with data: $dataToUpdate");

      await Repo.user.updateUserProfile(dataToUpdate);
      debugPrint(">>> [EditProfileController] Profile update API call successful.");
      // --- Xử lý khi thành công ---
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Đóng loading dialog
      }

      // Cập nhật dữ liệu user trong ProfileController (nếu có) để UI cập nhật ngay
       try {
        final profileController = Get.find<ProfileController>();
        await profileController.getUserDetail(); // Gọi hàm để làm mới dữ liệu
        debugPrint(">>> [EditProfileController] Đã làm mới dữ liệu ProfileController.");
      } catch (e) {
         debugPrint(">>> [EditProfileController] Không tìm thấy/làm mới được ProfileController: $e");
         // Không sao cả, màn hình Profile sẽ tự load lại khi quay về
      }
      avatar.value = null;

      Get.back(); // Navigate back to the previous screen (ProfileView)
      AppUtils.toast('Profile updated successfully'); // Show success message

    } catch (e) {
      // --- Step 5: Handle errors ---
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close loading dialog
      }

      String errorMessage = 'Failed to update profile.';
      if (e is DioException) { // Handle Dio specific errors
         errorMessage = e.response?.data?['message'] ?? e.message ?? errorMessage;
          debugPrint(">>> [EditProfileController] DioException: ${e.response?.statusCode} - ${e.response?.data}");
      } else { // Handle general errors
         errorMessage = e.toString();
          debugPrint(">>> [EditProfileController] General Exception: $e");
      }
      AppUtils.toast(errorMessage); // Show error message

    }
    // NO finally block needed to reset avatar.value here,
    // it should only be reset on SUCCESS to avoid losing the selection if save fails.
  }
}