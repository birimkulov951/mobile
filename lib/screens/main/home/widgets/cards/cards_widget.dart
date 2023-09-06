import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/net/card/model/main_data.dart';
import 'package:mobile_ultra/screens/main/home/widgets/cards/cards_shimmer.dart';
import 'package:mobile_ultra/screens/main/home/widgets/cards/no_attached_cards_banner.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _maxCardsShow = 5;

class CardsWidget extends StatelessWidget {
  const CardsWidget({
    required this.attachNewCard,
    required this.warningText,
    required this.getPaynetUCards,
    required this.openAllCards,
    required this.onEditCard,
    required this.allCardsData,
    this.hideBalance = false,
    super.key,
  });

  final bool hideBalance;
  final Future Function() attachNewCard;
  final VoidCallback getPaynetUCards;
  final Future Function() openAllCards;
  final Future Function(AttachedCard) onEditCard;
  final String Function(CardStatus?) warningText;
  final EntityStateNotifier<MainData> allCardsData;

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder(
      listenableEntityState: allCardsData,
      builder: (_, MainData? data) {
        if (data == null) {
          return const SizedBox.shrink();
        } else {
          return data.cards.length > 1
              ? LocaleBuilder(builder: (_, locale) {
                  return DecoratedBox(
                    decoration: const BoxDecoration(
                      color: BackgroundColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleLayout(locale, data.cards),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: cardsLayout(data.cards),
                        ),
                      ],
                    ),
                  );
                })
              : NoAttachedCardsBanner(attachNewCard: attachNewCard);
        }
      },
      loadingBuilder: (_, MainData? data) {
        if (data == null) {
          return const CardsShimmer();
        }
        return data.cards.length > 1
            ? LocaleBuilder(builder: (_, locale) {
                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: BackgroundColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleLayout(locale, data.cards),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: cardsLayout(data.cards),
                      ),
                    ],
                  ),
                );
              })
            : NoAttachedCardsBanner(attachNewCard: attachNewCard);
      },
    );
  }

  Widget titleLayout(LocaleHelper locale, List<AttachedCard> allCards) {
    final attachedCardsCount =
        allCards.where((card) => card.type != Const.BONUS).length;

    final showMoreCards = attachedCardsCount > _maxCardsShow - 1;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: showMoreCards ? openAllCards : attachNewCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: showMoreCards
            ? HeadlineV2.Counter(
                title: locale.getText('my_cards'),
                count: attachedCardsCount,
              )
            : HeadlineV2.AddButton(title: locale.getText('my_cards')),
      ),
    );
  }

  Widget cardsLayout(List<AttachedCard> allCards) {
    final bonusCard = allCards.firstWhere((card) => card.type == Const.BONUS);
    final bankCards =
        allCards.where((card) => card.type != Const.BONUS).toList();
    bankCards.sort((a, b) => b.type?.compareTo(b.type ?? 0) ?? 0);
    final cards = [bonusCard, ...bankCards];

    if (cards.length > _maxCardsShow) {
      cards.removeRange(_maxCardsShow, cards.length);
    }
    return LocaleBuilder(builder: (_, locale) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final card in cards) ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onEditCard(card),
              child: CardCell(
                cardIcon: MiniCard(
                  lastFour: lastFour(card.number!),
                  cardBrand: cardBrandTextLogoFromType(card.type),
                  backgroundColor: ColorUtils.colorSelect[card.color]!,
                ),
                cardName: _cardName(card, locale),
                cardBalance: formatAmount(card.balance, isHidden: hideBalance),
                cardCurrency: locale.getText('sum'),
                isOpaque: isCardValid(card.status),
              ),
            ),
            if (!isCardValid(card.status)) ...[
              Infobox.warning(text: warningText(card.status)),
              const SizedBox(height: 12),
            ]
          ]
        ],
      );
    });
  }

  String _cardName(AttachedCard card, LocaleHelper locale) {
    if (card.type == Const.BONUS) {
      return '${locale.getText('bonus_card')}${cardNameTrailing(card.number!)}';
    }
    return '${card.name}${cardNameTrailing(card.number!)}';
  }
}
