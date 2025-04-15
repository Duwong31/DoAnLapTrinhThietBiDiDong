import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../widgets/bottom_picker.dart';
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
      backgroundColor: const Color(0xFF1E1E1E)..withAlpha((0.95 * 255).round()),
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

  // static UserState numToState(int number) {
  //   switch (number) {
  //     case 0:
  //       return UserState.offline;

  //     case 1:
  //       return UserState.online;

  //     default:
  //       return UserState.waiting;
  //   }
  // }

  // static int stateToNum(UserState userState) {
  //   switch (userState) {
  //     case UserState.offline:
  //       return 0;

  //     case UserState.online:
  //       return 1;

  //     default:
  //       return 2;
  //   }
  // }

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

  static String formatCurrency(String amount) {
    try {
      double value = double.parse(amount);
      final formatter = NumberFormat("#,###", "vi_VN");
      return formatter.format(value);
    } catch (e) {
      return amount;
    }
  }

  static String formatDate(String dateString, String pattern) {
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat(pattern).format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  static Map<String, String> vietnamZipCodes = {
    "An Giang": "880000",
    "Bà Rịa - Vũng Tàu": "790000",
    "Bắc Giang": "260000",
    "Bắc Kạn": "960000",
    "Bạc Liêu": "970000",
    "Bắc Ninh": "220000",
    "Bến Tre": "930000",
    "Bình Định": "820000",
    "Bình Dương": "750000",
    "Bình Phước": "670000",
    "Bình Thuận": "800000",
    "Cà Mau": "980000",
    "Cần Thơ": "900000",
    "Cao Bằng": "270000",
    "Đà Nẵng": "550000",
    "Đắk Lắk": "630000",
    "Đắk Nông": "640000",
    "Điện Biên": "380000",
    "Đồng Nai": "810000",
    "Đồng Tháp": "870000",
    "Gia Lai": "600000",
    "Hà Giang": "310000",
    "Hà Nam": "400000",
    "Hà Nội": "100000",
    "Hà Tĩnh": "480000",
    "Hải Dương": "170000",
    "Hải Phòng": "180000",
    "Hậu Giang": "910000",
    "Hòa Bình": "350000",
    "Hồ Chí Minh": "700000",
    "Hưng Yên": "160000",
    "Khánh Hòa": "650000",
    "Kiên Giang": "920000",
    "Kon Tum": "580000",
    "Lai Châu": "390000",
    "Lâm Đồng": "670000",
    "Lạng Sơn": "240000",
    "Lào Cai": "330000",
    "Long An": "850000",
    "Nam Định": "420000",
    "Nghệ An": "460000",
    "Ninh Bình": "430000",
    "Ninh Thuận": "660000",
    "Phú Thọ": "290000",
    "Phú Yên": "620000",
    "Quảng Bình": "470000",
    "Quảng Nam": "510000",
    "Quảng Ngãi": "520000",
    "Quảng Ninh": "200000",
    "Quảng Trị": "480000",
    "Sóc Trăng": "950000",
    "Sơn La": "360000",
    "Tây Ninh": "840000",
    "Thái Bình": "410000",
    "Thái Nguyên": "250000",
    "Thanh Hóa": "440000",
    "Thừa Thiên Huế": "530000",
    "Tiền Giang": "860000",
    "Trà Vinh": "940000",
    "Tuyên Quang": "300000",
    "Vĩnh Long": "890000",
    "Vĩnh Phúc": "280000",
    "Yên Bái": "320000"
  };

  static String kDiscountCode = 'Bundle_otc_app';
  static String kBundleNameTag = 'bundle-name-tag:';
  static String kBundleKitCollectionTag = 'bundle-kit-collection';
  static String kOverTheCounterMedicationsInOrderTag =
      'over-the-counter-medications-in-order';
}
