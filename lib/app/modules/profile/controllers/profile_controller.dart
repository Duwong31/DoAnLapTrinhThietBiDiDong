import 'package:get/get.dart';

import '../../../core/utilities/utilities.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../delete_account/delete_account_binding.dart';
import '../delete_account/delete_account_view.dart';

class ProfileController extends GetxController with ScrollMixin {
  final user = Rxn<UserModel>();

  void changeAvatar() {
    FirebaseAnalyticService.logEvent('Profile_Edit_Avatar');
    AppUtils.pickerImage(onTap: (bytes) async {
      try {} catch (e) {
        AppUtils.toast(e.toString());
      }
    });
  }

  Future<ProfileController> getUserDetail({bool isLogin = false}) async {
    try {
      user.value = await Repo.user.getDetail();

      if (isLogin) {
        FirebaseAnalyticService.logEvent('Login');
      }
    } catch (e) {
      Preferences.clear();
      AppUtils.toast(e.toString());
    }
    return this;
  }

  void toggleNotify(bool newVal) async {
    user.update((val) => val?.isEnableNotification = newVal);
    try {
      await Repo.user.toggleNotify(newVal);
    } catch (e) {
      user.update((val) => val?.isEnableNotification = !newVal);
      AppUtils.toast(e.toString());
    }
  }

  void checkUpdateUser() async {
    await 2.delay();
  }

  updateAddress(int index, bool load) {
    user.update((val) {
      val?.address[index].loading = load;
    });
  }

  void gotoDeleteAccountView() {
    Get.back();
    Get.to(() => const DeleteAccountView(),
        arguments: {}, binding: DeleteAccountBinding());
  }

  @override
  Future<void> onEndScroll() async {}

  @override
  Future<void> onTopScroll() async {}
}
