import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/domain/payment/payment_result.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/payment/model/payment.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_from_card/select_from_card_wm.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/route/arguments.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/fast_payment_failed/route/fast_payment_failed_route.dart';
import 'package:mobile_ultra/screens/main/payments/v2/payment_verification_widget.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/exceptions/otp_exception.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/analytics_utils.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';

import 'package:ui_kit/ui_kit.dart' as uikit;
import 'package:sprintf/sprintf.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/currency_input_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/currency_input_bottom_sheet_model.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/exceptions/could_not_make_paynet_exception.dart';
import 'package:mobile_ultra/screens/main/payments/fast_payments/v2/currency_input_bottom_sheet/exceptions/phone_number_not_found_exception.dart';

abstract class ICurrencyInputBottomSheetWidgetModel extends IWidgetModel
    with ISelectFromCardMixin {
  abstract final uikit.AmountBigController amountBigController;
  abstract final FocusNode amountBigFocusNode;
  abstract final String phoneNumber;
  abstract final GlobalKey<FormState> formKey;
  abstract final StateNotifier<bool> buttonAvalableState;
  abstract final StateNotifier<bool> isLoading;

  double get bottomPadding;

  String? validator(String? value);

  void pay();
}

const _maxPayAmount = 1500000;
const _minPayAmount = 500;
const _paynetCellularMerchantId = 7449;

class CurrencyInputBottomSheetWidgetModel
    extends WidgetModel<CurrencyInputBottomSheet, CurrencyInputBottomSheetModel>
    with SelectFromCardMixin<CurrencyInputBottomSheet, CurrencyInputBottomSheetModel>
    implements ICurrencyInputBottomSheetWidgetModel {
  CurrencyInputBottomSheetWidgetModel(CurrencyInputBottomSheetModel model)
      : super(model);

  @override
  late final uikit.AmountBigController amountBigController =
      uikit.AmountBigController(
    symbol: ' ${locale.getText('sum')}',
    focusNode: amountBigFocusNode,
    hintText: '${_minPayAmount} – ${AmountFormatter.formatNum(_maxPayAmount)}',
  );
  @override
  late final String phoneNumber = widget.arguments.phoneNumber;

  @override
  final FocusNode amountBigFocusNode = FocusNode();

  String get phoneNumberShort =>
      widget.arguments.phoneNumber.replaceAll(' ', '').replaceAll('+998', '');

  @override
  final StateNotifier<bool> buttonAvalableState =
      StateNotifier<bool>(initValue: false);

  @override
  final StateNotifier<bool> isLoading = StateNotifier<bool>(initValue: false);

  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  double get bottomPadding {
    final screenBottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomPadding = screenBottomPadding == 0 ? 16 : screenBottomPadding;
    return bottomPadding + MediaQuery.of(context).viewInsets.bottom;
  }

  @override
  void initWidgetModel() {
    super.initWidgetModel();

    amountBigController.addListener(_checkButtonAvailable);
    selectFromCardState.addListener(_validateManually);
  }

  @override
  void dispose() {
    amountBigController.dispose();
    buttonAvalableState.dispose();
    isLoading.dispose();
    amountBigFocusNode.dispose();
    super.dispose();
  }

  @override
  void pay() async {
    if (isLoading.value == true) {
      return;
    }
    isLoading.accept(true);
    try {
      final amount = int.parse(amountBigController.text.replaceAll(' ', ''));
      final result = await model.topUpPhoneNumber(
          amount: amount,
          phoneNumber: phoneNumberShort,
          card: selectFromCardState.value!);

      switch (result.status) {
        case PaymentResultStatus.success:
          isLoading.accept(false);
          _trackAnalyticsEvent();
          Navigator.of(context).pop(true);
          break;
        case PaymentResultStatus.otp:
          OtpException error = result.error as OtpException;
          final Payment? payment = await _toOtpScreen(error.id);
          isLoading.accept(false);
          if (payment != null) {
            _trackAnalyticsEvent();
            Navigator.of(context).pop(true);
          }
          break;
        case PaymentResultStatus.failed:
          isLoading.accept(false);
          final error = result.error;
          if (error is CouldNotMakePaymentException) {
            _toErrorScreen();
          } else if (error is PhoneNumberNotFoundException) {
            _toPhoneNotFoundScreen();
          }
          else {
            await showDialog(
              context: context,
              builder: (BuildContext context) => showMessage(
                context,
                locale.getText('error'),
                locale.getText('something_went_wrong'),
                onSuccess: () => Navigator.pop(context),
              ),
            );
          }
          break;
      }
    } on Object catch (_) {
      isLoading.accept(false);
    }
  }

  @override
  String? validator(String? text) {
    if (text == null) {
      return null;
    }

    text = text.replaceAll(' ', '');

    if (text.isEmpty) {
      return null;
    }
    String? error;
    error = _validateMaxValue(text) ?? error;
    error = _validateCardBalance(text) ?? error;
    return error;
  }

  String? _validateMaxValue(String text) {
    final value = double.tryParse(text);
    if (value != null && value > _maxPayAmount) {
      return sprintf(locale.getText('you_cannot_pay_more_than'),
          [AmountFormatter.formatNum(_maxPayAmount)]);
    }
    return null;
  }

  String? _validateMinValue(String text) {
    final value = double.tryParse(text);
    if (value == null || value < _minPayAmount) {
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

  void _validateManually() {
    formKey.currentState?.validate();
    _checkButtonAvailable();
  }

  void _checkButtonAvailable() {
    String? error;
    final text = amountBigController.value.text.replaceAll(' ', '');
    error = validator(text) ?? error;
    error = _validateMinValue(text) ?? error;
    error = _validateCardBalance(text) ?? error;
    final isValid = error == null && selectFromCardState.value != null;
    buttonAvalableState.accept(isValid);
  }

  Future<Payment?> _toOtpScreen(int billId) async {
    final card = selectFromCardState.value!;
    return await Navigator.push<Payment>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentVerificationWidget(
            id: billId,
            card: card,
            onResendPressed: () async {
              final result = await model.payBill(
                billId: billId,
                token: card.token!,
                cardType: card.type!,
              );
              Navigator.of(context).pop(result);
            }),
      ),
    );
  }

  void _toErrorScreen() {
    Navigator.of(context).pushNamed(
      FastPaymentFailedRoute.Tag,
      arguments: FastPaymentFailedScreenArguments(
        errorHeadline: locale.getText('payment_failed'),
        errorText: locale.getText('try_again_later'),
      ),
    );
  }

  void _toPhoneNotFoundScreen() {
    Navigator.of(context).pushNamed(
      FastPaymentFailedRoute.Tag,
      arguments: FastPaymentFailedScreenArguments(
        errorHeadline: locale.getText('no_such_phone_number'),
        errorText: locale.getText('recheck_phone_number'),
      ),
    );
  }

  void _trackAnalyticsEvent() {
    AnalyticsInteractor.instance.paymentTracker.trackSuccess(
      source: getTransferSourceTypesByInt(selectFromCardState.value?.type),
      merchantId: _paynetCellularMerchantId,
      amount: int.parse(amountBigController.text.replaceAll(' ', '')),
      isFastPay: widget.arguments.isFastPay,
    );
  }
}

CurrencyInputBottomSheetWidgetModel currencyInputBottomSheetWidgetModelFactory(
        BuildContext context) =>
    CurrencyInputBottomSheetWidgetModel(CurrencyInputBottomSheetModel(
      merchantRepository: inject(),
      paymentRepository: inject(),
    ));
