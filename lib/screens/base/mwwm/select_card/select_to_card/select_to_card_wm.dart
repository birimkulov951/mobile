import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart' as UCard;
import 'package:mobile_ultra/screens/base/mwwm/select_card/select_card.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

mixin ISelectToCardMixin on IWidgetModel {
  abstract final StateNotifier<UCard.AttachedCard> selectToCardState;

  Future<bool> selectToCard( {bool isShowBonusCard = false});
}

mixin SelectToCardMixin<W extends ElementaryWidget<IWidgetModel>,
        M extends ElementaryModel> on WidgetModel<W, M>
    implements ISelectToCardMixin {
  @override
  final StateNotifier<UCard.AttachedCard> selectToCardState =
      StateNotifier<UCard.AttachedCard>();

  @override
  void dispose() {
    selectToCardState.dispose();
    super.dispose();
  }

  @override
  Future<bool> selectToCard({bool isShowBonusCard = false}) async {
    final result = await showModalBottomSheet<UCard.AttachedCard>(
      context: context,
      backgroundColor: ColorNode.Background,
      isScrollControlled: true,
      builder: (BuildContext context) => SelectCard(
        card: selectToCardState.value,
        showBonusCard: isShowBonusCard,
        title: locale.getText("wheres"),
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

    selectToCardState.accept(result);
    return true;
  }

}
