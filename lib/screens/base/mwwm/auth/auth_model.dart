import 'package:elementary/elementary.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_ultra/domain/auth/auth_entity.dart';
import 'package:mobile_ultra/domain/auth/register_entity.dart';
import 'package:mobile_ultra/domain/auth/token_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/auth/auth_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/repositories/auth_repository.dart';
import 'package:mobile_ultra/repositories/token_repository.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';

mixin AuthModelMixin on ElementaryModel {
  @protected
  late final AuthRepository authRepository;

  @protected
  late final TokenRepository tokenRepository;

  Future<void> fetchLoginOtp(String phoneNumber) async {
    try {
      final userExists = await authRepository.checkIfUserExists(phoneNumber);
      if (!userExists) {
        final registerEntity = RegisterEntity(
          login: phoneNumber,
          email: 'user@mail.ru',
          langKey:
              locale.prefix == LocaleHelper.English ? 'eng' : locale.prefix,
        );
        await authRepository.register(registerEntity);
        AuthInteractor.instance.isRegistration = true;
      } else {
        AuthInteractor.instance.isRegistration = false;
      }
      await authRepository.fetchLoginOtp(
        phoneNumber: phoneNumber,
        authType: AuthType.otpCreate,
      );
    } on Object catch (e) {
      handleError(e);
    }
  }

  Future<AuthEntity?> loginByOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final authEntity = await authRepository.loginByOtp(
        phoneNumber: phoneNumber,
        otpCode: otpCode,
        authType: AuthType.otp,
      );
      await _saveToken(authEntity);
      _setUserId(authEntity.userId);
      authRepository.savePhoneNumber(phoneNumber);
      return authEntity;
    } on Object catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<TokenEntity?> refreshToken() async {
    try {
      final token = tokenRepository.getToken();
      return await tokenRepository.refreshToken(token);
    } on Object catch (e) {
      handleError(e);
    }
    return null;
  }

  Future<void> _saveToken(AuthEntity authEntity) async {
    final token = TokenEntity(
      accessToken: authEntity.accessToken,
      refreshToken: authEntity.refreshToken,
      tokenType: authEntity.tokenType,
    );
    await tokenRepository.saveToken(token);
  }

  void _setUserId(String userId) {
    AnalyticsInteractor.instance.setUserId(userId);
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  String get phoneNumber => authRepository.phoneNumber;
}
