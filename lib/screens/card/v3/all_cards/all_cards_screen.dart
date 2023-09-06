import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/card/v3/all_cards/all_cards_screen_wm.dart';
import 'package:mobile_ultra/ui_models/app_bar/v2/app_bar_v2.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/ui_models/various/loading.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _bottomPadding = 84.0;

class AllCardsScreen extends ElementaryWidget<IAllCardsScreenWidgetModel> {
  const AllCardsScreen({Key? key})
      : super(allCardsScreenWidgetModelFactory, key: key);

  @override
  Widget build(IAllCardsScreenWidgetModel wm) {
    return WillPopScope(
      onWillPop: () {
        wm.onBackTap();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBarV2(
          title: TextLocale(
            locale.getText('my_cards'),
            style: TextStylesX.title5,
            overflow: TextOverflow.fade,
          ),
          onBackTap: wm.onBackTap,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  if (wm.bonusCard != null)
                    _BonusCard(
                      bonusCard: wm.bonusCard!,
                      isBalanceHidden: wm.isBalanceHidden,
                      onEditCard: wm.onEditCard,
                    ),
                  if (wm.bankCards.value!.isNotEmpty) ...[
                    MultiListenerRebuilder(
                      listenableList: [
                        wm.isReorderOn,
                        wm.bankCards,
                      ],
                      builder: (_) {
                        final isReorderOn = wm.isReorderOn.value == true;
                        return _BankCards(
                          isReorderOn: isReorderOn,
                          turnReorder: wm.turnReorder,
                          onReorder: wm.onReorder,
                          isBalanceHidden: wm.isBalanceHidden,
                          bankCards: wm.bankCards.value!,
                          onEditCard: wm.onEditCard,
                          deleteCard: wm.deleteCard,
                          warningText: wm.warningText,
                        );
                      },
                    ),
                  ],
                  SizedBox(height: wm.bottomPadding + _bottomPadding),
                ],
              ),
            ),
            Positioned(
              bottom: wm.bottomPadding,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RoundedButton(
                  onPressed: wm.addNewCard,
                  title: locale.getText('add_card'),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: wm.isLoading,
              builder: (_, bool isLoading, __) {
                return LoadingWidget(
                  showLoading: isLoading,
                  withProgress: true,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _BankCards extends StatelessWidget {
  const _BankCards({
    required this.isReorderOn,
    required this.turnReorder,
    required this.onReorder,
    required this.isBalanceHidden,
    required this.bankCards,
    required this.onEditCard,
    required this.deleteCard,
    required this.warningText,
  });

  final bool isReorderOn;
  final bool isBalanceHidden;
  final List<AttachedCard?> bankCards;
  final VoidCallback turnReorder;
  final Function(int, int) onReorder;
  final Function(AttachedCard) onEditCard;
  final Function(String) deleteCard;
  final String Function(CardStatus?) warningText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isReorderOn
            ? HeadlineV2.Text(
                title: locale.getText('bank_cards'),
                text: locale.getText('ready'),
                textStyle: Typographies.textMediumAccent,
                onTap: turnReorder,
              )
            : HeadlineV2.Icon24(
                title: locale.getText('bank_cards'),
                icon: ActionIcons.settings,
                onTap: turnReorder,
              ),
        const SizedBox(height: 12),
        RoundedContainer(
          child: ReorderableListView(
            onReorder: onReorder,
            shrinkWrap: true,
            buildDefaultDragHandles: isReorderOn,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              bankCards.length,
              (index) {
                final card = bankCards[index];
                return _ReorderAbleItem(
                  key: ValueKey('${card?.id}'),
                  card: card!,
                  index: index,
                  isReorderOn: isReorderOn,
                  deleteCard: deleteCard,
                  isBalanceHidden: isBalanceHidden,
                  onEditCard: onEditCard,
                  warningText: warningText,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BonusCard extends StatelessWidget {
  const _BonusCard({
    required this.bonusCard,
    required this.isBalanceHidden,
    required this.onEditCard,
  });

  final AttachedCard bonusCard;
  final bool isBalanceHidden;
  final Function(AttachedCard) onEditCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadlineV2(title: locale.getText('paynet_bonus_card')),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () => onEditCard(bonusCard),
          child: RoundedContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CardCell(
                cardIcon: MiniCard(
                  lastFour: lastFour(bonusCard.number!),
                  cardBrand: cardBrandTextLogoFromType(bonusCard.type),
                  backgroundColor: ColorUtils.colorSelect[bonusCard.color]!,
                ),
                cardName:
                    '${locale.getText('bonus_card')}${cardNameTrailing(bonusCard.number!)}',
                cardBalance: formatAmount(bonusCard.balance!, isHidden: isBalanceHidden),
                cardCurrency: locale.getText('sum'),
                isOpaque: isCardValid(bonusCard.status),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _ReorderAbleItem extends StatelessWidget {
  const _ReorderAbleItem({
    required this.card,
    required this.index,
    required this.isReorderOn,
    required this.isBalanceHidden,
    required this.onEditCard,
    required this.deleteCard,
    required this.warningText,
    super.key,
  });

  final AttachedCard card;
  final int index;
  final bool isReorderOn;
  final bool isBalanceHidden;
  final Function(AttachedCard) onEditCard;
  final Function(String) deleteCard;
  final String Function(CardStatus?) warningText;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      enabled: isReorderOn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isReorderOn ? () {} : () => onEditCard(card),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isReorderOn
                    ? GestureDetector(
                        onTap: () => deleteCard(card.token!),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: ActionIcons.addBox
                              .copyWith(color: IconAndOtherColors.error),
                        ),
                      )
                    : const SizedBox(width: 12),
                Expanded(
                  child: CardCell(
                    cardIcon: MiniCard(
                      lastFour: lastFour(card.number!),
                      cardBrand: cardBrandTextLogoFromType(card.type),
                      backgroundColor: ColorUtils.colorSelect[card.color]!,
                    ),
                    cardName: '${card.name}${cardNameTrailing(card.number!)}',
                    cardBalance: formatAmount(card.balance, isHidden: isBalanceHidden),
                    cardCurrency: locale.getText('sum'),
                    isOpaque: isCardValid(card.status),
                  ),
                ),
                isReorderOn
                    ? Padding(
                        padding: const EdgeInsets.all(12),
                        child: ActionIcons.move,
                      )
                    : const SizedBox(width: 12),
              ],
            ),
            if (!isCardValid(card.status)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Infobox.warning(text: warningText(card.status)),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
