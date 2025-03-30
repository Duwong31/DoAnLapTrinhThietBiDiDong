import 'package:dartz/dartz.dart';
import 'package:soundflow/core/usecase/usecase.dart';
import 'package:soundflow/data/models/auth/create_user_req.dart';
import 'package:soundflow/domain/repositories/auth/auth.dart';
import 'package:soundflow/service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  
  @override
  Future<Either> call({CreateUserReq ? params}) async{
    return sl<AuthRepository>().signup(params!);
  }
}