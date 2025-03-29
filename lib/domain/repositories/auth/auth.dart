import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository{
  Future<void> signup();
  Future<void> login();
  Future<UserCredential> loginWithGoogle();
}