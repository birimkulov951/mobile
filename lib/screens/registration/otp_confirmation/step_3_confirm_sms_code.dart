import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/auth/auth_interactor.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';
import 'package:mobile_ultra/screens/registration/otp_confirmation/otp_confirmation_wm.dart';
import 'package:mobile_ultra/screens/registration/step_4_pincode.dart';
import 'package:mobile_ultra/utils/u.dart';

class ConfirmSMSWidget extends StatefulWidget {
  final String phone;
  final IOtpConfirmationScreenWidgetModel wm;

  /// true - флоу авторизации
  /// false - флоу регистрации
  final bool isAuth;

  const ConfirmSMSWidget({
    required this.phone,
    required this.isAuth,
    required this.wm,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => ConfirmSMSWidgetState();
}

class ConfirmSMSWidgetState extends BaseSMSConfirmLayout<ConfirmSMSWidget> {
  @override
  String get title => locale.getText('confirm_sms_code');

  @override
  String get subtitle => locale.getText('otp_sent_to');

  @override
  String get subtitleSpan => formatStarsPhone(widget.phone);

  @override
  void onPressResetOtp() {
    super.onPressResetOtp();
    AnalyticsInteractor.instance.registrationTracker.trackOtpResent();
  }

  @override
  void onRequestOTP() {
    super.onRequestOTP();
    onConfirmOTP();
  }

  @override
  void onConfirmOTP({String? otp}) {
    if (otp == null) {
      widget.wm.reFetchLoginOtp();
    } else {
      onLoad();
      widget.wm.login(
        otpCode: otp,
        onLogin: onLogin,
      );
    }
  }

  void onLogin({
    String? errorMessage,
  }) {
    onLoadEnd();
    _trackOtp(errorMessage == null);

    if (errorMessage != null) {
      onFail(
        errorMessage,
        errorBody: errorMessage,
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PinCodeWidget(
          phone: widget.phone,
        ),
      ),
    );
  }

  void _trackOtp(bool isCorrectCode) {
    if (AuthInteractor.instance.isRegistration) {
      AnalyticsInteractor.instance.registrationTracker.trackOtpEntered(
        isPhoneRegistered: widget.isAuth,
        isCorrectCode: isCorrectCode,
      );
    } else {
      AnalyticsInteractor.instance.authTracker.trackOtpEntered();
    }
  }
}
