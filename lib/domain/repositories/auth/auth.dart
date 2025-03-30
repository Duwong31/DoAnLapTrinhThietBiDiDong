import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soundflow/data/models/auth/create_user_req.dart';
import 'package:soundflow/data/models/auth/login_user_req.dart';

abstract class AuthRepository{
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> login(LoginUserReq loginUserReq);
  Future<UserCredential> loginWithGoogle();
}