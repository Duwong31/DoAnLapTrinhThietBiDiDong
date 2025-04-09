part of 'models.dart';

enum NotificationType {
  car,
  genericNotification
}

extension RawNotificationType on NotificationType {
  String rawValue() {
    switch (this) {
      case NotificationType.car:
        return "car";
      default:
        return "GenericNotification";
    }
  }
}

extension StringToEnum on String {
  NotificationType toNotificationType() {
    switch (this) {
      case "car":
        return NotificationType.car;
      default:
        return NotificationType.genericNotification;
    }
  }
}
