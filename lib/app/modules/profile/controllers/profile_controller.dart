import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/utilities.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/repositories.dart';
import '../../../data/services/firebase_analytics_service.dart';
import '../../../routes/app_pages.dart';
import '../delete_account/delete_account_binding.dart';
import '../delete_account/delete_account_view.dart';

class ProfileController extends GetxController with ScrollMixin {
  final user = Rxn<UserModel>();
  @override
  void onInit() {
    super.onInit();
    // Khởi tạo mock data ở đây thay vì trong initState của View
    _initializeMockData();
    // Hoặc gọi hàm fetch dữ liệu thật nếu bạn muốn
    // getUserDetail();
  }
   // Hàm helper để khởi tạo mock data (hoặc dữ liệu thật)
  void _initializeMockData() {
     user.value = UserModel(
        fullName: "John Doe",
        dateOfBirth: DateTime.parse("1990-01-01"),
        email: "johndoe@example.com",
        phone: "123456789",
        gender: "Male");
     // Có thể gọi update() nếu cần thiết, nhưng gán trực tiếp thường đủ
     // update();
  }
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
  
  // **Logout Confirmation Dialog**
  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Đăng xuất',
      middleText: 'Bạn có chắc chắn muốn đăng xuất?',
      textCancel: 'Hủy',
      textConfirm: 'Đăng xuất',
      confirmTextColor: Colors.white,
      onConfirm: () {
        logout(); 
      },
      buttonColor: AppTheme.primary,
      cancelTextColor: Colors.black,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    final token = Preferences.getString(StringUtils.token);
    if (token == null || token.isEmpty) {
      Get.snackbar("Lỗi", "Bạn chưa đăng nhập!");
      return;
    }

    try {
      var dio = Dio();
      var response = await dio.post(
        'https://soundflow.click/api/auth/logout',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
  
      if (response.statusCode == 200) {
        // Clear session storage
        await GetStorage().erase();

        // Always remove the authentication tokens
        await Preferences.remove(StringUtils.token);
        await Preferences.remove(StringUtils.refreshToken);
        await Preferences.remove(StringUtils.currentId);

        if (!rememberMe) {
          // If "Remember Me" is not enabled, clear all preferences
          await Preferences.clear();
        } else {
          // If "Remember Me" is enabled, keep the remember me setting
          // but remove other session data
          await prefs.setBool('rememberMe', true);
        }

        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      // On error, still attempt to clear local data
      await GetStorage().erase();

      // Always remove auth tokens even on error
      await Preferences.remove(StringUtils.token);
      await Preferences.remove(StringUtils.refreshToken);
      await Preferences.remove(StringUtils.currentId);

      if (!rememberMe) {
        await Preferences.clear();
      }

      Get.offAllNamed(Routes.login);
    }
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
