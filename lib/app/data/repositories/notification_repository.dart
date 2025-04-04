part of 'repositories.dart';

abstract class NotificationBase {
  Future<ReposeData> getList({Map<String, dynamic>? query});
  Future<NotificationModel> detailNotify(String id);
  Future<bool> deleteNotify(String id);
  Future<bool> markRead(String id);
  Future<int> numberUnread();
}

class NotificationRepository implements NotificationBase {
  @override
  Future<ReposeData> getList({Map<String, dynamic>? query}) {
    return ApiProvider.getNotifications(query: query);
  }

  @override
  Future<bool> markRead(String id) {
    return ApiProvider.markRead(id);
  }

  @override
  Future<NotificationModel> detailNotify(String id) {
    return ApiProvider.detailNotify(id);
  }

  @override
  Future<int> numberUnread() {
    return ApiProvider.numberUnread();
  }

  @override
  Future<bool> deleteNotify(String id) {
    return ApiProvider.deleteNotify(id);
  }
}
