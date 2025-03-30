import 'package:dartz/dartz.dart';
import 'package:soundflow/core/usecase/usecase.dart';
import 'package:soundflow/data/models/auth/login_user_req.dart';
import 'package:soundflow/domain/repositories/auth/auth.dart';
import 'package:soundflow/service_locator.dart';

class LoginUseCase implements UseCase<Either, LoginUserReq> {
  
  @override
  Future<Either> call({LoginUserReq ? params}) async{
    return sl<AuthRepository>().login(params!);
  }
}