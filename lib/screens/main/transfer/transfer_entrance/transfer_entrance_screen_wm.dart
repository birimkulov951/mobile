import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/abroad/abroad_transfer_country_entity.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/domain/transfer/p2p_info_entity.dart';
import 'package:mobile_ultra/domain/transfer/previous_transfer_entity.dart';
import 'package:mobile_ultra/domain/transfer/transfer_way_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/abroad_transfer_country.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/base/mwwm/remote_config/remote_config_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_to_card/select_to_card_wm.dart';
import 'package:mobile_ultra/screens/base/mwwm/select_contact/select_contact_bottom_sheet.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/abroad/transfer_abroad_receiver_search_screen/route/transfer_abroad_receiver_search_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_route.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_qr/transfer_by_qr_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/transfer_entrance_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/transfer_entrance_screen_model.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_entrance/widgets/choose_country_bottom_sheet.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/route/arguments.dart'
    as v3;
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/route/transfer_screen_route.dart'
    as v3;
import 'package:mobile_ultra/utils/inject.dart';
import 'package:ui_kit/ui_kit.dart';

const _abroadToKazMerchantId = 15590;

abstract class ITransferEntranceScreenWidgetModel extends IWidgetModel
    with
        ISystemWidgetModelMixin,
        IRemoteConfigWidgetModelMixin,
        ISelectToCardMixin {
  abstract final GlobalKey inputKey;

  abstract final TextEditingController controller;

  abstract final FocusNode focusNode;

  abstract final StateNotifier<String> helperState;

  abstract final EntityStateNotifier<List<PreviousTransferEntity>>
      previousTransfers;

  abstract final EntityStateNotifier<List<PreviousTransferEntity>>
      previousTransfersFilteredList;

  abstract final ValueNotifier<TransferScreenContent?> screenContentState;

  abstract final double nextButtonBottom;

  void onPreviousTransferTap(PreviousTransferEntity previousTransferEntity);

  void showChooseCountryBottomSheet();

  void onSelfTransferTap();

  Future<void> onQrPay();

  Future<String?> onScanCardTap();

  Future<String?> onGetContactTap();

  void onClearTap();

  void next();

  String? validator(String? value);
}

class TransferEntranceScreenWidgetModel
    extends WidgetModel<TransferEntranceScreen, TransferEntranceScreenModel>
    with
        SystemWidgetModelMixin<TransferEntranceScreen,
            TransferEntranceScreenModel>,
        RemoteConfigWidgetModelMixin<TransferEntranceScreen,
            TransferEntranceScreenModel>,
        SelectToCardMixin<TransferEntranceScreen, TransferEntranceScreenModel>,
        AutomaticKeepAliveWidgetModelMixin<TransferEntranceScreen,
            TransferEntranceScreenModel>
    implements
        ITransferEntranceScreenWidgetModel {
  TransferEntranceScreenWidgetModel(
    super.model,
    //TODO: не надо так делать
    this._analyticsInteractor,
  );

  @override
  final ValueNotifier<TransferScreenContent?> screenContentState =
      ValueNotifier<TransferScreenContent?>(null);

  @override
  final GlobalKey<CardOrPhoneInputState> inputKey =
      GlobalKey<CardOrPhoneInputState>();

  @override
  final TextEditingController controller = TextEditingController();

  @override
  final FocusNode focusNode = FocusNode();

  @override
  final StateNotifier<String> helperState = StateNotifier<String>();

  final StateNotifier<TransferWayEntity?> transferWayState =
      StateNotifier<TransferWayEntity>();

  @override
  final EntityStateNotifier<List<PreviousTransferEntity>> previousTransfers =
      EntityStateNotifier();

  @override
  EntityStateNotifier<List<PreviousTransferEntity>>
      previousTransfersFilteredList = EntityStateNotifier();

  final AnalyticsInteractor _analyticsInteractor;

  final List<AbroadTransferCountryEntity> _abroadTransferCountries = [
    const AbroadTransferCountryEntity(
      icon: Assets.circleFlagKazakhstan,
      country: Country.kazakhstan,
      merchantId: _abroadToKazMerchantId,
      flagToCountryUrl: Assets.icFlagKazakhstan,
    ),
  ];

  @override
  double get nextButtonBottom {
    const defaultBottomOffset = 16.0;
    final bottomBarHeight = MediaQuery.of(context).viewPadding.bottom + 64;
    return focusNode.hasFocus
        ? defaultBottomOffset
        : (defaultBottomOffset + bottomBarHeight);
  }

  String? extraError;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    controller.addListener(_controllerListener);
    focusNode.addListener(_focusListener);
    fetchRemoteConfig();
    _fetchTransferHistory();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    helperState.dispose();
    super.dispose();
  }

  @override
  String? validator(String? value) {
    return extraError;
  }

  @override
  void showChooseCountryBottomSheet() {
    _analyticsInteractor.abroadTracker.trackOpened();
    ChooseAbroadTransferCountryBottomSheet.show(
      context: context,
      abroadTransferCountries: _abroadTransferCountries,
      onCountrySelected: _onCountrySelected,
    );
  }

  @override
  Future<void> onQrPay() async {
    if (!(await checkPermission(PermissionRequest.cameraQr()))) {
      return;
    }
    final result =
        await Navigator.pushNamed<dynamic>(context, TransferByQRScreen.Tag);

    if (result != null) {
      //TODO (Magomed): rethink the implementation of this function
      widget.onQReadResult.call(result);
    }
  }

  @override
  void onSelfTransferTap() async {
    if (await selectToCard()) {
      final card = selectToCardState.value!;
      transferWayState.accept(TransferWayEntity.fromOwnCard(card));
      selectToCardState.accept(null);
      next();
    }
  }

  @override
  void onClearTap() {
    _setZeroState();
  }

  void searchPreviousTransfers(String query) {
    final filteredList = previousTransfers.value!.data!.where((transfer) {
      if (transfer is PreviousTransferByPanEntity) {
        return transfer.pan.contains(query);
      } else if (transfer is PreviousTransferByTokenEntity) {
        return transfer.maskedPan.contains(query);
      }
      return false;
    }).toList();

    if (filteredList.isNotEmpty) {
      previousTransfersFilteredList.content(filteredList);
    } else {
      previousTransfersFilteredList.content([]);
    }
  }

  void _setZeroState({bool unfocus = true}) {
    screenContentState.value = null;
    controller.clear();
    helperState.accept(null);

    transferWayState.accept(null);
    if (unfocus) {
      focusNode.unfocus();
    }
    _setErrorAndValidate(null);
    previousTransfersFilteredList.content(previousTransfers.value!.data!);
  }

  @override
  Future<String?> onGetContactTap() async {
    if (!await checkPermission(PermissionRequest.contacts())) {
      return null;
    }
    final contact = await SelectContactBottomSheet.show(context);
    return contact?.phone;
  }

  @override
  Future<String?> onScanCardTap() async {
    final cardEntity = await scanCard();
    return cardEntity?.cardNumber;
  }

  @override
  void onPreviousTransferTap(PreviousTransferEntity previousTransferEntity) {
    transferWayState
        .accept(TransferWayEntity.fromPreviousTransfer(previousTransferEntity));
    next();
  }

  void _setErrorAndValidate(String? error) {
    extraError = error;
    inputKey.currentState?.validate();
  }

  void _fetchTransferHistory() async {
    previousTransfers.loading();
    final response = await model.fetchPreviousTransfers();
    if (previousTransfers.value?.hasError == true) {
      previousTransfers.error();
      previousTransfers.content([]);
      previousTransfersFilteredList.content([]);
    }
    previousTransfers.content(response);
    previousTransfersFilteredList.content(response);
  }

  void _onCountrySelected(AbroadTransferCountryEntity country) {
    /// TODO брать от бэка
    _analyticsInteractor.abroadTracker.trackCountrySelected(
      AbroadTransferCountry.kazakhstan,
    );

    final navigator = Navigator.of(context);

    navigator.pop();
    navigator.pushNamed(
      TransferAbroadReceiverSearchScreenRoute.Tag,
      arguments: TransferAbroadReceiverSearchScreenRouteArguments(country),
    );
  }

  void _controllerListener() async {
    final text = controller.text.replaceAll(' ', '');
    if (text.isEmpty) {
      return _setZeroState();
    }
    final screenContent = screenContentState.value;
    if (screenContent is PhoneFoundTransferScreenContent) {
      if (screenContent.phoneNumber == text) {
        return;
      }
    }
    if (screenContent is CardFoundTransferScreenContent) {
      if (screenContent.pan == text) {
        return;
      }
    }
    extraError = null;
    if (extraError != null) {
      _setErrorAndValidate(null);
    }

    transferWayState.accept(null);

    searchPreviousTransfers(text);

    if (text.length >= 3) {
      if (text.startsWith('+')) {
        if (text.length == 13) {
          helperState.accept(null);
          screenContentState.value = LoadingTransferScreenContent();
          final bankCards = await model.getBankCardsPhoneNumber(text);

          if (bankCards != null) {
            screenContentState.value = PhoneFoundTransferScreenContent(
              phoneNumber: text,
              foundBanks: bankCards,
            );
          } else {
            _setErrorAndValidate(locale.getText('receiver_dont_have_card'));
            screenContentState.value = TransferScreenFocusedContentEmpty();
          }
        } else {
          helperState.accept(locale.getText('enter_full_phone_number'));
        }
      } else {
        if (text.length == 16) {
          helperState.accept(null);
          screenContentState.value = LoadingTransferScreenContent();
          final p2pInfo = await model.getP2PInfoByPan(text);

          if (p2pInfo != null) {
            screenContentState.value =
                CardFoundTransferScreenContent(p2pInfo: p2pInfo, pan: text);
          } else {
            _setErrorAndValidate(locale.getText('we_dont_found_card'));
            screenContentState.value = TransferScreenFocusedContentEmpty();
          }
        } else {
          helperState.accept(locale.getText('enter_16_digits_card_number'));
        }
      }
    } else {
      helperState.accept(null);
    }
  }

  void _focusListener() {
    final screenContent = screenContentState.value;
    if (focusNode.hasFocus && screenContent == null) {
      screenContentState.value = FocusedTransferScreenContent();
    }
  }

  @override
  void next() async {
    final screenContent = screenContentState.value;

    if (screenContent is PhoneFoundTransferScreenContent) {
      final allCards = [
        ...screenContent.foundBanks.pynetCards,
        ...screenContent.foundBanks.otherCards
      ];

      allCards.sort((a, b) {
        //сортируем чтобы дублирующие карты без срок находились сверху
        return (a.expiry ?? '').compareTo(b.expiry ?? '');
      });

      final bankCards = Map.fromEntries(allCards.map((e) => MapEntry(e.id, e)))
          .values
          .toList();

      final selectedBankCard = await Navigator.of(context).pushNamed(
        TransferBanksScreenRoute.Tag,
        arguments: TransferBanksScreenRouteArguments(
          bankCards: bankCards,
        ),
      ) as BankCardEntity?;

      if (selectedBankCard != null) {
        transferWayState
            .accept(TransferWayEntity.fromBankCard(selectedBankCard));
      } else {
        return;
      }
    } else if (screenContent is CardFoundTransferScreenContent) {
      transferWayState
          .accept(TransferWayEntity.fromP2PInfo(screenContent.p2pInfo));
    }

    final transferWay = transferWayState.value;
    if (transferWay == null) {
      return;
    }
    await Navigator.of(context).pushNamed(
      v3.TransferScreenRoute.Tag,
      arguments: v3.TransferScreenArguments(transferWay: transferWay),
    );
  }
}

TransferEntranceScreenWidgetModel wmFactory(_) =>
    TransferEntranceScreenWidgetModel(
      TransferEntranceScreenModel(
        systemRepository: inject(),
        remoteConfigRepository: inject(),
        transferRepository: inject(),
      ),
      inject(),
    );

abstract class TransferScreenContent {}

class FocusedTransferScreenContent extends TransferScreenContent {}

class LoadingTransferScreenContent extends TransferScreenContent {}

class TransferScreenFocusedContentEmpty extends TransferScreenContent {}

abstract class FoundTransferScreenContent extends TransferScreenContent {}

class CardFoundTransferScreenContent extends FoundTransferScreenContent {
  CardFoundTransferScreenContent({
    required this.p2pInfo,
    required this.pan,
  });

  final String pan;
  final P2PInfoEntity p2pInfo;
}

class PhoneFoundTransferScreenContent extends FoundTransferScreenContent {
  PhoneFoundTransferScreenContent({
    required this.phoneNumber,
    required this.foundBanks,
  });

  final String phoneNumber;
  final BankCardsEntity foundBanks;
}
