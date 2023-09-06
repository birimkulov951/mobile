import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale, homeData;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/arguments.dart';
import 'package:mobile_ultra/screens/card/card_mvvm/card_addition/route/card_addition_screen_route.dart';
import 'package:mobile_ultra/ui_models/toast/toast.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/widgets/%D1%81ard_modal_block.dart';

class AllCardsForPaymentPage extends StatefulWidget {
  final AttachedCard? card;

  const AllCardsForPaymentPage({this.card});

  @override
  State<StatefulWidget> createState() => _AllCardsForPaymentPageState();
}

class _AllCardsForPaymentPageState extends State<AllCardsForPaymentPage> {
  @override
  Widget build(BuildContext context) {
    final bonusPos =
        homeData?.cards.indexWhere((card) => card.type == Const.BONUS);
    if (bonusPos != null && bonusPos != -1 && bonusPos != 0) {
      final value = homeData?.cards.removeAt(bonusPos);

      if (value != null) {
        homeData?.cards.insert(0, value);
      }
    }

    return SafeArea(
      child: CardModalBlock(
        bottomPadding: 16,
        isShowBonusCard: true,
        initCard: widget.card,
        cards: homeData?.cards,
        title: locale.getText('where'),
        sectionTitle: locale.getText('my_cards'),
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
