import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/data/storages/chosen_payment_card_storage.dart';
import 'package:mobile_ultra/extensions/iterable_extension.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as UCard;
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/inject.dart';

import 'package:mobile_ultra/screens/base/mwwm/select_card/select_card.dart';

mixin ISelectFromCardMixin on IWidgetModel {
  abstract final StateNotifier<UCard.AttachedCard> selectFromCardState;

  Future<bool> selectFromCard({bool isShowBonusCard = false});
}

mixin SelectFromCardMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends ElementaryModel> on WidgetModel<W, M>
    implements ISelectFromCardMixin {
  @override
  final StateNotifier<UCard.AttachedCard> selectFromCardState =
      StateNotifier<UCard.AttachedCard>();

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    restoreSavedCard();
  }

  @override
  void dispose() {
    selectFromCardState.dispose();
    super.dispose();
  }

  @override
  Future<bool> selectFromCard({bool isShowBonusCard = false}) async {
    final result = await showModalBottomSheet<UCard.AttachedCard>(
      context: context,
      backgroundColor: ColorNode.Background,
      isScrollControlled: true,
      builder: (BuildContext context) => SelectCard(
        card: selectFromCardState.value,
        showBonusCard: isShowBonusCard,
        title: locale.getText("where"),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
    );

    if (result == null) {
      return false;
    }

    selectFromCardState.accept(result);
    //TODO: перенести логику в model
    final paynetLocalStorage = inject<ChosenPaymentCardStorage>();
    await paynetLocalStorage.saveLastPickedCardId(pickedCardId: result.id);
    return true;
  }

  Future<void> restoreSavedCard() async {
    final storedCard = await getStoredCard();
    selectFromCardState.accept(storedCard);
  }

  //TODO: перенести в model
  Future<UCard.AttachedCard?> getStoredCard() async {
    final paynetLocalStorage = inject<ChosenPaymentCardStorage>();
    final pickedCardId = await paynetLocalStorage.getLastPickedCardId();
    final storedCard =
        homeData?.cards.firstWhereOrNull((card) => card.id == pickedCardId);
    return storedCard;
  }
}
