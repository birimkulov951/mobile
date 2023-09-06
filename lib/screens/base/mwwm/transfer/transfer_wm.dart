import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/data/mappers/transfer_mapper.dart';
import 'package:mobile_ultra/domain/transfer/transfer_result.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_pay.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_model.dart';
import 'package:mobile_ultra/screens/main/navigation.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/transfer_result.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/transfer_verfy.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/route/transfer_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_result_screens/transfer_error_screen.dart';

mixin TransferWidgetModelMixin<W extends ElementaryWidget,
    M extends TransferMixin> on WidgetModel<W, M> {
  Future<void> confirmTransfer({
    required TransferWayEntity transferWay,
    required AttachedCard senderCard,
    required int amount,
    double? commissionPercent,
    bool canBeAddedToFavorites = false,
  }) async {
    final response = await model.makeP2PTransfer(
      senderCardToken: senderCard.token!,
      senderCardType: senderCard.type!,
      receiverCardToken: transferWay.cardId,
      fio: transferWay.cardName,
      exp: transferWay.expDate,
      receiverCardType: transferWay.cardType,
      receiverMethodType: transferWay.checkCardType,
      amount: amount,
      receiverBankName: transferWay.receiverBankName,
    );

    switch (response.status) {
      case TransferResultStatus.success:
        toSuccessScreen(
          p2pPayment: response.p2pResult!.toP2Pay(),
          senderCard: senderCard,
          transferWay: transferWay,
          canBeAddedToFavorites: canBeAddedToFavorites,
        );
        break;
      case TransferResultStatus.otp:
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferVerify(
              id: (response.error as OtpException).id,
              card: senderCard,
            ),
          ),
        );
        if (result is P2Pay) {
          toSuccessScreen(
            p2pPayment: result,
            senderCard: senderCard,
            transferWay: transferWay,
            canBeAddedToFavorites: canBeAddedToFavorites,
          );
        }
        break;
      case TransferResultStatus.failed:
        toErrorScreen();
        break;
    }
  }

  void toSuccessScreen({
    required P2Pay p2pPayment,
    required TransferWayEntity transferWay,
    required AttachedCard senderCard,
    bool canBeAddedToFavorites = false,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransferResultWidget(
          p2pay: p2pPayment,
          cardType: senderCard.type,
          destinationType: transferWay.destinationType,
          commissionAmount:
              int.parse(p2pPayment.commission.toString()).toDouble(),
          isOther: transferWay is! TransferWayByOwnCardEntity,
          receiverFio: transferWay.cardName,
          canBeAddedToFavorites: canBeAddedToFavorites,
        ),
      ),
    ).then((_) => toHomeScreen());
  }

  void toErrorScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => TransferErrorScreen(
        onPressButton: toHomeScreen,
        errorSvgIcon: Assets.fail,
        buttonText: locale.getText('good'),
        headerText: locale.getText('transfer_failed'),
        bodyText: locale.getText('try_transfer_again_later'),
      ),
    ));
  }

  void toHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      NavigationWidget.Tag,
      (Route<dynamic> route) => false,
    );
  }

  void toConfirmationScreen({
    required TransferWayEntity transferWay,
    required AttachedCard senderCard,
    required int amount,
    required double commissionPercent,
  }) {
    Navigator.of(context).pushNamed(
      TransferConfirmationScreenRoute.Tag,
      arguments: TransferConfirmationScreenArguments(
        senderCard: senderCard,
        transferWay: transferWay,
        amount: amount,
        commissionPercent: commissionPercent,
      ),
    );
  }
}
