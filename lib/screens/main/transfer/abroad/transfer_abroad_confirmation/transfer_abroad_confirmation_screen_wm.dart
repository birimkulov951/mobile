import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/domain/payment/payment_result.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_verification_widget.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/transfer_abroad_confirmation_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/transfer_abroad_confirmation_screen_model.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_result/route/transfer_abroad_result_screen_route.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/u.dart';

const _screenTimeOut = Duration(seconds: 60);

abstract class ITransferAbroadConfirmationScreenWidgetModel
    extends IWidgetModel {
  StateNotifier<bool> get isLoadingState;

  void makeTransfer({
    required int billId,
    required AttachedCard fromCard,
  });

  String get fromBankName;

  String get fromBankAmount;

  String get toBankName;

  String get toBankAmount;

  String get amount;

  String get payAmount;

  String get exchangeRate;

  bool get isExchangeRateChanged;

  AttachedCard get fromCard;

  AbroadTransferReceiverEntity get toCard;
}

class TransferAbroadConfirmationScreenWidgetModel extends WidgetModel<
        TransferAbroadConfirmationScreen, TransferAbroadConfirmationScreenModel>
    implements ITransferAbroadConfirmationScreenWidgetModel {
  TransferAbroadConfirmationScreenWidgetModel(
    TransferAbroadConfirmationScreenModel model,
    this._analyticsInteractor,
  ) : super(model);

  final AnalyticsInteractor _analyticsInteractor;

  late final _arguments = widget.arguments;

  late final StateNotifier<bool> _isLoading;
  late Timer _timer;
  late bool _isSessionExpired;

  @override
  StateNotifier<bool> get isLoadingState => _isLoading;

  @override
  AttachedCard get fromCard => widget.arguments.fromCard;

  @override
  AbroadTransferReceiverEntity get toCard => widget.arguments.receiverEntity;

  @override
  String get fromBankAmount =>
      '${formatAmount(fromCard.balance)} ${locale.getText('sum')}';

  @override
  String get fromBankName =>
      '${fromCard.name} • ${fromCard.number?.substring((fromCard.number?.length ?? 4) - 4)}';

  @override
  String get toBankAmount => formatCardNumber(toCard.pan);

  @override
  String get toBankName =>
      toCard.bankName ?? locale.getText('bank_card_kazakhstan');

  @override
  String get amount =>
      formatAmount(widget.arguments.rateEntity.amount.toDouble());

  @override
  String get payAmount => formatAmount(widget.arguments.rateEntity.payAmount);

  @override
  String get exchangeRate =>
      widget.arguments.rateEntity.rate.toStringAsFixed(3);

  @override
  bool get isExchangeRateChanged => widget.arguments.isExchangeRateChanged;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _isSessionExpired = false;
    _isLoading = StateNotifier<bool>(initValue: false);
    _timer = Timer(_screenTimeOut, () {
      _isSessionExpired = true;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  void makeTransfer({
    required int billId,
    required AttachedCard fromCard,
  }) async {
    _timer.cancel();

    _isLoading.accept(true);

    if (_isSessionExpired) {
      _toResultScreen(status: TransferAbroadResultStatus.timeOut);
      return;
    }

    final result = await model.makeTransfer(
      billId: billId,
      token: fromCard.token!,
      cardType: fromCard.type!,
    );
    _isLoading.accept(false);
    switch (result.status) {
      case PaymentResultStatus.success:
        _analyticsInteractor.abroadTracker.trackConfirmed(
          destination: _arguments.receiverEntity.bankName,
          source: getTransferSourceTypesByInt(_arguments.fromCard.type),
          amount: _arguments.amount,
        );

        _toResultScreen(
          status: TransferAbroadResultStatus.success,
          payment: result.payment,
        );
        break;
      case PaymentResultStatus.otp:
        OtpException error = result.error as OtpException;
        final Payment? payment = await _toOtpScreen(error.id);

        if (payment != null) {
          _toResultScreen(
            status: TransferAbroadResultStatus.success,
            payment: payment,
          );
        } else {
          _toResultScreen(
            status: TransferAbroadResultStatus.fail,
          );
        }
        break;
      case PaymentResultStatus.failed:
        _toResultScreen(status: TransferAbroadResultStatus.fail);
        break;
    }
  }

  void _toResultScreen({
    required TransferAbroadResultStatus status,
    Payment? payment,
  }) {
    _isLoading.accept(false);
    final arguments = widget.arguments;
    Navigator.pushNamed(
      context,
      TransferAbroadResultScreenRoute.Tag,
      arguments: TransferAbroadResultScreenArguments(
        resultStatus: status,
        amount: arguments.amount,
        transferCountryEntity: arguments.transferCountryEntity,
        receiverEntity: arguments.receiverEntity,
        isExchangeRateChanged: arguments.isExchangeRateChanged,
        rateEntity: arguments.rateEntity,
        fromCard: arguments.fromCard,
        payment: payment,
      ),
    );
  }

  Future<Payment?> _toOtpScreen(int billId) async {
    return await Navigator.push<Payment>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentVerificationWidget(
            id: billId,
            card: fromCard,
            onResendPressed: () async {
              final result = await model.makeTransfer(
                billId: billId,
                token: fromCard.token!,
                cardType: fromCard.type!,
              );
              Navigator.of(context).pop(result);
            }),
      ),
    );
  }
}

TransferAbroadConfirmationScreenWidgetModel
    transferConfirmationScreenWidgetModelFactory(_) =>
        TransferAbroadConfirmationScreenWidgetModel(
          TransferAbroadConfirmationScreenModel(
            inject(),
          ),
          inject(),
        );
