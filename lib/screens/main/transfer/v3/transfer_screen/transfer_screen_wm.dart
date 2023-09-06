import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_commission_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_from_card/select_from_card_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_to_card/select_to_card_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/exceptions/bank_not_supported_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/transfer_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/transfer_screen_model.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uikit;
import 'package:sprintf/sprintf.dart';

const _maxTransferAmount = 10000000;
const _minTransferAmount = 1000;

abstract class ITransferScreenWidgetModel extends IWidgetModel
    with
        IRemoteConfigWidgetModelMixin,
        ISelectFromCardMixin,
        ISelectToCardMixin {
  abstract final String title;
  abstract final StateNotifier<bool> isLoadingState;
  abstract final StateNotifier<bool> isButtonEnabledState;
  abstract final bool isSelfTransfer;
  abstract final StateNotifier<double> commission;
  abstract final StateNotifier<double> commissionAmount;
  abstract final uikit.AmountBigControllerV2 amountBigController;
  abstract final FocusNode amountBigFocusNode;
  abstract final GlobalKey<FormState> formKey;

  String? validator(String? value);

  void getCommissions();

  void swapSenderWithReceiver();

  void pay();

  String? warningText(CardStatus? cardStatus);
}

class TransferScreenWidgetModel
    extends WidgetModel<TransferScreen, TransferScreenModel>
    with
        RemoteConfigWidgetModelMixin<TransferScreen, TransferScreenModel>,
        SelectFromCardMixin<TransferScreen, TransferScreenModel>,
        SelectToCardMixin<TransferScreen, TransferScreenModel>,
        TransferWidgetModelMixin<TransferScreen, TransferScreenModel>
    implements ITransferScreenWidgetModel {
  TransferScreenWidgetModel(super.model);

  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  final StateNotifier<double> commissionAmount = StateNotifier(initValue: 0);

  @override
  late final uikit.AmountBigControllerV2 amountBigController =
      uikit.AmountBigControllerV2(
    symbol: ' ${locale.getText('sum')}',
    focusNode: amountBigFocusNode,
    includeSymbolInHint: false,
    hintText:
        ' ${AmountFormatter.formatNum(_minTransferAmount)} - ${AmountFormatter.formatNum(_maxTransferAmount)}',
  );

  @override
  final FocusNode amountBigFocusNode = FocusNode();

  @override
  String get title {
    return locale.getText(
        widget.arguments.transferWay is TransferWayByOwnCardEntity
            ? 'self_transfer'
            : 'transfer_to_card');
  }

  @override
  bool get isSelfTransfer =>
      widget.arguments.transferWay is TransferWayByOwnCardEntity;

  int get cardType {
    final transferWay = widget.arguments.transferWay;

    if (transferWay is TransferWayByOwnCardEntity) {
      return selectToCardState.value!.type!;
    }
    return transferWay.cardType;
  }

  @override
  final StateNotifier<bool> isButtonEnabledState =
      StateNotifier(initValue: false);

  @override
  final StateNotifier<bool> isLoadingState = StateNotifier(initValue: false);

  @override
  final StateNotifier<double> commission = StateNotifier(initValue: 0);

  List<TransferCommissionEntity> _commissions = [];

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    getCommissions();
    amountBigController.addListener(() {
      _calculateCommission();
      _checkButtonAvailable();
    });
    selectFromCardState.addListener(() {
      _checkCommissionByCardTypes();
      _calculateCommission();
      _validateManually();
    });
    selectToCardState.addListener(() {
      _checkCommissionByCardTypes();
      _calculateCommission();
      _validateManually();
    });
    final transferWay = widget.arguments.transferWay;
    if (transferWay is TransferWayByOwnCardEntity) {
      selectToCardState.accept(transferWay.ownCard);
    }
  }

  @override
  void onErrorHandle(Object error) async {
    super.onErrorHandle(error);
    if (error is BankNotSupportedException) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => showMessage(
          context,
          locale.getText('error'),
          error.title,
          onSuccess: () => Navigator.pop(context),
        ),
      );
    }
  }

  @override
  Future<void> restoreSavedCard() async {
    final storedCard = await getStoredCard();
    if (storedCard?.type == Const.BONUS) {
      return;
    }
    selectFromCardState.accept(storedCard);
  }

  @override
  void getCommissions() async {
    _commissions = await model.getCommissions();
    _checkCommissionByCardTypes();
  }

  @override
  void swapSenderWithReceiver() {
    final tempCardHolder = selectFromCardState.value;
    selectFromCardState.accept(selectToCardState.value);
    selectToCardState.accept(tempCardHolder);
  }

  @override
  String? validator(String? value) {
    if (value == null) {
      return null;
    }
    value = value.replaceAll(' ', '');
    if (value.isEmpty) {
      return null;
    }
    if (isSelfTransfer &&
        selectFromCardState.value?.id == selectToCardState.value?.id) {
      return locale.getText('cannot_pay_to_same_card');
    }

    String? error;
    error = _validateCardBalance(value) ?? error;
    error = _validateMaxValue(value) ?? error;

    return error;
  }

  @override
  void pay() async {
    isLoadingState.accept(true);
    isButtonEnabledState.accept(false);

    try {
      final amount = int.parse(amountBigController.text.replaceAll(' ', ''));
      final commissionPercent = commission.value ?? 0;
      var transferWay = widget.arguments.transferWay;
      final senderCard = selectFromCardState.value!;

      if (transferWay is TransferWayByOwnCardEntity) {
        transferWay = transferWay.copyWith(ownCard: selectToCardState.value!);
      } else if (transferWay is TransferWayBySavedTransfer) {
        final P2PInfoEntity? response = await model.getP2PInfoForSavedTransfer(
          previousTransferEntity: transferWay.previousTransfer,
          senderCardToken: senderCard.token!,
          senderCardType: senderCard.type!,
          receiverCardType: cardType,
          amount: amount,
        );
        transferWay = transferWay.copyWith(expDate: response!.exp);
      }

      final remoteConfig = await model.getRemoteConfig();
      final p2pMaxTransferAmountWithoutConfirmation =
          remoteConfig.p2pMaxTransferAmountWithoutConfirmation;
      if (p2pMaxTransferAmountWithoutConfirmation <= amount) {
        toConfirmationScreen(
          transferWay: transferWay,
          senderCard: senderCard,
          amount: amount,
          commissionPercent: commissionPercent,
        );
      } else {
        await confirmTransfer(
          transferWay: transferWay,
          senderCard: senderCard,
          amount: amount,
          commissionPercent: commissionPercent,
        );
      }
    } on Object catch (_) {
      toErrorScreen();
    }

    isLoadingState.accept(false);
    _checkButtonAvailable();
  }

  String? _validateMaxValue(String text) {
    final value = double.tryParse(text);
    if (value != null && value > _maxTransferAmount) {
      return sprintf(locale.getText('you_cannot_transfer_more_than'),
          [AmountFormatter.formatNum(_maxTransferAmount)]);
    }
    return null;
  }

  String? _validateMinValue(String text) {
    final value = double.tryParse(text);
    if (value == null || value < _minTransferAmount) {
      return '';
    }
    return null;
  }

  String? _validateCardBalance(String text) {
    final value = double.tryParse(text);
    final card = selectFromCardState.value;

    if (value != null && card != null && card.balance != null) {
      if (card.balance! < value) {
        return locale.getText('insufficient_funds');
      }
    }
    return null;
  }

  void _checkButtonAvailable() {
    String? error;
    final text = amountBigController.value.text.replaceAll(' ', '');
    error = validator(text) ?? error;
    error = _validateMinValue(text) ?? error;
    error = _validateCardBalance(text) ?? error;
    final isValid = error == null && _isFromCardValid && _isToCardValid;
    if (widget.arguments.transferWay is TransferWayByOwnCardEntity &&
        selectToCardState.value == null) {
      isButtonEnabledState.accept(false);
      return;
    }
    isButtonEnabledState.accept(isValid);
  }

  bool get _isFromCardValid {
    return selectFromCardState.value != null &&
        selectFromCardState.value!.status == CardStatus.VALID;
  }

  bool get _isToCardValid {
    if (widget.arguments.transferWay is TransferWayByOwnCardEntity) {
      return selectToCardState.value != null &&
          selectToCardState.value!.status == CardStatus.VALID;
    }
    return true;
  }

  void _validateManually() {
    formKey.currentState?.validate();
    _checkButtonAvailable();
  }

  void _calculateCommission() {
    if (amountBigController.text.isEmpty) {
      commissionAmount.accept(0);
    } else {
      final _commission =
          int.parse(amountBigController.text.replaceAll(' ', '')) *
              commission.value! /
              100;
      commissionAmount.accept(_commission);
    }
  }

  void _checkCommissionByCardTypes() {
    late final TransferCommissionEntity? commissionEntity;
    final transferWay = widget.arguments.transferWay;
    if (transferWay is TransferWayByOwnCardEntity) {
      commissionEntity = _commissions.firstWhereOrNull((element) {
        return element.senderCardType == selectFromCardState.value?.type &&
            element.receiverCardType == selectToCardState.value?.type;
      });
    }

    if (transferWay is TransferWayByP2PInfoEntity) {
      commissionEntity = _commissions.firstWhereOrNull((element) {
        return element.senderCardType == selectFromCardState.value?.type &&
            element.receiverCardType == transferWay.p2pInfo.receiverCardType;
      });
    }
    if (transferWay is TransferWayBySavedTransfer) {
      commissionEntity = _commissions.firstWhereOrNull((element) {
        return element.senderCardType == selectFromCardState.value?.type &&
            element.receiverCardType == transferWay.previousTransfer.type;
      });
    }
    if (transferWay is TransferWayByBankCard) {
      commissionEntity = _commissions.firstWhereOrNull((element) {
        return element.senderCardType == selectFromCardState.value?.type &&
            element.receiverCardType == transferWay.bankCard.cardType;
      });
    }

    if (commissionEntity != null) {
      commission.accept(commissionEntity.commission);
    }
  }

  @override
  String? warningText(CardStatus? cardStatus) {
    if (cardStatus == CardStatus.VALID) {
      return null;
    }
    if (cardStatus == CardStatus.UZCARD_DISABLED) {
      return locale.getText('uzcard_unavailable');
    }
    if (cardStatus == CardStatus.HUMO_DISABLED) {
      return locale.getText('humo_unavailable');
    }
    return locale.getText('bank_blocked_card');
  }
}

TransferScreenWidgetModel transferScreenWidgetModelFactory(_) =>
    TransferScreenWidgetModel(TransferScreenModel(
      remoteConfigRepository: inject(),
      transferRepository: inject(),
    ));
