import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_rate_entity.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_from_card/select_from_card_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_confirmation/route/transfer_abroad_confirmation_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/helpers/conversion_helper.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/transfer_details_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/transfer_details_screen_model.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/widgets/text_field/amount/amount_manager.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_text_field.dart';
import 'package:sprintf/sprintf.dart';

abstract class ITransferDetailsScreenWidgetModel extends IWidgetModel
    with ISelectFromCardMixin {
  abstract final GlobalKey<PostfixTextFieldState> fromFieldKey;

  abstract final AmountFieldManager fromFieldManager;
  abstract final AmountFieldManager toFieldManager;

  abstract final StateNotifier<bool> buttonState;
  abstract final StateNotifier<String?> errorFromState;
  abstract final StateNotifier<bool> loadState;

  abstract final String minSumText;

  abstract final String rateText;

  double get bottomPadding;

  double get screenHeight;

  void onPressNext();

  String? fromAmountValidate(String? text);
}

TransferDetailsScreenWidgetModel defaultTransferDetailsScreenWidgetModelFactory(
    BuildContext context) {
  return TransferDetailsScreenWidgetModel(
    TransferDetailsScreenModel(
      transferAbroadRepository: inject(),
    ),
    inject(),
  );
}

/// Виджет Модель для экран деталей перевода за границу
class TransferDetailsScreenWidgetModel
    extends WidgetModel<TransferDetailsScreen, TransferDetailsScreenModel>
    with SelectFromCardMixin<TransferDetailsScreen, TransferDetailsScreenModel>
    implements ITransferDetailsScreenWidgetModel {
  TransferDetailsScreenWidgetModel(
    super.model,
    this._analyticsInteractor,
  );

  @override
  final GlobalKey<PostfixTextFieldState> fromFieldKey = GlobalKey();

  @override
  late final fromFieldManager = AmountFieldManager();
  @override
  late final toFieldManager = AmountFieldManager();

  @override
  final buttonState = StateNotifier<bool>(initValue: false);

  @override
  final errorFromState = StateNotifier<String?>();

  @override
  final loadState = StateNotifier<bool>(initValue: false);

  @override
  late final String minSumText = AmountFormatter.formatNum(_minSum);
  @override
  late final String rateText = _rate.toStringAsFixed(3);

  final AnalyticsInteractor _analyticsInteractor;

  late final TransferDetailsScreenRouteArguments _arguments = widget.arguments;
  late final double _rate = _arguments.rateEntity.rate;
  late final int _minSum = _arguments.rateEntity.minAmount.toInt();
  late final int _maxSum = _arguments.rateEntity.maxAmount.toInt();

  late final ConversionHelper _conversionHelper;

  @override
  double get bottomPadding {
    final screenBottomPadding = MediaQuery.of(context).padding.bottom;
    final bottomPadding = screenBottomPadding == 0 ? 12 : screenBottomPadding;
    return bottomPadding + MediaQuery.of(context).viewInsets.bottom;
  }

  @override
  double get screenHeight => MediaQuery.of(context).size.height;

  AttachedCard? get _card => selectFromCardState.value;

  AbroadTransferReceiverEntity get _receiver => _arguments.receiverEntity;

  double get _fromSum => double.parse(fromFieldManager.rawTextWithoutPostfix);

  double get _depositAmount =>
      double.parse(toFieldManager.rawTextWithoutPostfix);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _conversionHelper = ConversionHelper(
      rate: _rate,
      fromController: fromFieldManager.controller,
      toController: toFieldManager.controller,
    );
    fromFieldManager.controller.addListener(_listenFromText);
    selectFromCardState.addListener(_listenCardChange);
  }

  @override
  void dispose() {
    _conversionHelper.dispose();
    fromFieldManager.dispose();
    toFieldManager.dispose();
    super.dispose();
  }

  @override
  Future<bool> selectFromCard({bool isShowBonusCard = false}) async {
    final ok = super.selectFromCard(isShowBonusCard: isShowBonusCard);
    _validate();
    return ok;
  }

  @override
  void onPressNext() async {
    if (!_validate()) {
      return;
    }

    _analyticsInteractor.abroadTracker.trackConverted();

    loadState.accept(true);

    final AbroadTransferRateEntity? rateEntity = await model.getTransferRate(
      merchantId: _arguments.transferCountryEntity.merchantId,
      pan: _receiver.pan,
      payAmount: double.parse(toFieldManager.controller.rawTextWithoutPostfix),
    );

    if (rateEntity == null || _card == null) {
      loadState.accept(false);
      return;
    }

    Navigator.pushNamed(
      context,
      TransferAbroadConfirmationScreenRoute.Tag,
      arguments: TransferAbroadConfirmationScreenRouteArguments(
        receiverEntity: _receiver,
        fromCard: _card!,
        amount: _depositAmount,
        isExchangeRateChanged: _arguments.rateEntity != rateEntity,
        transferCountryEntity: _arguments.transferCountryEntity,
        rateEntity: rateEntity,
      ),
    );

    loadState.accept(false);
  }

  @override
  String? fromAmountValidate(String? text) {
    String? errorText;

    final text = fromFieldManager.rawTextWithoutPostfix;

    final minError = sprintf(
      locale.getText('abroad_field_from_description_min_sum_error'),
      [_minSum],
    );
    final maxError = sprintf(
      locale.getText('abroad_field_from_description_max_sum_error'),
      [_maxSum],
    );

    final balance = selectFromCardState.value?.balance;

    if (text.isEmpty) {
      errorText = '';
    } else {
      final count = _fromSum;

      if (count < _minSum) {
        errorText = minError;
      } else if (count > _maxSum) {
        errorText = maxError;
      } else if (balance != null && balance < count) {
        errorText = locale.getText('insufficient_funds');
      }
    }

    errorFromState.accept(errorText);
    return errorText;
  }

  void _listenFromText() {
    _validate();
  }

  void _listenCardChange() {
    fromFieldKey.currentState?.validate();
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      _validate();
    });
  }

  bool _validate() {
    final result = _card != null && fromAmountValidate(null) == null;

    buttonState.accept(result);

    return result;
  }
}
