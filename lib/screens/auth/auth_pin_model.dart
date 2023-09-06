import 'package:elementary/elementary.dart';
import 'package:mobile_ultra/repositories/auth_repository.dart';
import 'package:mobile_ultra/repositories/onboarding_repository.dart';
import 'package:mobile_ultra/repositories/settings_repository.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_model.dart';

class AuthPinModel extends ElementaryModel with AuthModelMixin {
  AuthPinModel(
    AuthRepository authRepository,
    TokenRepository tokenRepository,
    this._settingsRepository,
    this._onboardingRepository,
  ) {
    this.authRepository = authRepository;
    this.tokenRepository = tokenRepository;
  }

  final SettingsRepository _settingsRepository;
  final OnboardingRepository _onboardingRepository;

  bool get isBiometricsEnabled => _settingsRepository.isBiometricsEnabled();

  bool get isQuickPayOnboardingDisplayed =>
      _onboardingRepository.isQuickPayOnboardingDisplayed;

  bool get isOnboardingDisplayed => _onboardingRepository.isOnboardingDisplayed;
}
