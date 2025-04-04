part of 'repositories.dart';

abstract class AuthBase {
  Future<void> logout();
  Future<bool> sendEmailPassword(String email, String password);
}

class AuthRepository implements AuthBase {
  @override
  Future<bool> sendEmailPassword(String email, String password) {
    return ApiProvider.sendEmailPassword(email, password);
  }

  @override
  Future<void> logout() {
    return ApiProvider.logout();
  }
}
