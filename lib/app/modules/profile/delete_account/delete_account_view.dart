import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/loading.dart';
import 'delete_account_controller.dart';

class DeleteAccountView extends GetView<DeleteAccountController> {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: AppTheme.appBar,
        title: 'Managing your account'.text.make(),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: Get.back,
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(
              () => controller.isLoading.value
                  ? const Loading()
                  : SingleChildScrollView(
                      child: controller.isRequestDeleteAccount.value
                          ? AppButton('RESTORE YOUR ACCOUNT DELETION',
                              type: ButtonType.normal,
                              onPressed: controller.restoreDeleteAccount)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                'Delete Account'
                                    .text
                                    .size(20)
                                    .medium
                                    .maxLines(1)
                                    .color(AppTheme.primary)
                                    .make()
                                    .centered(),
                                'Are you sure you want to delete your account? Deleting your account is permanent and will delete all your data forever. You have 30 days to restore your account!'
                                    .text
                                    .size(14)
                                    .make()
                                    .centered()
                                    .pSymmetric(v: 20),
                                AppButton('CONTINUE DELETE YOUR ACCOUNT',
                                    type: ButtonType.normal,
                                    onPressed: controller.deleteYourAccount),
                              ],
                            ),
                    ),
            )),
      ),
    );
  }
}
