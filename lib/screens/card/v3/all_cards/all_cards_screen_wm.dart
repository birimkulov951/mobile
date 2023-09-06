import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/domain/cards/card_edit_entity.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_wm.dart';
import 'package:mobile_ultra/screens/card/v3/all_cards/all_cards_screen.dart';
import 'package:mobile_ultra/screens/card/v3/all_cards/all_cards_screen_model.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/ui_models/various/message.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/inject.dart';

abstract class IAllCardsScreenWidgetModel extends IWidgetModel
    with IAttachedCardsWidgetModelMixin {
  abstract final AttachedCard? bonusCard;
  abstract final StateNotifier<List<AttachedCard?>> bankCards;
  abstract final bool isBalanceHidden;
  abstract final StateNotifier<bool> isReorderOn;
  abstract final double bottomPadding;

  abstract final ValueNotifier<bool> isLoading;

  void turnReorder();

  void onBackTap();

  void onReorder(int oldIndex, int newIndex);

  void deleteCard(String token);
}

class AllCardsScreenWidgetModel
    extends WidgetModel<AllCardsScreen, AllCardsScreenModel>
    with AttachedCardsWidgetModelMixin<AllCardsScreen, AllCardsScreenModel>
    implements IAllCardsScreenWidgetModel {
  AllCardsScreenWidgetModel(super.model);

  bool _isCardUpdated = false;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    isBalanceHidden = model.isBalanceVisible;
    homeData?.cards.forEach((card) {
      if (card.type != Const.BONUS) {
        bankCards.value?.add(card);
      }
    });
  }

  void _updateBankCards() async {
    _isCardUpdated = true;
    final List<AttachedCard?> _attachedCards = [];
    await model.getAttachedCards();
    await model.getActualBalance();
    homeData?.cards.forEach((card) {
      if (card.type != Const.BONUS) {
        _attachedCards.add(card);
      }
    });
    bankCards.accept(_attachedCards);
  }

  @override
  void onErrorHandle(Object error) async {
    super.onErrorHandle(error);
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

  @override
  late final bool isBalanceHidden;

  @override
  final StateNotifier<List<AttachedCard?>> bankCards =
      StateNotifier(initValue: []);

  @override
  final AttachedCard? bonusCard = homeData?.cards
      .firstWhereOrNull((element) => element.type == Const.BONUS);

  @override
  final StateNotifier<bool> isReorderOn = StateNotifier(initValue: false);

  @override
  void onReorder(int oldIndex, int newIndex) {
    final List<AttachedCard?> _cards = [];
    final reorderedCard = bankCards.value?.removeAt(oldIndex);
    bankCards.value?.forEach((element) {
      _cards.add(element);
    });
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    _cards.insert(newIndex, reorderedCard);
    model.editCard(
      CardEditEntity(
        name: _cards[newIndex]!.name!,
        token: _cards[newIndex]!.token,
        order: newIndex + 1,
        color: _cards[newIndex]!.color!,
        main: _cards[newIndex]!.isMain!,
      ),
    );
    _isCardUpdated = true;
    bankCards.accept(_cards);
  }

  @override
  void onBackTap() {
    Navigator.of(context).pop(_isCardUpdated);
  }

  @override
  double get bottomPadding => MediaQuery.of(context).viewPadding.bottom;

  @override
  Future<AttachedCard?> addNewCard() async {
    final AttachedCard? result = await super.addNewCard();
    if (result != null) {
      _updateBankCards();
      Toast.show(
        context,
        title: locale.getText('card_added_successfully'),
        type: ToastType.success,
      );
    }
    return result;
  }

  @override
  Future<bool?> onEditCard(AttachedCard card) async {
    final result = await super.onEditCard(card);
    if (result == true) {
      _updateBankCards();
    }
    return null;
  }

  @override
  void deleteCard(String token) async {
    final result = await deleteCardBottomSheet();
    if (result == true) {
      isLoading.value = true;
      final success = await model.deleteCard(token);
      isLoading.value = false;
      if (success) {
        _updateBankCards();
      }
    }
  }

  @override
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void turnReorder() {
    isReorderOn.accept(!isReorderOn.value!);
  }
}

AllCardsScreenWidgetModel allCardsScreenWidgetModelFactory(_) =>
    AllCardsScreenWidgetModel(AllCardsScreenModel(
      cardsRepository: inject(),
      homeRepository: inject(),
    ));
