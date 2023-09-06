import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/transfer_confirmation_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_confirmation_screen/transfer_confirmation_screen_model.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class ITransferConfirmationScreenWidgetModel extends IWidgetModel {
  abstract final ValueNotifier<bool> isLoadingState;

  void pay();

  String getLastFour(String cardNUmber);

  String getCardLogoAsset(int cardType);
}

class TransferConfirmationScreenWidgetModel extends WidgetModel<
        TransferConfirmationScreen, TransferConfirmationScreenModel>
    with
        TransferWidgetModelMixin<TransferConfirmationScreen,
            TransferConfirmationScreenModel>
    implements
        ITransferConfirmationScreenWidgetModel {
  TransferConfirmationScreenWidgetModel(TransferConfirmationScreenModel model)
      : super(model);

  @override
  final ValueNotifier<bool> isLoadingState = ValueNotifier<bool>(false);

  @override
  void pay() async {
    isLoadingState.value = true;

    try {
      await confirmTransfer(
        transferWay: widget.arguments.transferWay,
        senderCard: widget.arguments.senderCard,
        amount: widget.arguments.amount,
        commissionPercent: widget.arguments.commissionPercent,
      );
    } on Object catch (_) {
      toErrorScreen();
    }

    isLoadingState.value = false;
  }

  @override
  String getLastFour(String cardNUmber) {
    return cardNUmber.substring(cardNUmber.length - 4, cardNUmber.length);
  }

  @override
  String getCardLogoAsset(int cardType) {
    if (cardType == 1) {
      return Assets.uzcardTextLogo;
    }
    return Assets.humoTextLogo;
  }
}

TransferConfirmationScreenWidgetModel wmFactory(_) =>
    TransferConfirmationScreenWidgetModel(
        TransferConfirmationScreenModel(transferRepository: inject()));
