import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/net/card/humo_presenter.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/uzcard_presenter.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

/// СМС подтверждение добавления новой карты, в случае необходимости её активации
/// params: [0] - card token, [1] - phone

class CardSMSConfirmWidget extends StatefulWidget {
  static const Tag = '/cardSMSConfirm';

  final AttachedCard? card;
  final VoidCallback? onResendCode;

  const CardSMSConfirmWidget({
    this.card,
    this.onResendCode,
  });

  @override
  State<StatefulWidget> createState() => CardSMSConfirmWidgetState();
}

class CardSMSConfirmWidgetState
    extends BaseSMSConfirmLayout<CardSMSConfirmWidget> {
  @override
  String get title => locale.getText('confirm_sms_code');

  @override
  String get subtitle => locale.getText('otp_sent_to');

  @override
  String get subtitleSpan => formatStarsPhone(widget.card?.phone ?? '');

  @override
  void onConfirmOTP({String? otp}) {
    Future.delayed(const Duration(milliseconds: 250), () {
      onLoad();
      if (widget.card?.type == Const.HUMO) {
        HumoPresenter.cardVerification(widget.card?.token, otp,
            onError: onError,
            onSuccess: (_) => onConfirmAddingCardResult(isSuccess: true));
      } else {
        UzcardPresenter.cardVerification(widget.card?.token ?? '', otp ?? '',
            onError: onError,
            onSuccess: (_) => onConfirmAddingCardResult(isSuccess: true));
      }
    });
  }

  Future<void> onConfirmAddingCardResult({bool? isSuccess}) async {

    Navigator.pop(
      context,
      isSuccess,
    );
  }

  @override
  void onRequestOTP() {
    super.onRequestOTP();
    if (widget.onResendCode != null) {
      widget.onResendCode!();
    }
  }

  void onError(String error, {dynamic errorBody}) {
    onLoadEnd();
    String message = error;

    if (errorBody != null && errorBody is Map<String, dynamic>) {
      final errResp = RequestError.fromJson(errorBody);
      if (errResp.status == 400 && errResp.detail == 'invalid_code_retry') {
        message = locale.getText(
            errResp.left == '0' ? 'entry_count_limit_exceeded' : 'wrong_code');
      } else {
        onConfirmAddingCardResult(isSuccess: false);
      }
    }

    onFail(message, errorBody: errorBody);
  }

  void onCardVerified() {
    onLoadEnd();
    Navigator.pop(context, true);
  }
}
