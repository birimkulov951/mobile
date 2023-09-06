import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/card_addition_req_entity.dart';
import 'package:mobile_ultra/domain/cards/card_addition_result.dart';
import 'package:mobile_ultra/domain/cards/card_beans_entity.dart';
import 'package:mobile_ultra/domain/cards/card_beans_result.dart';
import 'package:mobile_ultra/domain/cards/cards_balance_result.dart';
import 'package:mobile_ultra/domain/cards/field_switcher.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/card/addition/sms_confirm.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/card_addition_screen.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/card_addition_screen_model.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_already_exists_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_active_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/exceptions/card_not_found_or_sms_info_is_off_exception.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/widgets/card_input.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _cardNumberLength = 19;
const _cardExpirationLength = 5;
const _twoThousands = 2000;
const _monthQuantity = 12;
const _substringThree = 3;
const _substringTwo = 2;

abstract class ICardAdditionScreenWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin {
  TextEditingController get cardNumberCtrl;

  FocusNode get cardNumberFocus;

  TextEditingController get cardExpireCtrl;

  FocusNode get cardExpireFocus;

  double get bottomPadding;

  abstract final StateNotifier<int> selectedCardColorState;
  abstract final StateNotifier<CardType?> selectedCardTypeState;
  abstract final StateNotifier<bool> isLoadingState;
  abstract final StateNotifier<bool> isButtonClickableState;
  abstract final StateNotifier<FieldSwitcher> fieldSwitcherState;
  abstract final StateNotifier<String> errorTextState;
  abstract final GlobalKey<CardInputState> cardNumberKey;
  abstract final GlobalKey<CardInputState> cardExpKey;

  Future<void> onCardColorChanged(int selectedColor);

  Future<void> attemptToAddNewCard();

  Future<String?> onScanCardTap();

  Future<void> onReadyButtonTap();

  Future<void> onPrevTap();

  Future<void> onNextTap();

  String? cardNumberValidator(String? value);

  String? cardExpValidator(String? value);
}

class CardAdditionScreenWidgetModel
    extends WidgetModel<CardAdditionScreen, CardAdditionScreenModel>
    with SystemWidgetModelMixin<CardAdditionScreen, CardAdditionScreenModel>
    implements ICardAdditionScreenWidgetModel {
  CardAdditionScreenWidgetModel(super.model);

  final _cardNumberCtrl = TextEditingController();
  final _cardNumberFocus = FocusNode();

  final _cardExpireCtrl = TextEditingController();
  final _cardExpireFocus = FocusNode();

  final StateNotifier<int> _selectedCardColorState =
      StateNotifier<int>(initValue: 0);
  final StateNotifier<CardType?> _selectedCardTypeState =
      StateNotifier<CardType?>();
  final StateNotifier<bool> _isLoadingState =
      StateNotifier<bool>(initValue: false);
  final StateNotifier<bool> _isButtonClickableState =
      StateNotifier<bool>(initValue: false);
  final StateNotifier<FieldSwitcher> _fieldSwitcherState =
      StateNotifier<FieldSwitcher>(initValue: FieldSwitcher.hasNext());
  final StateNotifier<String> _errorTextState = StateNotifier<String>();

  // helpers
  CardBeansEntity? _beans;
  bool isCardNotSupport = false;
  int maxYear = 0;

  @override
  TextEditingController get cardNumberCtrl => _cardNumberCtrl;

  @override
  FocusNode get cardNumberFocus => _cardNumberFocus;

  @override
  TextEditingController get cardExpireCtrl => _cardExpireCtrl;

  @override
  FocusNode get cardExpireFocus => _cardExpireFocus;

  @override
  StateNotifier<int> get selectedCardColorState => _selectedCardColorState;

  @override
  StateNotifier<CardType?> get selectedCardTypeState => _selectedCardTypeState;

  @override
  StateNotifier<bool> get isLoadingState => _isLoadingState;

  @override
  StateNotifier<bool> get isButtonClickableState => _isButtonClickableState;

  @override
  StateNotifier<FieldSwitcher> get fieldSwitcherState => _fieldSwitcherState;

  @override
  StateNotifier<String> get errorTextState => _errorTextState;

  @override
  final GlobalKey<CardInputState> cardNumberKey = GlobalKey<CardInputState>();

  @override
  final GlobalKey<CardInputState> cardExpKey = GlobalKey<CardInputState>();

  @override
  double get bottomPadding => MediaQuery.of(context).padding.bottom + 16;

  // methods
  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _cardNumberCtrl.addListener(_onCardNumberChanged);
    _cardExpireCtrl.addListener(_onCardExpireDateChanged);
    _cardNumberFocus.addListener(_cardNumberListener);
    _cardExpireFocus.addListener(_cardExpireListener);

    maxYear = (DateTime.now().year - _twoThousands) + _monthQuantity;

    _getCardBeans();
  }

  @override
  void dispose() {
    _cardNumberCtrl.removeListener(_onCardNumberChanged);
    _cardExpireCtrl.removeListener(_onCardExpireDateChanged);
    _cardNumberFocus.removeListener(_cardNumberListener);
    _cardExpireFocus.removeListener(_cardExpireListener);

    _cardNumberCtrl.dispose();
    _cardNumberFocus.dispose();
    _cardExpireCtrl.dispose();
    _cardExpireFocus.dispose();

    _selectedCardColorState.dispose();
    _selectedCardTypeState.dispose();
    _isLoadingState.dispose();
    super.dispose();
  }

  @override
  Future<void> onCardColorChanged(int selectedColor) async =>
      selectedCardColorState.accept(selectedColor);

  @override
  Future<void> attemptToAddNewCard() async {
    FocusScope.of(context).focusedChild?.unfocus();
    _isLoadingState.accept(true);
    _newCardAddition();
  }

  @override
  Future<String?> onScanCardTap() async {
    await onReadyButtonTap();
    final cardEntity = await scanCard();

    if (cardEntity?.expiryDate != null) {
      _cardExpireCtrl.text = cardEntity!.expiryDate;
    }

    return cardEntity?.cardNumber;
  }

  @override
  Future<void> onReadyButtonTap() async =>
      FocusScope.of(context).focusedChild?.unfocus();

  @override
  Future<void> onNextTap() async => _cardNumberFocus.nextFocus();

  @override
  Future<void> onPrevTap() async => _cardExpireFocus.previousFocus();

  @override
  String? cardNumberValidator(String? value) {
    return errorTextState.value;
  }

  @override
  String? cardExpValidator(String? value) {
    return errorTextState.value;
  }

  void _setErrorAndValidateCardNumber(String? errorText) {
    _errorTextState.accept(errorText);
    cardNumberKey.currentState?.validate();
  }

  void _setErrorAndValidateCardExp(String? errorText) {
    _errorTextState.accept(errorText);
    cardExpKey.currentState?.validate();
  }

  Future<void> _getCardBeans() async {
    final beansResponse = await model.getCardBeans();

    if (beansResponse.status == CardBeansResultStatus.success) {
      _beans = beansResponse.result;
    }
  }

  void _onCardNumberChanged() {
    final currentText = _cardNumberCtrl.text.replaceAll(' ', '');

    if (currentText.length == 16 &&
        _cardNumberCtrl.selection.base.offset == 19) {
      _cardNumberFocus.nextFocus();
    }

    if (currentText.length >= 6) {
      if (isHumo(currentText)) {
        _selectedCardTypeState.accept(CardType.Humo);
      } else if (isUzcard(currentText)) {
        _selectedCardTypeState.accept(CardType.Uzcard);
      }
    } else {
      _selectedCardTypeState.accept(null);
    }

    _setErrorAndValidateCardNumber(null);
    onCheckButtonState();
  }

  void _onCardExpireDateChanged() {
    _setErrorAndValidateCardNumber(null);

    if (_cardExpireCtrl.text.length == _cardExpirationLength) {
      _checkExpireDate(_cardExpireCtrl.text);
    } else {
      onCheckButtonState();
    }
  }

  void _checkExpireDate(String value) {
    bool isInvalidExpireDate = false;

    if (value.length >= _substringTwo) {
      final month = int.parse(value.substring(0, _substringTwo));
      if (month == 0 || month > _monthQuantity) {
        isInvalidExpireDate = true;
      }
    }

    if (value.length == _cardExpirationLength) {
      final year = int.parse(value.substring(_substringThree, value.length));
      final currentYear = (DateTime.now().year - _twoThousands);

      if (year == currentYear) {
        final currentMonth = DateTime.now().month;
        final month = int.parse(value.substring(0, _substringTwo));

        if (currentMonth >= month) {
          isInvalidExpireDate = true;
        }
      }

      if (year == 0 || currentYear > year || year > maxYear) {
        isInvalidExpireDate = true;
      }
    }

    if (isInvalidExpireDate) {
      _isButtonClickableState.accept(false);
      _setErrorAndValidateCardExp(
          locale.getText('invalid_card_expiration_date'));
    } else {
      onCheckButtonState();
    }
  }

  void _cardNumberListener() => _cardNumberFocus.hasFocus
      ? _fieldSwitcherState.accept(FieldSwitcher.hasNext())
      : _fieldSwitcherState.accept(FieldSwitcher.hide());

  void _cardExpireListener() => _cardExpireFocus.hasFocus
      ? _fieldSwitcherState.accept(FieldSwitcher.hasPrev())
      : _fieldSwitcherState.accept(FieldSwitcher.hide());

  void onCheckButtonState() => _isButtonClickableState.accept(
        _cardNumberCtrl.text.length == _cardNumberLength &&
            _cardExpireCtrl.text.length == _cardExpirationLength,
      );

  void onError(String error, {dynamic errorBody}) {
    _setErrorAndValidateCardNumber(error);
    _isLoadingState.accept(false);
  }

  void _newCardAddition({bool isSMSConfirmPageOpen = false}) async {
    final String cardNumber = _cardNumberCtrl.text.replaceAll(' ', '');
    bool isHumoCard = false;
    bool isUzcardCard = false;

    _beans?.humo?.forEach((element) {
      if (element.contains(cardNumber.substring(0, 6))) {
        isHumoCard = true;
      }
    });

    _beans?.uzcard?.forEach((element) {
      if (element.contains(cardNumber.substring(0, 6))) {
        isUzcardCard = true;
      }
    });

    if (!isHumoCard && !isUzcardCard) {
      if (isCardNotSupport) {
        _isLoadingState.accept(false);
        _isButtonClickableState.accept(false);
        _setErrorAndValidateCardNumber(locale.getText('this_card_not_support'));
        return;
      }

      isCardNotSupport = true;

      final beansResponse = await model.getCardBeans(isFromDB: false);

      if (beansResponse.status == CardBeansResultStatus.success) {
        _beans = beansResponse.result;
        await attemptToAddNewCard();
      } else if (beansResponse.status == CardBeansResultStatus.failed) {
        isCardNotSupport = false;
        _isLoadingState.accept(false);
        _isButtonClickableState.accept(false);
        _setErrorAndValidateCardNumber(locale.getText('unknown_error'));
      }
      return;
    }

    isCardNotSupport = false;

    final String cardExpireDate = _cardExpireCtrl.text;
    final _orderOfCard =
        homeData?.cards.length == null || homeData!.cards.length < 2
            ? 1
            : homeData!.cards.length;

    if (isHumoCard) {
      final CardAdditionReqEntity cardToBeAdded = CardAdditionReqEntity(
        name: 'HUMO',
        main: false,
        color: _selectedCardColorState.value!,
        order: _orderOfCard,
        expiry: cardExpireDate.substring(3, 5) + cardExpireDate.substring(0, 2),
        pan: cardNumber,
        type: Const.HUMO,
      );

      final response = await model.cardAdditionHumo(cardToBeAdded);

      _handleResponse(response, isSMSConfirmPageOpen);
    } else {
      final CardAdditionReqEntity cardToBeAdded = CardAdditionReqEntity(
        name: 'Uzcard',
        main: false,
        color: _selectedCardColorState.value!,
        order: _orderOfCard,
        expiry: cardExpireDate.substring(3, 5) + cardExpireDate.substring(0, 2),
        pan: cardNumber,
        type: Const.UZCARD,
      );

      final response = await model.cardAdditionUzcard(cardToBeAdded);

      _handleResponse(response, isSMSConfirmPageOpen);
    }
  }

  void _handleResponse(
      CardAdditionResult response, bool isSMSConfirmPageOpen) async {
    switch (response.status) {
      case CardAdditionResultStatus.success:
        if (response.result?.sms ?? false) {
          final AttachedCard card = AttachedCard(
            id: response.result?.id,
            token: response.result?.token,
            name: response.result?.name,
            number: response.result?.maskedPan,
            status: CardStatus.values.singleWhereOrNull(
              (status) =>
                  status.toString() == 'CardStatus.${response.result?.status}',
            ),
            phone: response.result?.phone,
            balance: response.result?.balance,
            sms: response.result?.sms,
            bankId: response.result?.bankId,
            login: response.result?.login,
            isMain: response.result?.main,
            color: response.result?.color,
            expDate: response.result?.expireDate,
            activated: response.result?.activated,
            order: response.result?.order,
            type: response.result?.type,
            p2pEnabled: response.result?.p2pEnabled,
            subscribed: response.result?.subscribed,
            subscribeLastDate: response.result?.subscribeLastDate,
            maskedPhone: response.result?.maskedPhone,
          );

          if (isSMSConfirmPageOpen) {
            return;
          }

          final addCardResult = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CardSMSConfirmWidget(
                card: card,
                onResendCode: () =>
                    _newCardAddition(isSMSConfirmPageOpen: true),
              ),
            ),
          );

          if (addCardResult == null) {
            _isLoadingState.accept(false);
            return;
          }

          homeData ??= MainData();
          homeData!.cards.add(card);

          final list = homeData?.cards
              .where((card) => card.type != Const.BONUS)
              .toList(growable: false)
            ?..forEach((card) => card.viewTitle = false);

          list?.first.viewTitle = true;

          final cardsBalanceRes = await model.getCardBalance();

          switch (cardsBalanceRes.status) {
            case CardsBalanceResultStatus.success:
              _viewResult(addedCard: card);
              break;
            case CardsBalanceResultStatus.failed:
              _viewResult();
              break;
          }
        } else {
          _isLoadingState.accept(false);
          _setErrorAndValidateCardNumber(
            locale.getText('sms_informing_is_disabled_desc'),
          );
        }
        break;
      case CardAdditionResultStatus.cardNotFound:
        final error = (response.error as CardNotFoundException).title;
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(error);
        break;
      case CardAdditionResultStatus.cardAlreadyExists:
        final error = (response.error as CardAlreadyExistsException).title;
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(error);
        break;
      case CardAdditionResultStatus.cardNotFountOrSmsInfoIsOff:
        final error =
            (response.error as CardNotFountOrSmsInfoIsOffException).title;
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(error);
        break;
      case CardAdditionResultStatus.cardNotActive:
        final error = (response.error as CardNotActiveException).title;
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(error);
        break;
      case CardAdditionResultStatus.failed:
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(locale.getText('unknown_error'));
        break;
      default:
        _isLoadingState.accept(false);
        _setErrorAndValidateCardNumber(locale.getText('unknown_error'));
        break;
    }
  }

  void _viewResult({AttachedCard? addedCard}) {
    _isLoadingState.accept(false);
    Navigator.pop(context, addedCard);
  }
}

CardAdditionScreenWidgetModel cardAdditionScreenWidgetModelFactory(
  BuildContext context,
) =>
    CardAdditionScreenWidgetModel(
      CardAdditionScreenModel(
        systemRepository: inject(),
        cardsRepository: inject(),
      ),
    );
