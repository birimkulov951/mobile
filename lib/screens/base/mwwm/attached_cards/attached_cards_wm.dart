import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/attached_cards_model.dart';
import 'package:mobile_ultra/screens/base/mwwm/attached_cards/bonus_card.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/card_addition_screen_route.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/route/arguments.dart';
import 'package:mobile_ultra/screens/card/v3/edit_card/route/edit_card_screen_route.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet_dialog.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

mixin IAttachedCardsWidgetModelMixin on IWidgetModel {
  Future<AttachedCard?> addNewCard();

  Future<bool?> onEditCard(AttachedCard card);

  Future<MainData?> getAttachedCards();

  Future<void> getActualBalance();

  String warningText(CardStatus? cardStatus);

  Future<bool?> deleteCardBottomSheet();
}

mixin AttachedCardsWidgetModelMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends AttachedCardsModelMixin> on WidgetModel<W, M>
    implements IAttachedCardsWidgetModelMixin {
  @override
  Future<AttachedCard?> addNewCard() async {
    final updatedResult = await Navigator.pushNamed(
      context,
      CardAdditionScreenRoute.Tag,
      arguments: const CardAdditionScreenRouteArguments(),
    );
    return updatedResult as AttachedCard?;
  }

  @override
  Future<bool?> onEditCard(AttachedCard card) async {
    if (card.type == Const.BONUS) {
      await viewModalSheet(
        context: context,
        child: BonusCard(bonusCard: card),
        boxConstraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).viewPadding.top + 32),
        ),
      );
      return null;
    }
    final result = await Navigator.pushNamed(
      context,
      EditCardScreenRoute.Tag,
      arguments: EditCardScreenArguments(attachedCard: card),
    ) as bool?;

    return result;
  }

  @override
  Future<MainData?> getAttachedCards() async {
    return await model.getAttachedCards();
  }

  @override
  Future<void> getActualBalance() async {
    await model.getActualBalance();
  }

  @override
  String warningText(CardStatus? cardStatus) {
    if (cardStatus == CardStatus.VALID) {
      return '';
    }
    if (cardStatus == CardStatus.HUMO_DISABLED) {
      return locale.getText('humo_under_maintenance');
    } else if (cardStatus == CardStatus.UZCARD_DISABLED) {
      return locale.getText('uzcard_under_maintenance');
    } else {
      return locale.getText('bank_blocked_card');
    }
  }

  @override
  Future<bool?> deleteCardBottomSheet() async {
    return await viewAndroidModalSheetDialog(
      context: context,
      title: locale.getText('confirm_delete_card'),
      confirmBtnTitle: locale.getText('remove_card'),
      cancelBtnTitle: locale.getText('cancel'),
      confirmBtnTextStyle: Typographies.textMediumError,
      cancelBtnTextStyle: Typographies.textRegularSecondary,
    );
  }
}
