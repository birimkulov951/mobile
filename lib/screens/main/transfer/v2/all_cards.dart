import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale, homeData;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/card_addition_screen_route.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/widgets/%D1%81ard_modal_block.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class AllCardsForTransfer extends StatefulWidget {
  final AttachedCard? card;
  final bool isFrom;

  const AllCardsForTransfer({
    super.key,
    this.card,
    this.isFrom = true,
  });

  @override
  State<StatefulWidget> createState() => _AllCardsForTransferState();
}

class _AllCardsForTransferState extends State<AllCardsForTransfer> {
  String _getTitle() {
    if (widget.isFrom) {
      return locale.getText('where');
    }
    return locale.getText('wheres');
  }

  @override
  Widget build(BuildContext context) {
    final bonusPos =
        homeData?.cards.indexWhere((card) => card.type == Const.BONUS);

    if (bonusPos != null &&
        homeData != null &&
        bonusPos != -1 &&
        bonusPos != 0) {
      homeData?.cards.insert(0, homeData!.cards.removeAt(bonusPos));
    }

    return LocaleBuilder(
      builder: (_, locale) => CardModalBlock(
        title: _getTitle(),
        sectionTitle: locale.getText('my_cards'),
        bottomPadding: MediaQuery.of(context).viewPadding.bottom + 24,
        initCard: widget.card,
        cards: homeData?.cards,
        onPressAddCard: () async {
          final result = await Navigator.pushNamed(
            context,
            CardAdditionScreenRoute.Tag,
            arguments: const CardAdditionScreenRouteArguments(),
          );

          if (result != null) {
            setState(
              () => Toast.show(
                context,
                title: locale.getText('card_added_successfully'),
                type: ToastType.success,
              ),
            );
          }
        },
      ),
    );
  }
}
