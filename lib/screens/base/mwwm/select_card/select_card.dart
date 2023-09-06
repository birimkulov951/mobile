import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/card_addition_screen_route.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/widgets/%D1%81ard_modal_block.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class SelectCard extends StatelessWidget {
  final AttachedCard? card;
  final bool showBonusCard;
  final String title;

  const SelectCard({
    required this.title,
    super.key,
    this.card,
    this.showBonusCard = false,
  });

  List<AttachedCard> _getCards() {
    final bonusCard =
        homeData!.cards.firstWhere((card) => card.type == Const.BONUS);
    final bankCards =
        homeData!.cards.where((card) => card.type != Const.BONUS).toList();
    bankCards.sort((a, b) => b.type?.compareTo(b.type ?? 0) ?? 0);
    return [bonusCard, ...bankCards];
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (
        BuildContext context,
        LocaleHelper locale,
      ) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setState,
          ) {
            return CardModalBlock(
              title: title,
              sectionTitle: locale.getText('my_cards'),
              bottomPadding: MediaQuery.of(context).viewPadding.bottom + 24,
              initCard: card,
              cards: _getCards(),
              isShowBonusCard: showBonusCard,
              onPressAddCard: () async {
                final result = await Navigator.pushNamed(
                  context,
                  CardAdditionScreenRoute.Tag,
                  arguments: const CardAdditionScreenRouteArguments(),
                );

                if (result != null) {
                  setState(() {
                    Toast.show(
                      context,
                      title: locale.getText('card_added_successfully'),
                      type: ToastType.success,
                    );
                  });
                }
              },
            );
          },
        );
      },
    );
  }
}
