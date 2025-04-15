class StringUtils {
  factory StringUtils() => _instance;

  StringUtils._internal();
  static final StringUtils _instance = StringUtils._internal();
  static const String googleKey = "xxx";
  static const String orderDelivered = 'ORDER_DELIVERED';
  static const String pickupStore = 'PICKUP_STARTED';
  static const String shipping = 'ORDER_DELIVERED';
  static const String token = 'app-token';
  static const String refreshToken = 'app-refreshToken';
  static const String currentId = 'app-current-uid';
  static const String versionApp = 'version_app';
  static const String phoneNumber = 'phone';
  static const String firebaseStoreKeyPrescriptions = 'prescriptions';
  static const String email = 'email';
}
