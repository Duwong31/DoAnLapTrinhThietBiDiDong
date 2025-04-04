import '../utilities/app_utils.dart';

extension StringExtension on String? {
  void toastMessage() {
    if (this != null) {
      AppUtils.toast(this!);
    }
  }
}
