import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/payment_verification.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

enum PaymentVerificationType {
  abroad,
  inner,
}

class PaymentVerificationWidget extends StatefulWidget {
  final int? id;
  final AttachedCard? card;
  final VoidCallback? onResendPressed;
  final PaymentVerificationType verificationType;

  const PaymentVerificationWidget({
    this.id,
    this.card,
    this.onResendPressed,
    this.verificationType = PaymentVerificationType.inner,
  });

  @override
  State<StatefulWidget> createState() => PaymentVerificationWidgetState();
}

class PaymentVerificationWidgetState
    extends BaseSMSConfirmLayout<PaymentVerificationWidget>
    with PaymentVerificationView {
  @override
  String get title => locale.getText('confirm_sms_code');

  @override
  String get subtitle => locale.getText('otp_sent_to');

  @override
  String get subtitleSpan => formatStarsPhone(widget.card?.phone ?? '');

  bool get _isInner => widget.verificationType == PaymentVerificationType.inner;

  bool get _isAbroad =>
      widget.verificationType == PaymentVerificationType.abroad;

  @override
  void onPayVerifyError(String error, errorBody) {
    if (_isInner) {
      AnalyticsInteractor.instance.paymentTracker.trackOtpEntered(
        result: VerificationResults.fail,
      );
    } else if (_isAbroad) {
      AnalyticsInteractor.instance.abroadTracker.trackOtpEntered(
        result: VerificationResults.fail,
      );
    }

    onError(
      error,
      errorBody,
    );
  }

  @override
  void onPayVerifySuccess(dynamic result) {
    if (_isInner) {
      AnalyticsInteractor.instance.paymentTracker.trackOtpEntered(
        result: VerificationResults.success,
      );
    } else if (_isAbroad) {
      AnalyticsInteractor.instance.abroadTracker.trackOtpEntered(
        result: VerificationResults.success,
      );
    }
    Navigator.pop(context, result);
  }

  @override
  void onConfirmOTP({String? otp}) {
    Future.delayed(Duration(milliseconds: 250), () {
      onLoad();

      Map<String, dynamic> requestData = {
        'otp': otp,
        'billId': widget.id,
        'token': widget.card?.token
      };

      if (widget.card?.type == Const.HUMO) {
        PaymentVerificationPresenter.verifyHumo(this).verify(requestData);
      } else {
        PaymentVerificationPresenter.verifyUzcard(this).verify(requestData);
      }
    });
  }

  void onError(String error, dynamic errorBody) {
    onLoadEnd();

    String message = error;

    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final errResp = RequestError.fromJson(errorBody);

      if (errResp.status == 400 && errResp.detail == 'invalid_code_retry') {
        message = locale.getText(
            errResp.left == '0' ? 'entry_count_limit_exceeded' : 'wrong_code');
      }
    }

    onFail(message, errorBody: errorBody);
  }

  @override
  void onPressResetOtp() {
    super.onPressResetOtp();
    if (_isInner) {
      AnalyticsInteractor.instance.paymentTracker.trackOtpResend();
    } else if (_isAbroad) {
      AnalyticsInteractor.instance.abroadTracker.trackOtpResend();
    }
    if (widget.onResendPressed != null) {
      widget.onResendPressed!();
    }
  }
}
