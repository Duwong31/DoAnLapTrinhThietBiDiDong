import 'package:get_it/get_it.dart';
import 'package:soundflow/data/repository/auth/auth_repository_impl.dart';
import 'package:soundflow/data/sources/auth/auth_firebase_service.dart';
import 'package:soundflow/domain/repositories/auth/auth.dart';
import 'package:soundflow/domain/usecases/auth/login.dart';
import 'package:soundflow/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(),
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(),
  );
  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(),
  );
  sl.registerSingleton<LoginUseCase>(
    LoginUseCase(),
  );
}