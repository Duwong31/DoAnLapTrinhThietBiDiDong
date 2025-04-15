import 'package:intl/intl.dart';

class TimeUtil {
  static final DateFormat formatterDay = DateFormat('yyyy-MM-dd');
  static final DateFormat formatterUs = DateFormat.yMMMEd();
  static final DateFormat formatDefault = DateFormat('yyyy-MM-dd hh:mm:ss');
  static final DateFormat formatHourMin = DateFormat('yyyy-MM-dd hh:mm');
  static final DateFormat formatOnlyHMmm = DateFormat('hh:mm a');
  static final DateFormat _dateTimeA = DateFormat('dd-MM-yyyy hh:mm a');
  static DateTime getCurrentDay() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static String convertToString(DateTime dateTime) {
    return formatterDay.format(dateTime);
  }

  static String convertToUsString(DateTime dateTime) {
    return formatterUs.format(dateTime);
  }

  static String convertToDefaultString(DateTime dateTime) {
    return formatDefault.format(dateTime);
  }

  static String convertToDateHourMin(DateTime dateTime) {
    return formatHourMin.format(dateTime);
  }

  static DateTime convertStringToDateTime(String date) {
    return DateTime.parse(date);
  }

  static String differentDay(DateTime a, DateTime b) {
    Duration diff = a.difference(b);
    if (diff.inDays > 365) {
      return "More 1 Years";
    } else if (diff.inDays > 1 && diff.inDays < 365) {
      return "in ${diff.inDays} days";
    } else if (diff.inDays < 1) {
      return "Today";
    } else {
      return "Some days";
    }
  }

  static String convertToUsWithHHmm(DateTime dateTime) {
    return "${formatterUs.format(dateTime)} ${formatOnlyHMmm.format(dateTime)} ";
  }

  static String convertToHHmm(DateTime dateTime) {
    return formatOnlyHMmm.format(dateTime);
  }

  static String convertDateTimeA(DateTime dateTime) {
    return _dateTimeA.format(dateTime);
  }
}
