import 'package:flutter/material.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/verification_finished_data.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/payment_verification.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';
import 'package:mobile_ultra/utils/u.dart';

class TransferVerify extends StatefulWidget {
  final int id;
  final AttachedCard card;

  const TransferVerify({required this.id, required this.card});

  @override
  State<StatefulWidget> createState() => TransferVerifyState();
}

class TransferVerifyState extends BaseSMSConfirmLayout<TransferVerify>
    with PaymentVerificationView {
  @override
  String get title => locale.getText('confirm_sms_code');

  @override
  String get subtitle => locale.getText('otp_sent_to');

  @override
  String get subtitleSpan => formatStarsPhone(widget.card.phone);

  @override
  void onPressResetOtp() {
    super.onPressResetOtp();
    AnalyticsInteractor.instance.transfersOutTracker.trackOtpResend();
  }

  @override
  void onPayVerifyError(String error, errorBody) {
    _trackOtpEntered(VerificationResults.fail);
    onError(
      error,
      errorBody,
    );
  }

  @override
  void onPayVerifySuccess(dynamic result) {
    _trackOtpEntered(VerificationResults.success);
    Navigator.pop(context, result);
  }

  @override
  void onConfirmOTP({String? otp}) {
    Future.delayed(Duration(milliseconds: 250), () {
      onLoad();

      Map<String, dynamic> requestData = {
        'otp': otp,
        'id': widget.id,
      };
      PaymentVerificationPresenter.verifyP2P(this).verify(requestData);
    });
  }

  void onError(String error, dynamic errorBody) {
    onLoadEnd();

    String message = error;

    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final errResp = RequestError.fromJson(errorBody);

      if (errResp.status == 400 && errResp.detail == 'invalid_code_retry')
        message = locale.getText(
            errResp.left == '0' ? 'entry_count_limit_exceeded' : 'wrong_code');
    }

    onFail(message, errorBody: errorBody);
  }

  void _trackOtpEntered(VerificationResults resul) {
    AnalyticsInteractor.instance.transfersOutTracker.trackOtpEntered(
      result: resul,
    );
  }
}
