import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/auth_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_model.dart';

class PhoneNumberLoginModel extends ElementaryModel with AuthModelMixin {
  PhoneNumberLoginModel(AuthRepository authRepository) {
    this.authRepository = authRepository;
  }
}
