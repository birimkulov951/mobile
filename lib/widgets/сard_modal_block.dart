import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/ui_models/card/v2/card_item.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/card_select.dart';

/// UI для списка карточек в BS
class CardModalBlock extends StatelessWidget {
  final String title;
  final String sectionTitle;
  final double? bottomPadding;
  final AttachedCard? initCard;
  final List<AttachedCard>? cards;
  final VoidCallback? onPressAddCard;
  final bool isShowBonusCard;

  const CardModalBlock({
    Key? key,
    required this.title,
    required this.sectionTitle,
    this.initCard,
    this.cards,
    this.bottomPadding,
    this.onPressAddCard,
    bool? isShowBonusCard,
  })  : isShowBonusCard = isShowBonusCard ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Title(text: title),
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * .8,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: bottomPadding ?? 0,
            ),
            child: cards == null
                ? const SizedBox.shrink()
                : Column(
                    children: [
                      for (int i = 0; i < cards!.length; i++)
                        if (cards![i].type == Const.WALLET)
                          const SizedBox.shrink()
                        else if (cards![i].type == Const.BONUS)
                          isShowBonusCard
                              ? _BonusCard(
                                  key: const Key(WidgetIds.userBonusCard),
                                  card: cards![i],
                                  initCardToken: initCard?.token,
                                )
                              : const SizedBox.shrink()
                        else ...[
                          const SizedBox(height: 4),
                          _CardSection(
                            key: Key('${WidgetIds.userCardsList}_$i'),
                            card: cards![i],
                            initCardToken: initCard?.token,
                            sectionTitle: sectionTitle,
                          ),
                        ],
                      if (onPressAddCard != null)
                        ItemContainer(
                          margin: EdgeInsets.only(top: 4),
                          backgroundColor: ColorNode.ContainerColor,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: CardSelect.card(
                            key: const Key(WidgetIds.addNewCardToUser),
                            text: locale.getText("add_new_card"),
                            onTap: onPressAddCard,
                            isShowArrow: false,
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final AttachedCard? card;
  final String? initCardToken;
  final String sectionTitle;

  const _CardSection({
    Key? key,
    required this.card,
    required this.initCardToken,
    required this.sectionTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: card?.viewTitle ?? false,
          child: Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _Title(
              text: sectionTitle,
            ),
          ),
        ),
        if (card != null)
          CardItem(
            uCard: card,
            isSelected: initCardToken == card!.token,
            onTap: (card) => Navigator.pop(context, card),
          ),
      ],
    );
  }
}

class _BonusCard extends StatelessWidget {
  final AttachedCard card;
  final String? initCardToken;

  const _BonusCard({
    Key? key,
    required this.card,
    this.initCardToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Title1(
          padding: EdgeInsets.only(
            left: 16,
            top: 24,
            bottom: 12,
          ),
          text: 'bonus_card',
          size: 18,
          weight: FontWeight.w700,
        ),
        CardItem(
          uCard: card,
          isSelected: initCardToken == card.token,
          onTap: (card) => Navigator.pop(context, card),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  _Title({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title1(
      padding: EdgeInsets.only(
        left: 16,
        top: 24,
      ),
      text: text,
      size: 18,
      weight: FontWeight.w700,
    );
  }
}
