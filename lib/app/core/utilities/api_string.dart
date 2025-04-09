import 'package:dartz/dartz.dart';

class ApiUrl {
  factory ApiUrl() => _instance;
  ApiUrl._internal();
  static final ApiUrl _instance = ApiUrl._internal();
  static const String receipt = '/api';

  // Auth
  static const String login = '$receipt/login';
  static const String logout = '$receipt/logout';
  static const String register = '$receipt/auth/register';
  static const String verifyPhoneOtp = '$receipt/auth/verify-phone-otp';
  static const String sendOtp = '$receipt/auth/send-otp';
  static const String resendOtp = '$receipt/auth/resend-otp';
  static const String setPassword = '$receipt/auth/set-password';
  static const String forgotPassword = '$receipt/forgot-password';
  static const String resetPassword = '$receipt/reset-password';
  static const String changePassword = '$receipt/auth/change-password';

  static String detailRecipient(id) => '$receipt/recipients/$id';
  static String notifications = '$receipt/notifications';
  static String stores = '$receipt/stores';
  static String addresses = '$receipt/addresses';
  static String numberUnread = '$receipt/notifications/notifications_statistic';

  static detailNotify(String id) => '$receipt/notifications/$id';
  static enableNotify(id) => '$receipt/recipients/$id/enable_notification';
  static disableNotify(id) => '$receipt/recipients/$id/disable_notification';
  static updateAvatar(id) => '$receipt/recipients/$id/upload_avatar';
  static markRead() => '$receipt/notifications/$id/mark_as_read';

  static const String conversations = '$receipt/message_threads';
  static const String detailChat = '$receipt/messages/group_message';
  static const String createChat = '$receipt/message_threads';
  static const String sentMessage = '$receipt/messages/send_message';
  static String markReadAll(String id) =>
      '$receipt/message_threads/$id/mark_all_as_read';

  static const String refreshToken = '$receipt/refresh_token';

  //User
  static detailUser() => '$receipt/';
  static const String userRecipient = '$receipt/auth/me';
  static const String verifyInformation = '$receipt/kyc/submit';
  static const String uploadFile = '$receipt/media/store';
  static const String userBookingHistory= '$receipt/user/booking-history';
  static const String userCancelBooking = '$receipt/user/cancel-booking';
  static const String userWishlist = '$receipt/user/wishlist'; 

  //car
  static getListCar() => '$receipt/';
  static const String listCar = '$receipt/cars';
  static const String listReview = '$receipt/car/reviews';
  static const String wishlistCar = '$receipt/cars?is_wishlist=1';
  static const String createReview = '$receipt/car/write-review';
  static const String calculateFee = '$receipt/calculate-fee';
  static const String rerecommendedCar = '$receipt/cars?is_recommended=1';
  static const String carBrands = '$receipt/car-brands';
  static const String carLocation = '$receipt/car-locations';
  static const String carFilters = '$receipt/car/filters';

  static String carDetail(id) => '$receipt/car/detail/$id';

  //lifestyle
  // static getListLifeStyle() => '$receipt/';
  // static const String listLifeStyle = '$receipt/lifestyle';
  // static const String cateLifeStyle = '$receipt/lifestyle/category';

  // static String detailLifeStyle(id) => '$receipt/lifestyle/$id';

  //voucher
  static const String voucher = '$receipt/user/coupons';

  // //address
  // static const String addressByPosition = '$receipt/place/nearbysearch/json';
  // static const String addressBySearchText = '$receipt/place/autocomplete/json';
  // static const String positionFromAddress = '$receipt/place/details/json';
  // static const String addressFromLatLng = '$receipt/geocode/json';

  //booking
  static const String checkCarAvailability = '$receipt/car/check-availability';
  static const String addToCart = '$receipt/booking/addToCart';
  static const String doCheckout = '$receipt/booking/doCheckout';

  //feedback
  // static const String addFeedback = '$receipt/feedback';

  //delete/restore account
  static deleteRecipient(id) => '$receipt/recipients/$id';
  static const String restoreRecipient = '$receipt/recipients/restore';
  static const String getDashboard = '$receipt/home';
}
