import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
    if (Preferences.isAuth()) {
      debugPrint(">>> [ProfileController.onInit] User is authenticated, calling getUserDetail...");
      getUserDetail();
    } else {
      debugPrint(">>> [ProfileController.onInit] User is not authenticated.");
      // user.value = null;
    }
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
    debugPrint(">>> [ProfileController] Bắt đầu gọi Repo.user.getDetail()");
    user.value = await Repo.user.getDetail();
    // debugPrint(">>> [ProfileController] Gọi Repo.user.getDetail() thành công. User: ${user.value?.toJson()}"); 

    if (isLogin) {
      FirebaseAnalyticService.logEvent('Login');
    }
    } catch (e, stack) { // Thêm stack trace để debug dễ hơn
      debugPrint(">>> [ProfileController] LỖI trong getUserDetail: $e\nStack: $stack");
      FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Failed in getUserDetail');

      // --- THAY ĐỔI QUAN TRỌNG ---
      // KHÔNG XÓA PREFERENCES Ở ĐÂY
      // Preferences.clear(); // <<--- XÓA HOẶC COMMENT DÒNG NÀY

      // Chỉ hiển thị thông báo lỗi
      AppUtils.toast("Không thể tải thông tin người dùng: ${e.toString()}");

      // Cân nhắc: Nếu lỗi nghiêm trọng (vd: token hết hạn), có thể gọi hàm logout() ở đây
      // if (e is DioError && e.response?.statusCode == 401) {
      //    debugPrint(">>> [ProfileController] Lỗi 401, tiến hành đăng xuất...");
      //    await logout();
      // }
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
    Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false); // Show loading indicator

    final token = Preferences.getString(StringUtils.token);
    // Không cần kiểm tra token ở đây nữa vì nếu vào được profile thì thường là có token

    try {
      // Gọi API logout (nếu có và cần thiết)
      if (token != null && token.isNotEmpty) {
         debugPrint(">>> [ProfileController.logout] Gọi API logout...");
         var dio = Dio();
         await dio.post(
           'https://soundflow.click/api/auth/logout', // Thay bằng URL đúng
           options: Options(headers: {'Authorization': 'Bearer $token'}),
         ).timeout(Duration(seconds: 10)); // Thêm timeout
          debugPrint(">>> [ProfileController.logout] Gọi API logout thành công (hoặc không quan trọng kết quả).");
      } else {
         debugPrint(">>> [ProfileController.logout] Không có token để gọi API logout.");
      }

    } catch (e) {
       debugPrint(">>> [ProfileController.logout] Lỗi khi gọi API logout (không nghiêm trọng, tiếp tục xóa local): $e");
       // Không cần dừng lại nếu API lỗi, cứ tiếp tục xóa local data
    } finally {
       // Luôn xóa dữ liệu local quan trọng
       debugPrint(">>> [ProfileController.logout] Bắt đầu xóa dữ liệu local...");
       await GetStorage().erase();
       await Preferences.remove(StringUtils.token);
       await Preferences.remove(StringUtils.refreshToken);
       await Preferences.remove(StringUtils.currentId);
       await Preferences.remove(StringUtils.email); // Xóa cả email đã lưu nếu có
       // Không cần clear() toàn bộ trừ khi đó là yêu cầu
       // await Preferences.clear();
       debugPrint(">>> [ProfileController.logout] Đã xóa dữ liệu local.");

       if (Get.isDialogOpen ?? false) {
         Get.back(); // Close loading dialog
       }
       Get.offAllNamed(Routes.login); // Điều hướng về login
       debugPrint(">>> [ProfileController.logout] Đã điều hướng về trang Login.");
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
