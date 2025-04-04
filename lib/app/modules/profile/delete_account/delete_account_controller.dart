import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../data/providers/providers.dart';
import '../../../routes/app_pages.dart';

class DeleteAccountController extends GetxController {
  final isRequestDeleteAccount = false.obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    getUserIsRequestDeleteAccount();
    super.onReady();
  }

  Future<void> getUserIsRequestDeleteAccount() async {
    isLoading.value = true;
    ApiProvider.getDetail().then((value) {
      isRequestDeleteAccount.value = value.isDeleted;
      isLoading.value = false;
    });
  }

  void deleteYourAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
              ApiProvider.deleteRecipient().then((value) {
                Get.offAllNamed(Routes.dashboard);
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> restoreDeleteAccount() async {
    try {
      final res = await ApiProvider.restoreRecipient();
      isRequestDeleteAccount.value = res.isDeleted;
      Get.offAllNamed(Routes.dashboard);
      Get.snackbar('Restore Account', 'Restore account successful!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Something went wrong', 'Please try again later!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    Get.delete<DeleteAccountController>();
    super.dispose();
  }
}
