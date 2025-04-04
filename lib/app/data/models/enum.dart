enum UserType { phone, email }

extension StringToEnum on String {
  OrderStatus toOrderStatus() {
    switch (toLowerCase()) {
      case "new":
        return OrderStatus.news;
      case "started":
        return OrderStatus.started;
      case "completed":
        return OrderStatus.completed;
      case "cancel":
        return OrderStatus.cancel;
      case "assigned":
        return OrderStatus.assigned;
      case "inprogress":
        return OrderStatus.inProgress;
      default:
        return OrderStatus.failed;
    }
  }
}

enum OrderStatus {
  news,
  started,
  completed,
  failed,
  cancel,
  assigned,
  inProgress
}

extension RawData on OrderStatus {
  String rawValue() {
    switch (this) {
      case OrderStatus.completed:
        return "Completed";
      case OrderStatus.failed:
        return "Failed";
      case OrderStatus.started:
        return "Started";
      case OrderStatus.cancel:
        return "Cancel";
      case OrderStatus.assigned:
        return "Assigned";
      case OrderStatus.inProgress:
        return "InProgress";
      default:
        return "New";
    }
  }
}
