import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../data/models/models.dart';
import '../../widgets/widgets.dart';
import '../styles/style.dart';

class AppUtils {
  factory AppUtils() {
    return _instance;
  }

  AppUtils._internal();

  static final AppUtils _instance = AppUtils._internal();
  static const String tag = 'App';

  static void log(dynamic msg, {String tag = tag}) {
    if (kDebugMode) {
      developer.log('$msg', name: tag);
    }
  }

  static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.95),
      textColor: Colors.white,
    );
  }

  static String timeFormat(int? time,
      {bool day = false, String format = 'dd MMM yyyy'}) {
    if (time != null) {
      return DateFormat(day ? 'EEE, MM/dd/yyyy hh:mm a' : format).format(
        DateTime.fromMillisecondsSinceEpoch(time),
      );
    }
    return '-';
  }

  static String dateFormat(int? time,
      {bool day = false, String format = 'dd MMM yyyy'}) {
    if (time != null) {
      return DateFormat(day ? 'EEE, MM/dd/yyyy' : format).format(
        DateTime.fromMillisecondsSinceEpoch(time),
      );
    }
    return '-';
  }

  static String birthDay(int? time) {
    if (time != null) {
      return DateFormat(' MM/dd/yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(time),
      );
    }
    return '-';
  }

  static String dateHours(int? time) {
    if (time != null) {
      return DateFormat('EEEE, hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(time),
      );
    }
    return '-';
  }

  static String formatDateChat(int? time) {
    if (time != null) {
      final now = DateTime.now().millisecondsSinceEpoch - time;
      if (DateTime.fromMillisecondsSinceEpoch(now).day > 1) {
        return DateFormat('MM/dd/yyyy').format(time.toDate);
      }
      return time.toDate.timeAgo();
    }
    return '-';
  }

  static void pickerImage({required Function(Uint8List) onTap}) async {
    Get.bottomSheet(BottomPicker(onTap: (val) {
      ImagePicker().pickImage(source: val, maxWidth: 720).then((res) {
        if (res != null) {
          AppUtils.cropPicker(res.path).then((value) {
            if (value != null) {
              value.readAsBytes().then(
                (bitesData) {
                  onTap.call(bitesData);
                },
              );
            }
          });
        }
      });
    }));
  }

  static Color statusColor(String? status) {
    switch (status) {
      case 'Ready To Pickup':
        return const Color(0xffC556F8);
      case 'In Delivery':
      case 'Out For Delivery':
        return const Color(0xffCA8E03);
      case 'Delivered':
      case 'Completed':
        return const Color(0xff00AB97);
      case 'Failed':
      case 'Delete':
        return const Color(0xffEF3900);
      case 'Unread':
        return const Color(0xff000000);
      default:
        return const Color(0xff008DFF);
    }
  }

  static String getInitials(String name) {
    final List<String> nameSplit = name.split(" ");
    if (nameSplit.length == 1) {
      return nameSplit[0][0];
    }
    final String firstNameInitial = nameSplit[0][0];
    final String lastNameInitial = nameSplit[1][0];
    return (firstNameInitial + lastNameInitial).toUpperCase();
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.offline;

      case 1:
        return UserState.online;

      default:
        return UserState.waiting;
    }
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.offline:
        return 0;

      case UserState.online:
        return 1;

      default:
        return 2;
    }
  }

  static Future<CroppedFile?> cropPicker(String pickerData) async {
    return await ImageCropper().cropImage(
        sourcePath: pickerData,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 720,
        maxWidth: 720,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop image',
          ),
          IOSUiSettings(
            doneButtonTitle: "Done",
            cancelButtonTitle: "Cancel",
          ),
        ]);
  }

  static String kDiscountCode = 'Bundle_otc_app';

  static String kBundleNameTag = 'bundle-name-tag:';
  static String kBundleKitCollectionTag = 'bundle-kit-collection';
  static String kOverTheCounterMedicationsInOrderTag =
      'over-the-counter-medications-in-order';
}
