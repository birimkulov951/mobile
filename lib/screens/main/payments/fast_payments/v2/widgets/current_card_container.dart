import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:sprintf/sprintf.dart';

class CurrentCardContainer extends StatelessWidget {
  final AttachedCard? currentCard;
  final Function({bool isShowBonusCard}) onTapChooseCard;

  const CurrentCardContainer({
    Key? key,
    required this.currentCard,
    required this.onTapChooseCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTapChooseCard(isShowBonusCard: true),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorNode.ContainerColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.getText('payment_card'),
              style: TextStyles.caption2,
            ),
            if (!_isCardNull) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(
                      height: 16,
                      width: 16,
                      child: SvgPicture.asset(_correctIconOfCard)),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                    '${currentCard?.name}',
                    style: TextStyles.caption2SemiBold,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  )),
                  SizedBox(width: 12),
                  SvgPicture.asset(
                    Assets.chevronRightRounded,
                    color: ColorNode.MainSecondary,
                  ),
                ],
              ),
              SizedBox(height: 2),
            ] else ...[
              SizedBox(height: 38),
            ],
            _correctBalanceText,
          ],
        ),
      ),
    );
  }

  String get _correctIconOfCard {
    switch (currentCard?.type) {
      case 1:
        return Assets.uzcardLogo;
      case 2:
        return Assets.paynetLogo;
      case 4:
        return Assets.humoLogo;
      default:
        return Assets.creditCard;
    }
  }

  Widget get _correctBalanceText {
    if (_isCardNull) {
      return Row(
        children: [
          Expanded(
            child: Text(
              locale.getText('select_card'),
              style: TextStyles.caption2SemiBold,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
          SvgPicture.asset(
            Assets.chevronRightRounded,
            color: ColorNode.MainSecondary,
          ),
        ],
      );
    }
    if (currentCard?.status != CardStatus.VALID) {
      return Row(
        children: [
          SvgPicture.asset(Assets.statusLock),
          SizedBox(width: 8),
          Text(
            locale.getText('card_blocked'),
            style: TextStyles.caption2Secondary,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ],
      );
    }
    return Text(
      sprintf(locale.getText('sum_with_amount'),
          [formatAmount((currentCard?.balance))]),
      style: TextStyles.caption2Secondary,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }

  bool get _isCardNull => currentCard == null;
}
