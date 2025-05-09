import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  // Find the existing controller instance, assuming it was put correctly before navigating here
  // Or use Get.put() if this is the first time it's created for this route
  final EditProfileController ctr = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'edit_profile'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: ctr.saveProfile, // Call the save method on the controller
            child: Text('save'.tr, style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Use ListView for better handling of content that might exceed screen height
        child: ListView( // Changed from Column to ListView
          children: [
            const SizedBox(height: 20),
            // --- Avatar Section ---
            Obx(() {
              ImageProvider? imageProvider;
                if (ctr.avatar.value != null) {
                  // New avatar selected (File)
                  imageProvider = FileImage(ctr.avatar.value!);
                } else if (ctr.user.value?.avatar != null && ctr.user.value!.avatar!.isNotEmpty) {
                  // Existing avatar URL from user data
                  imageProvider = NetworkImage(ctr.user.value!.avatar!);
                } else {
                  // No avatar selected or exists
                  imageProvider = null; // Will show placeholder icon
                }
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                       // Use FileImage if avatar.value is a File
                       // Use NetworkImage if ctr.user.value.avatar is a URL initially
                      backgroundImage: imageProvider,
                      child: (imageProvider == null)
                          ? Icon(Icons.person_outline, color: Colors.grey[400], size: 60) // Placeholder icon
                          : null,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: ctr.changeAvatar,
                      child: const Text(
                        'change photo',
                        style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              }
            ),
            const SizedBox(height: 32),

            // --- Full Name TextField ---
            Row(
              children: [
                Text(
                  'name'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Dimes.width12, // Khoảng cách giữa nhãn và ô nhập
                Expanded( // Giúp TextField chiếm hết phần còn lại của hàng
                  child: TextField(
                    controller: ctr.fullNameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),

            // --- Add other editable fields here (e.g., username, bio) ---
            // Example:
            // TextField(
            //   controller: ctr.usernameController, // Create this in your controller
            //   decoration: const InputDecoration(
            //     labelText: 'Username',
            //     border: UnderlineInputBorder(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}