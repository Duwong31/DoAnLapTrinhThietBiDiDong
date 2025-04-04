class ApiUrl {
  factory ApiUrl() => _instance;
  ApiUrl._internal();
  static final ApiUrl _instance = ApiUrl._internal();
  static const String receipt = '/api';
  static const String sendOpt = '$receipt/send_otp';
  static const String login = '$receipt/login';
  static const String logout = '$receipt/logout';

  static String detailRecipient(id) => '$receipt/recipients/$id';
  static String notifications = '$receipt/notifications';
  static String stores = '$receipt/stores';
  static String addresses = '$receipt/addresses';
  static String numberUnread = '$receipt/notifications/notifications_statistic';

  static detailNotify(String id) => '$receipt/notifications/$id';
  static enableNotify(id) => '$receipt/recipients/$id/enable_notification';
  static disableNotify(id) => '$receipt/recipients/$id/disable_notification';
  static updateAvatar(id) => '$receipt/recipients/$id/upload_avatar';
  static markRead(id) => '$receipt/notifications/$id/mark_as_read';

  static const String conversations = '$receipt/message_threads';
  static const String detailChat = '$receipt/messages/group_message';
  static const String createChat = '$receipt/message_threads';
  static const String sentMessage = '$receipt/messages/send_message';
  static String markReadAll(String id) =>
      '$receipt/message_threads/$id/mark_all_as_read';

  static const String refreshToken = '$receipt/refresh_token';

  //delete/restore account
  static deleteRecipient(id) => '$receipt/recipients/$id';
  static const String restoreRecipient = '$receipt/recipients/restore';
  static const String getDashboard = '$receipt/home';
}
