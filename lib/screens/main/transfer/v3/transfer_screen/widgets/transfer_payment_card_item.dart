import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:ui_kit/ui_kit.dart';

class TransferPaymentCardItem extends StatelessWidget {
  final bool isSelfTransfer;
  final StateNotifier<AttachedCard> selectCardState;
  final String? Function(CardStatus?) warningText;
  final String? cardName;
  final String? resultPan;
  final int? cardType;
  final Function({bool isShowBonusCard}) onTapToSelectCard;

  const TransferPaymentCardItem({
    Key? key,
    required this.onTapToSelectCard,
    required this.selectCardState,
    required this.warningText,
    this.isSelfTransfer = true,
    this.cardName,
    this.resultPan,
    this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isSelfTransfer
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTapToSelectCard(isShowBonusCard: false),
            child: StateNotifierBuilder<AttachedCard?>(
              listenableState: selectCardState,
              builder: (_, state) {
                if (state == null) {
                  return CardNoBalanceCell.Chevron(
                      key: const Key(WidgetIds.transferScreenSelectCard),
                      cardIcon: ProductIcons.accountPlaceholderAdd,
                      cardName: locale.getText('select_card'));
                }
                return CardCell.Chevron(
                  key: const Key(WidgetIds.transferScreenChangeCard),
                  cardIcon: MiniCard(
                    lastFour: lastFour(state.number!),
                    cardBrand: cardBrandTextLogoFromType(state.type),
                    backgroundColor: ColorUtils.colorSelect[state.color!]!,
                  ),
                  cardName: _lowerCasedCardName(state.name),
                  cardBalance: formatAmount(state.balance),
                  cardCurrency: locale.getText('sum'),
                  cardNameTrailing: cardNameTrailing(state.number!),
                  cardStatusText: warningText(state.status),
                  cardStatusIcon: isCardValid(state.status)
                      ? null
                      : OperationIcons.statusWarning,
                  statusColor: IconAndOtherColors.warning,
                  isOpaque: isCardValid(state.status),
                );
              },
            ),
          )
        : GestureDetector(
            key: const Key(WidgetIds.transferScreenSelectCard),
            onTap: () => Navigator.of(context).pop(),
            child: CardNoBalanceCell.Chevron(
              cardIcon: cardIconFronType(cardType),
              cardName: _lowerCasedCardName(cardName),
              cardNumber: resultPan,
            ),
          );
  }

  String _lowerCasedCardName(String? cardName) {
    String result = '';
    if (cardName == null) {
      return result;
    }

    final splitCardName = cardName.split(' ');
    splitCardName.forEach((element) {
      if (element.length >= 2) {
        result = result +
            element.substring(0, 1).toUpperCase() +
            element.substring(1).toLowerCase() +
            ' ';
      }
    });
    return result;
  }
}
