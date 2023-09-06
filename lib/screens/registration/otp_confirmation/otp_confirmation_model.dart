import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/auth_repository.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_model.dart';

class OtpConfirmationModel extends ElementaryModel with AuthModelMixin {
  OtpConfirmationModel(
    AuthRepository authRepository,
    TokenRepository tokenRepository,
  ) {
    this.authRepository = authRepository;
    this.tokenRepository = tokenRepository;
  }
}
