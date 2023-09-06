import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as UCard;
import 'package:mobile_ultra/net/card/humo_presenter.dart';
import 'package:mobile_ultra/net/card/uzcard_presenter.dart';
import 'package:mobile_ultra/net/request_error.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/screens/base/base_sms_confirm_layout.dart';

import 'package:mobile_ultra/screens/main/transfer/v2/new_card_transfer_result.dart';

/// СМС подтверждение добавления новой карты, в случае необходимости её активации
/// params: [0] - card token, [1] - phone

class TransferCardSMSConfirmWidget extends StatefulWidget {
  static const Tag = '/cardSMSConfirm';

  final UCard.AttachedCard card;

  TransferCardSMSConfirmWidget({
    required this.card,
  });

  @override
  State<StatefulWidget> createState() => TransferCardSMSConfirmWidgetState();
}

class TransferCardSMSConfirmWidgetState
    extends BaseSMSConfirmLayout<TransferCardSMSConfirmWidget> {
  @override
  String get title => locale.getText('confirm_sms_code');

  @override
  String get subtitle => locale.getText('otp_sent_to');

  @override
  String get subtitleSpan => formatStarsPhone(widget.card.phone);

  @override
  void onConfirmOTP({String? otp}) {
    Future.delayed(Duration(milliseconds: 250), () {
      onLoad();
      if (widget.card.type == Const.HUMO) {
        HumoPresenter.cardVerification(
          widget.card.token,
          otp,
          onError: onError,
          onSuccess: (card) => onConfirmAddingCardResult(
            isSuccess: true,
            card: card,
          ),
        );
      } else {
        UzcardPresenter.cardVerification(
          widget.card.token ?? '',
          otp ?? '',
          onError: onError,
          onSuccess: (card) => onConfirmAddingCardResult(
            isSuccess: true,
            card: card,
          ),
        );
      }
    });
  }

  Future<void> onConfirmAddingCardResult({
    bool? isSuccess,
    UCard.AttachedCard? card,
  }) async {
    if (card != null) {
      final indexOfCardToOverride = homeData?.cards.indexOf(card) ?? -1;
      if (indexOfCardToOverride != -1) {
        homeData?.cards[indexOfCardToOverride] = card;
      } else {
        homeData?.cards.add(card);
      }
    }

    Navigator.pop(
      context,
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewCardTransferResultPage(
            card: widget.card,
            isSuccess: isSuccess ?? false,
          ),
        ),
      ),
    );
  }

  void onError(String error, {dynamic errorBody}) {
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

  void onCardVerified() {
    onLoadEnd();
    Navigator.pop(context, true);
  }
}
