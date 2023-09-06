import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_receiver_entity.dart';
import 'package:mobile_ultra/domain/exceptions/status_exception.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/destination_selected_type.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/transfer_abroad_receiver_search_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/transfer_abroad_receiver_search_screen_model.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_details_screen/route/transfer_details_screen_route.dart';
import 'package:mobile_ultra/ui_models/modal_bottom_sheet/alert_bottom_sheet.dart';
import 'package:mobile_ultra/utils/inject.dart';

TransferAbroadReceiverSearchScreenWidgetModel
    receiverSearchScreenWidgetModelFactory(BuildContext context) {
  return TransferAbroadReceiverSearchScreenWidgetModel(
    model: TransferAbroadReceiverSearchScreenModel(
      systemRepository: inject(),
      transferAbroadRepository: inject(),
      permissionRepository: inject(),
    ),
    analyticsInteractor: inject(),
  );
}

abstract class ITransferAbroadReceiverSearchScreenWidgetModel
    extends IWidgetModel {
  abstract final StateNotifier<String> cardInputSuffixIconNameState;

  abstract final StateNotifier<String> cardInputValueState;

  abstract final StateNotifier<bool> isLoadingState;

  abstract final EntityStateNotifier<List<AbroadTransferReceiverEntity>>
      lastReceiversState;

  abstract final EntityStateNotifier<AbroadTransferReceiverEntity?>
      receiverState;

  abstract final TextEditingController cardInputController;

  abstract final ScrollController scrollController;

  abstract final List<TextInputFormatter> cardInputFormatters;

  void onCardInputActionTap();

  void unfocusCardInput();

  void onSelectReceiver(AbroadTransferReceiverEntity receiver);

  void onTapCardNumber();
}

class TransferAbroadReceiverSearchScreenWidgetModel extends WidgetModel<
        TransferAbroadReceiverSearchScreen,
        TransferAbroadReceiverSearchScreenModel>
    with SystemWidgetModelMixin
    implements ITransferAbroadReceiverSearchScreenWidgetModel {
  TransferAbroadReceiverSearchScreenWidgetModel({
    required TransferAbroadReceiverSearchScreenModel model,
    required this.analyticsInteractor,
  }) : super(model);

  final AnalyticsInteractor analyticsInteractor;

  //#region private fields
  final _cardMask = '0000 0000 0000 0000';
  final _cardNumberLenght = 16;
  late final _maskedInputFormatter = MaskedInputFormatter(_cardMask);

  String get _cardInputSuffixIconName {
    if (cardInputController.text.isEmpty) {
      return Assets.scanner;
    }
    return Assets.clear;
  }

  String get _value {
    return cardInputController.text.replaceAll(' ', '');
  }

  //#endregion

  //#region public fields
  @override
  final TextEditingController cardInputController = TextEditingController();

  @override
  final ScrollController scrollController = ScrollController();

  @override
  final StateNotifier<String> cardInputSuffixIconNameState =
      StateNotifier<String>(initValue: Assets.scanner);

  @override
  late final List<TextInputFormatter> cardInputFormatters = [
    _maskedInputFormatter
  ];

  @override
  late final StateNotifier<String> cardInputValueState =
      StateNotifier<String>(initValue: cardInputController.text);

  @override
  final StateNotifier<bool> isLoadingState = StateNotifier(initValue: false);

  @override
  final EntityStateNotifier<AbroadTransferReceiverEntity?> receiverState =
      EntityStateNotifier<AbroadTransferReceiverEntity?>();

  @override
  final EntityStateNotifier<List<AbroadTransferReceiverEntity>>
      lastReceiversState =
      EntityStateNotifier<List<AbroadTransferReceiverEntity>>();

  //#endregion

  //#region methods
  @override
  void initWidgetModel() {
    cardInputController.addListener(_cardInputChanged);
    scrollController.addListener(_scrollListener);

    _fetchLastReceivers();
    super.initWidgetModel();
  }

  @override
  void dispose() {
    cardInputController.removeListener(_cardInputChanged);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    cardInputController.dispose();
    cardInputSuffixIconNameState.dispose();
    cardInputValueState.dispose();
    super.dispose();
  }

  @override
  void onSelectReceiver(AbroadTransferReceiverEntity receiver) async {
    analyticsInteractor.abroadTracker.trackDestinationSelected(
      _checkIsNewCard(receiver)
          ? DestinationSelectedType.newCard
          : DestinationSelectedType.previousCard,
    );

    unfocusCardInput();
    final merchantId = widget.arguments.transferCountryEntity.merchantId;

    final pan = receiver.pan;

    this.isLoadingState.accept(true);
    final rate = await model.getTransferRate(
      merchantId: merchantId,
      pan: pan,
    );
    this.isLoadingState.accept(false);

    if (rate == null) {
      return;
    }

    widget.arguments.transferCountryEntity;
    Navigator.of(context).pushNamed(
      TransferDetailsScreenRoute.Tag,
      arguments: TransferDetailsScreenRouteArguments(
        receiverEntity: receiver,
        rateEntity: rate,
        transferCountryEntity: widget.arguments.transferCountryEntity,
      ),
    );
  }

  @override
  void onTapCardNumber() {
    final value = _value;
    if (value.length != _cardNumberLenght) {
      unfocusCardInput();
      AlertBottomSheet.show(
        context: context,
        title: 'enter_full_card_number',
        bodyText: 'enter_full_card_number_desc',
        buttonText: 'good',
        maxPercentageHeight: 0.5,
      );
      return;
    }

    _fetchReceiver(value);
  }

  @override
  void onCardInputActionTap() async {
    if (cardInputController.text.isNotEmpty) {
      cardInputController.clear();
      receiverState.content(null);
    } else {
      this.unfocusCardInput();

      final scannedCard = await scanCard();
      if (scannedCard != null) {
        _changeCardNumber(scannedCard.cardNumber.replaceAll(' ', ''));
      }
    }
  }

  @override
  void unfocusCardInput() {
    final primaryFocus = FocusManager.instance.primaryFocus;
    if (primaryFocus?.hasFocus ?? false) {
      primaryFocus?.unfocus();
    }
  }

  @override
  void onErrorHandle(Object error) {
    if (error is StatusException) {
      _showInvalidCardBottomSheet();
    }
    super.onErrorHandle(error);
  }

  //#endregion

  //#region private methods
  void _changeCardNumber(String cardNumber) {
    final value = MaskedInputFormatter(_cardMask).applyMask(cardNumber);
    cardInputController.value =
        cardInputController.value.copyWith(text: value.text);
  }

  void _cardInputChanged() {
    final currentText = cardInputController.text;
    final prevText = cardInputValueState.value;

    cardInputSuffixIconNameState.accept(_cardInputSuffixIconName);
    cardInputValueState.accept(currentText);

    final value = _value;

    if (currentText != prevText &&
        currentText.isNotEmpty &&
        value.length == _cardNumberLenght) {
      unfocusCardInput();
      _fetchReceiver(value);
    }
  }

  void _scrollListener() {
    unfocusCardInput();
  }

  Future<void> _fetchReceiver(String cardNumber) async {
    final prevData = receiverState.value?.data;
    receiverState.loading(prevData);

    final receiver = await model.findReceiverByPan(cardNumber);

    if (receiver == null) {
      _showInvalidCardBottomSheet();
      receiverState.content(prevData);
      return;
    }

    receiverState.content(receiver);
  }

  Future<void> _fetchLastReceivers() async {
    final data = lastReceiversState.value?.data;

    lastReceiversState.loading(data);

    final receivers = await model.fetchLastReceivers() ?? [];

    lastReceiversState.content(receivers);
  }

  void _showInvalidCardBottomSheet() {
    AlertBottomSheet.show(
      context: context,
      title: 'invalid_card_number',
      bodyText: 'invalid_card_number_desc',
      buttonText: 'clear',
      maxPercentageHeight: 0.5,
    );
  }

//endregion
  bool _checkIsNewCard(AbroadTransferReceiverEntity receiver) {
    return !(lastReceiversState.value?.data?.contains(receiver) ?? false);
  }
}
