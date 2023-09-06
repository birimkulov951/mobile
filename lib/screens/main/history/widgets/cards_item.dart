import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_ultra/main.dart' show homeData, locale;
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/history/arguments/cards_item_arg.dart';
import 'package:mobile_ultra/ui_models/card/v2/mini_card_widget.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class CardsItem extends StatefulWidget {
  final CardsItemArg cardsItemArg;

  const CardsItem({
    Key? key,
    required this.cardsItemArg,
  }) : super(key: key);

  @override
  _CardsItemState createState() => _CardsItemState();
}

class _CardsItemState extends State<CardsItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextLocale(
            'cards',
            style: TextStylesX.headline,
          ),
        ),
        SizedBox(height: 12),
        homeData?.cards.isEmpty ?? true
            ? SizedBox.shrink()
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    widget.cardsItemArg.selectCard(index);
                  },
                  child: cardItem(
                    uCard: homeData?.cards[index],
                    isSelected: widget.cardsItemArg.selectedCards[index],
                  ),
                ),
                itemCount: homeData?.cards.length,
              ),
      ],
    );
  }

  Widget cardItem({
    AttachedCard? uCard,
    bool isSelected = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 56,
            decoration: BoxDecoration(
              color: ColorNode.MainSecondary,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: MiniCardWidget(
              uCard: uCard,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardNumberAndTypeText(uCard!.token!, uCard.type!),
                style: TextStylesX.textRegularSecondary,
              ),
              SizedBox(height: 2),
              Text(
                '${moneyFormat(uCard.balance)} ${locale.getText('sum')}',
                style: TextStylesX.title5,
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Container(
            height: 20,
            width: 20,
            child: isSelected
                ? SvgPicture.asset(
                    Assets.checkboxActive,
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset(
                    Assets.checkboxInactive,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }
}
