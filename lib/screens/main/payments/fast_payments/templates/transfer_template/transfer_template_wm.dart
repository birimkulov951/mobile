import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/common/p2p_check_type.dart';
import 'package:mobile_ultra/domain/favorite/favorite.dart';
import 'package:mobile_ultra/domain/transfer/template_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_destination_type.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/transfer/model/commission_transfer.dart';
import 'package:mobile_ultra/net/transfer/model/p2p_check.dart';
import 'package:mobile_ultra/net/transfer/p2p_presenter.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/transfer/transfer_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/route/transfer_template_arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/sheet/template_edit_sheet.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/sheet/template_edit_sheet_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/templates/transfer_template/transfer_template_model.dart';
import 'package:mobile_ultra/screens/main/transfer/v2/all_cards.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:sprintf/sprintf.dart';

enum ButtonStatus {
  clickable,
  unclickable,
  loading,
}

abstract class ITransferTemplateWidgetModel extends IWidgetModel
    with IRemoteConfigWidgetModelMixin {
  abstract final TextEditingController commentController;
  abstract final TextEditingController amountController;

  abstract final FocusNode commentFocus;
  abstract final FocusNode amountFocus;

  abstract final StateNotifier<String> titleState;
  abstract final StateNotifier<bool> isCommentClearIconShownState;
  abstract final StateNotifier<bool> isAmountClearIconShownState;

  abstract final String? error;

  abstract final StateNotifier<ButtonStatus> isVisibleButtonState;

  abstract final EntityStateNotifier<AttachedCard?> currentCard;

  abstract final StateNotifier<String> commissionTextState;

  double get bottomPadding;

  void onCommentClear();

  void onAmountClear();

  void onCommentChanged(String value);

  void onAmountChanged(String value);

  void onCommentSubmitted(String? value);

  void onCheckAndGotoConfirmTransfer();

  void onCardChange(AttachedCard? card);

  void onCardSelect();

  void onScaffoldTap();

  void onSettingsTap();
}

class TransferTemplateWidgetModel
    extends WidgetModel<TransferTemplate, TransferTemplateModel>
    with
        RemoteConfigWidgetModelMixin<TransferTemplate, TransferTemplateModel>,
        TransferWidgetModelMixin<TransferTemplate, TransferTemplateModel>
    implements ITransferTemplateWidgetModel {
  TransferTemplateWidgetModel(super.model);

  late final TransferTemplateRouteArguments arguments;

  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _commentFocus = FocusNode();
  final FocusNode _amountFocus = FocusNode();

  String? _error;

  List<CommissionTransfer> commissionList = [
    CommissionTransfer(sender: 4, receiver: 4, commission: .1),
    CommissionTransfer(sender: 1, receiver: 4, commission: .5),
    CommissionTransfer(sender: 4, receiver: 1, commission: .5),
    CommissionTransfer(sender: 1, receiver: 1, commission: .5),
    CommissionTransfer(sender: 5, receiver: 5, commission: .0),
    CommissionTransfer(sender: 1, receiver: 5, commission: .0),
    CommissionTransfer(sender: 4, receiver: 5, commission: .0),
    CommissionTransfer(sender: 5, receiver: 1, commission: 1),
    CommissionTransfer(sender: 5, receiver: 4, commission: 1),
  ];

  double? commissionAmount;

  @override
  TextEditingController get amountController => _amountController;

  @override
  TextEditingController get commentController => _commentController;

  @override
  FocusNode get commentFocus => _commentFocus;

  @override
  FocusNode get amountFocus => _amountFocus;

  @override
  StateNotifier<String> titleState = StateNotifier();

  @override
  final StateNotifier<bool> isCommentClearIconShownState =
      StateNotifier(initValue: false);

  @override
  final StateNotifier<bool> isAmountClearIconShownState =
      StateNotifier(initValue: false);

  @override
  double get bottomPadding {
    final screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return screenBottomPadding == 0 ? 16 : screenBottomPadding;
  }

  @override
  final StateNotifier<ButtonStatus> isVisibleButtonState =
      StateNotifier(initValue: ButtonStatus.clickable);

  @override
  final StateNotifier<String> commissionTextState =
      StateNotifier(initValue: locale.getText('no_commission'));

  @override
  String? get error => _error;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    arguments = widget.arguments;
    titleState.accept(favoriteTemplateName(arguments.template));

    final _currentCard = homeData?.cards.firstWhereOrNull(
      (card) => card.token == arguments.template.transferData?.id1,
    );

    if (_currentCard != null) {
      currentCard.content(_currentCard);
    }

    if (arguments.template.isTransfer &&
        arguments.template.transferData!.amount != null) {
      final amount = arguments.template.transferData!.amount!;
      final formatted = AmountFormatter.formatNumWithCurrency(amount ~/ 100);
      amountController.text = formatted;
    }

    _amountFocus.addListener(_amountFocusListener);

    _calculateCommission();
    _updateButtonState();
    _commissionGet();
  }

  @override
  void dispose() {
    _amountFocus.removeListener(_amountFocusListener);
    _commentController.dispose();
    _amountController.dispose();
    _commentFocus.dispose();
    _amountFocus.dispose();
    isCommentClearIconShownState.dispose();
    isAmountClearIconShownState.dispose();
    isVisibleButtonState.dispose();
    commissionTextState.dispose();
    super.dispose();
  }

  @override
  void onCommentClear() {
    FocusScope.of(context).unfocus();
    commentController.clear();
    isCommentClearIconShownState.accept(commentController.text.isNotEmpty);
  }

  @override
  void onAmountClear() {
    FocusScope.of(context).unfocus();
    amountController.clear();
    isAmountClearIconShownState
        .accept(amountController.text.isNotEmpty && amountFocus.hasFocus);
    _calculateCommission();
    _updateButtonState();
  }

  @override
  void onCommentChanged(String value) {
    isCommentClearIconShownState.accept(commentController.text.isNotEmpty);
  }

  @override
  void onAmountChanged(String value) {
    isAmountClearIconShownState
        .accept(amountController.text.isNotEmpty && amountFocus.hasFocus);
    _calculateCommission();
    _updateButtonState();
  }

  @override
  final EntityStateNotifier<AttachedCard?> currentCard =
      EntityStateNotifier<AttachedCard?>();

  @override
  void onCardChange(AttachedCard? card) => _onCardSelection(card: card);

  @override
  void onCardSelect() => _onCardSelection();

  @override
  void onCheckAndGotoConfirmTransfer() => _p2pCheck();

  @override
  void onCommentSubmitted(String? value) => amountFocus.requestFocus();

  @override
  void onScaffoldTap() {
    final currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void onSettingsTap() async {
    FocusScope.of(context).unfocus();

    final TemplateEditSheetResult? result = await viewModalSheet(
      context: context,
      child: TemplateEditSheet(
        template: widget.arguments.template,
        title: titleState.value!,
      ),
    );

    if (result != null) {
      if (result.status == TemplateEditSheetResultStatus.changed) {
        titleState.accept(result.changedName);
      } else if (result.status == TemplateEditSheetResultStatus.removed) {
        Navigator.pop(context);
      }
    }
  }

  void _onCardSelection({AttachedCard? card}) async {
    final result = await viewModalSheet(
      context: context,
      backgroundColor: ColorNode.Background,
      compact: true,
      child: AllCardsForTransfer(
        card: card,
      ),
    );

    if (result != null) {
      currentCard.content(result);
      _calculateCommission();
      _updateButtonState();
    }
  }

  void _updateButtonState() {
    if (amountController.text.isNotEmpty) {
      final amount = int.parse(
        amountController.text
            .replaceAll(locale.getText('sum'), '')
            .replaceAll(' ', ''),
      );

      final balance = currentCard.value?.data?.balance ?? 0;

      if (amount <= 0) {
        isVisibleButtonState.accept(ButtonStatus.unclickable);
      } else if (amount > balance) {
        _error = locale.getText('insufficient_funds');
        isVisibleButtonState.accept(ButtonStatus.unclickable);
      } else {
        _error = null;
        isVisibleButtonState.accept(ButtonStatus.clickable);
      }
    } else {
      _error = null;
      isVisibleButtonState.accept(ButtonStatus.unclickable);
    }
  }

  void _calculateCommission() {
    final commissionItem = commissionList.firstWhereOrNull(
      (item) =>
          item.sender == currentCard.value?.data?.type &&
          item.receiver == arguments.template.transferData?.receiverCardType,
    );

    final double _commissionChange =
        commissionItem == null ? .5 : commissionItem.commission ?? 0;

    final amount = amountController.text.isEmpty
        ? .0
        : double.parse(
            amountController.text
                .replaceAll(locale.getText('sum'), '')
                .replaceAll(' ', ''),
          );

    commissionAmount = (amount * _commissionChange) / 100;

    commissionTextState.accept(sprintf(
      locale.getText('commission_f'),
      [
        _commissionChange,
        formatAmount(commissionAmount!),
      ],
    ));
  }

  TransferData get transferData => arguments.template.bill as TransferData;

  void _p2pCheck() {
    isVisibleButtonState.accept(ButtonStatus.loading);

    final Map<String, dynamic> request = {};

    final selectedCard = currentCard.value?.data;
    final amount = int.parse(
      amountController.text
          .replaceAll(locale.getText('sum'), '')
          .replaceAll(' ', ''),
    );

    request["id"] = transferData.id2;
    request["type"] = transferData.p2pCheckType.value;
    request["senderCardType"] = transferData.senderCardType;
    request["receiverCardType"] = transferData.receiverCardType;
    request["senderToken"] = selectedCard?.token;
    request["amount"] = amount;
    request.removeWhere((key, value) => value == null);

    /// todo(Akyl) refactor according to Elementary
    /// Refactoring to Elementary may cause OTP bug.
    final P2Presenter p2pCheck;
    if (transferData.p2pCheckType == P2PCheckType.phone) {
      request["bankName"] = transferData.receiverBankName;
      request["fullName"] = transferData.fio;
      request["maskedPan"] = transferData.pan2;
      request["exp"] = transferData.exp;
      request["cardType"] = transferData.receiverCardType;
      p2pCheck = P2Presenter.checkByPhoneNumber(
        onGetError: onError,
        onP2PCheckResult: onP2PCheckResult,
      );
    } else if (transferData.p2pCheckType == P2PCheckType.cardToken) {
      p2pCheck = P2Presenter.checkToken(
        onGetError: onError,
        onP2PCheckResult: onP2PCheckResult,
      );
    } else if (transferData.p2pCheckType == P2PCheckType.pan &&
        transferData.receiverCardType == Const.HUMO) {
      p2pCheck = P2Presenter.checkHumo(
        onGetError: onError,
        onP2PCheckResult: onP2PCheckResult,
      );
    } else {
      p2pCheck = P2Presenter.check(
        onGetError: onError,
        onP2PCheckResult: onP2PCheckResult,
      );
    }
    p2pCheck.execute(request);
  }

  Future onError(String error, {dynamic errorBody}) async {
    isVisibleButtonState.accept(ButtonStatus.clickable);

    return await showDialog(
      context: context,
      builder: (BuildContext context) => showMessage(
        context,
        locale.getText('error'),
        error,
        onSuccess: () => Navigator.pop(context),
      ),
    );
  }

  void onP2PCheckResult(dynamic result) async {
    final p2pCheckResult = P2PCheck.fromJson(result);

    final amount = int.parse(
      amountController.text
          .replaceAll(locale.getText('sum'), '')
          .replaceAll(' ', ''),
    );

    if (p2pCheckResult.min != null && p2pCheckResult.min! > amount) {
      _error = sprintf(
        locale.getText('min_amount_error'),
        [formatAmount(p2pCheckResult.min)],
      );
      isVisibleButtonState.accept(ButtonStatus.unclickable);
      commissionTextState.accept(null);
      return;
    }

    if (p2pCheckResult.max != null && p2pCheckResult.max! <= amount) {
      _error = sprintf(
        locale.getText('max_amount_error'),
        [formatAmount(p2pCheckResult.max)],
      );
      isVisibleButtonState.accept(ButtonStatus.unclickable);
      commissionTextState.accept(null);
      return;
    }

    isVisibleButtonState.accept(ButtonStatus.clickable);

    var destinationType = TransferDestinationType.cardExternal;
    if (p2pCheckResult.byToken != null) {
      destinationType = TransferDestinationType.cardLinked;
    }
    AnalyticsInteractor.instance.transfersOutTracker.trackDestinationSelected(
      destinationType: destinationType,
    );

    final senderCard = currentCard.value!.data;

    final TransferWayEntity transferWay = TransferWayEntity.fromTemplate(
      TemplateEntity(
        id1: transferData.id1!,
        id2: transferData.id2!,
        pan1: transferData.pan1!,
        pan2: transferData.pan2!,
        type1: transferData.type1!,
        type2: transferData.type2!,
        amount: transferData.amount!,
        fio: transferData.fio!,
        exp: transferData.exp!,
        senderCardType: transferData.senderCardType!,
        receiverCardType: transferData.receiverCardType!,
        p2pCheckType: transferData.p2pCheckType,
        receiverBankName: transferData.receiverBankName,
      ),
    );

    final remoteConfig = await model.getRemoteConfig();
    final p2pMaxTransferAmountWithoutConfirmation =
        remoteConfig.p2pMaxTransferAmountWithoutConfirmation;

    if (p2pMaxTransferAmountWithoutConfirmation <= amount) {
      toConfirmationScreen(
        transferWay: transferWay,
        senderCard: senderCard!,
        amount: amount,
        commissionPercent: commissionAmount ?? 0,
      );
    } else {
      await confirmTransfer(
        transferWay: transferWay,
        senderCard: senderCard!,
        amount: amount,
        commissionPercent: commissionAmount ?? 0,
        canBeAddedToFavorites: true,
      );
    }
  }

  void _amountFocusListener() => amountFocus.hasFocus
      ? isAmountClearIconShownState.accept(amountController.text.isNotEmpty)
      : isAmountClearIconShownState.accept(false);

  void _commissionGet() {
    P2Presenter.commissionGet(onCommissionResult: _onP2PCommissionResult)
        .makeCheck();
  }

  void _onP2PCommissionResult(List<CommissionTransfer> results) {
    if (results.isNotEmpty) {
      commissionList.clear();
      commissionList.addAll(results);
      _calculateCommission();
    }
  }
}

TransferTemplateWidgetModel transferTemplateWidgetModelFactory(_) =>
    TransferTemplateWidgetModel(
      TransferTemplateModel(
        remoteConfigRepository: inject(),
        transferRepository: inject(),
      ),
    );
