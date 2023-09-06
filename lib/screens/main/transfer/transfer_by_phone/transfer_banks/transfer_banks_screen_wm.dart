import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards_by_phone_number/cards_by_phone_number_entity.dart';
import 'package:mobile_ultra/interactor/analytics/analytics_interactor.dart';
import 'package:mobile_ultra/interactor/analytics/data/transfer_by_phone_selected_type.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/system_wm.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/route/transfer_banks_screen_arguments.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/transfer_banks_screen.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/transfer_banks_screen_model.dart';
import 'package:mobile_ultra/screens/main/transfer/transfer_by_phone/transfer_banks/widgets/bank_cards_bottom_sheet.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IBanksScreenWidgetModel extends IWidgetModel
    with ISystemWidgetModelMixin {
  TextEditingController get searchController;

  FocusNode get searchFocus;

  EntityStateNotifier<List<BankEntity>> get searchItemsState;

  void onSearchCancel();

  void onBankTap(BankEntity bank);
}

class TransferBanksScreenWidgetModel
    extends WidgetModel<TransferBanksScreen, TransferBanksScreenModel>
    with SystemWidgetModelMixin
    implements IBanksScreenWidgetModel {
  TransferBanksScreenWidgetModel({
    required TransferBanksScreenModel model,
  }) : super(model);

  late final TransferBanksScreenRouteArguments _arguments = widget.arguments;
  late String? _phoneNumber = _arguments.phoneNumber;

  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;
  late final EntityStateNotifier<List<BankEntity>> _searchItemsState;

  List<BankCardEntity> _cardList = [];
  List<BankEntity> _bankList = [];

  @override
  TextEditingController get searchController => _searchController;

  @override
  FocusNode get searchFocus => _searchFocus;

  @override
  EntityStateNotifier<List<BankEntity>> get searchItemsState =>
      _searchItemsState;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _searchItemsState = EntityStateNotifier<List<BankEntity>>();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    _searchController.addListener(_searchInputChanged);
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchInputChanged);
    _searchController.dispose();
    _searchFocus.dispose();
    _searchItemsState.dispose();
    super.dispose();
  }

  @override
  void onBankTap(BankEntity bank) async {
    AnalyticsInteractor.instance.transferByPhone.trackBankSelected();

    final cardList =
        _cardList.where((card) => card.bank.bankName == bank.bankName).toList();

    final card = await BankCardsBottomSheet.show(
      context: context,
      cardList: cardList,
      onCardSelected: (card) {
        AnalyticsInteractor.instance.transferByPhone
            .trackCardSelected(TransferByPhoneSelectedType.apiList);
        Navigator.pop(context, card);
      },
    );

    if (card != null) {
      Navigator.pop(context, card);
    }
  }

  @override
  void onSearchCancel() {
    _searchController.clear();
    _searchFocus.unfocus();
  }

  void _searchInputChanged() {
    final searchedItems = _bankList.where((bank) => bank.bankName
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()));

    _searchItemsState.content(searchedItems.toList());
  }

  Future<void> _fetchData() async {
    final data = _searchItemsState.value?.data;
    _searchItemsState.loading(data);

    List<BankCardEntity> bankCards;
    if (_phoneNumber != null) {
      final response = await model.getCardsByPhoneNumber(_phoneNumber!);
      bankCards = response?.bankCardsData.pynetCards ?? [];
    } else {
      bankCards = _arguments.bankCards;
    }
    _cardList.addAll(bankCards);
    _cardList.forEach((card) {
      if (!_bankList.contains(card.bank)) {
        _bankList.add(card.bank);
      }
    });
    _bankList.sort((a, b) => a.bankName.compareTo(b.bankName));
    _searchItemsState.content(_bankList);
  }
}

TransferBanksScreenWidgetModel transferBanksScreenWidgetModelFactory(_) =>
    TransferBanksScreenWidgetModel(
      model: TransferBanksScreenModel(
        systemRepository: inject(),
        transferByPhoneNumberRepository: inject(),
      ),
    );
