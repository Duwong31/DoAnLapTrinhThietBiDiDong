import '../../styles/style.dart';
import 'validator.dart';

class ValidatorUtils {
  factory ValidatorUtils() => _instance;
  ValidatorUtils._internal();
  static final ValidatorUtils _instance = ValidatorUtils._internal();

  static String? Function(String?) passwordValidator({
    void Function(String error)? onError,
    TextEditingController? passwordConfirm,
    String? empty,
    String? confirmPass,
  }) {
    if (passwordConfirm != null) {
      return Validator.validateAll([
        NotEmpty('Required'),
        ConfirmPasswordValidator(
          passwordConfirm,
          'Password does not match',
        )
      ]);
    }
    return Validator.validateAll([NotEmpty('Required')]);
  }
}
