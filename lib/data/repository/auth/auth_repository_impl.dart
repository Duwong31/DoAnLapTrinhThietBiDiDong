import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soundflow/data/models/auth/create_user_req.dart';
import 'package:soundflow/data/models/auth/login_user_req.dart';
import 'package:soundflow/data/sources/auth/auth_firebase_service.dart';
import 'package:soundflow/domain/repositories/auth/auth.dart';
import 'package:soundflow/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  
  @override
  Future<Either> login(LoginUserReq loginUserReq) async{
    return await sl<AuthFirebaseService>().login(loginUserReq);
  }
  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<UserCredential> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }
}