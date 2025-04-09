part of 'repositories.dart';

abstract class AuthBase {
  Future<void> logout();
  Future<dynamic> register( String email, String deviceName, bool term);
  Future<dynamic> verifyOtp(String userId, String otp, String deviceName);
   Future<String?> refreshToken();
  Future<dynamic> resendOtp(String phone);
  Future<dynamic> setPassword(String phone, String otp, String password,
      String passwordConfirmation, String userId, String deviceName);
  Future<dynamic> forgotPassword(String phone);
  Future<dynamic> resetPassword(
      String phone, String otp, String password, String passwordConfirmation);
  Future<dynamic> login(String phone, String password, String deviceName);
  Future<dynamic> changePassword(String currentPassword, String newPassword,
      String newPasswordConfirmation);
}

class AuthRepository extends BaseRepository implements AuthBase {
  @override
  Future<dynamic> register(String email, String deviceName, bool term) {
    return handleCall(() => ApiProvider.register(email, deviceName, term));
  }

  @override
  Future<dynamic> login(String email, String password, String deviceName) {
    return handleCall(() => ApiProvider.login(email, password, deviceName));
  }
  @override
  Future<void> logout() {
    return handleCall(() => ApiProvider.logout());
  }
   @override
  Future<dynamic> sendOtp(String phone) {
    return handleCall(() => ApiProvider.forgotPassword(phone));
  }

  @override
  Future<dynamic> verifyOtp(String userId, String otp, String deviceName) {
    return handleCall(() => ApiProvider.verify(userId, otp, deviceName));
  }

  @override
  Future<String?> refreshToken() {
    return handleCall(() => ApiProvider.refreshToken());
  }

  @override
  Future<dynamic> resendOtp(String phone) {
    return handleCall(() => ApiProvider.resendOtp(phone));
  }

  @override
  Future<dynamic> setPassword(String phone, String otp, String password,
      String passwordConfirmation, String userId, String deviceName) {
    return handleCall(() => ApiProvider.setPassword(phone, otp, password, passwordConfirmation, userId, deviceName));
  }

  @override
  Future<dynamic> forgotPassword(String phone) {
    return handleCall(() => ApiProvider.forgotPassword(phone));
  }

  @override
  Future<dynamic> resetPassword(
      String phone, String otp, String password, String passwordConfirmation) {
    return handleCall(() =>ApiProvider.resetPassword(phone, otp, password, passwordConfirmation));
  }

  @override
  Future<dynamic> changePassword(String currentPassword, String newPassword,
      String newPasswordConfirmation) {
    return handleCall(() => ApiProvider.changePassword(currentPassword, newPassword, newPasswordConfirmation));
  }
}
