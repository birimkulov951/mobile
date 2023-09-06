import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/auth_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/auth/exceptions/auth_exception.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_arguments.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/route/otp_confirmation_screen_route.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';

enum AuthStatus {
  idle,
  badCredentials(message: 'bad_credentials'),
  activationCodeSent(message: 'invalid_code_retry'),
  accessDenied(message: 'access_denied'),
  failed(message: 'unknown_error'),
  invalidToken(message: 'invalid_token'),
  success;

  final String? message;

  const AuthStatus({this.message});
}

mixin IAuthWidgetModelMixin on IWidgetModel {
  Future<void> fetchLoginOtp({String? passedPhoneNumber});

  Future<void> loginByOtp({
    required String phoneNumber,
    required String otpCode,
  });

  Future<void> refreshToken();

  abstract final AuthStatus authStatus;
}

mixin AuthWidgetModelMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends AuthModelMixin> on WidgetModel<W, M>
    implements IAuthWidgetModelMixin {
  @override
  AuthStatus authStatus = AuthStatus.idle;

  @override
  void onErrorHandle(Object error) {
    if (error is BadCredentialsException) {
      authStatus = AuthStatus.badCredentials;
    } else if (error is ActivationCodeSentException) {
      authStatus = AuthStatus.activationCodeSent;
    } else if (error is InvalidTokenException) {
      authStatus = AuthStatus.invalidToken;
    } else if (error is AccessDeniedException) {
      authStatus = AuthStatus.accessDenied;
    } else {
      authStatus = AuthStatus.failed;
    }
  }

  @override
  Future<void> fetchLoginOtp({String? passedPhoneNumber}) async {
    final phoneNumber = passedPhoneNumber ?? model.phoneNumber;
    await model.fetchLoginOtp(phoneNumber);
    if (authStatus == AuthStatus.activationCodeSent) {
      _toOtpConfirmationScreen(phoneNumber);
    } else if (authStatus == AuthStatus.accessDenied) {
      await showDialog(
        context: context,
        builder: (context) => showMessage(
          context,
          locale.getText('attention'),
          locale.getText('user_blocked'),
          onSuccess: () => Navigator.pop(context),
        ),
      );
      return;
    }
  }

  @override
  Future<void> loginByOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final authEntity = await model.loginByOtp(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
    );

    if (authEntity != null) {
      authStatus = AuthStatus.success;
    }
  }

  @override
  Future<void> refreshToken() async {
    final token = await model.refreshToken();

    if (token != null) {
      authStatus = AuthStatus.success;
    } else if (authStatus == AuthStatus.invalidToken) {
      await fetchLoginOtp();
    }
  }

  void _toOtpConfirmationScreen(String phoneNumber) {
    Navigator.pushNamed(
      context,
      OtpConfirmationScreenRoute.Tag,
      arguments: OtpConfirmationScreenArguments(
        phoneNumber: phoneNumber,
        isAuth: false,
      ),
    );
  }
}
