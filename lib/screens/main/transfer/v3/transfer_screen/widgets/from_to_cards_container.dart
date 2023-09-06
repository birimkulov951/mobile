import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/net/card/model/card.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/transfer/v3/transfer_screen/widgets/transfer_payment_card_item.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';

class FromToCardsContainer extends StatelessWidget {
  final StateNotifier<AttachedCard> selectFromCardState;
  final StateNotifier<AttachedCard> selectToCardState;
  final Function({bool isShowBonusCard}) onTapFrom;
  final Function({bool isShowBonusCard}) onTapTo;
  final VoidCallback? swapSenderWithReceiver;
  final String? Function(CardStatus?) warningText;
  final bool isSelfTransfer;
  final String? cardName;
  final String? resultPan;
  final int? cardType;

  const FromToCardsContainer({
    Key? key,
    required this.selectFromCardState,
    required this.selectToCardState,
    required this.onTapFrom,
    required this.onTapTo,
    required this.isSelfTransfer,
    required this.warningText,
    this.swapSenderWithReceiver,
    this.cardName,
    this.resultPan,
    this.cardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            alignment: Alignment.bottomLeft,
            child: Text(
              locale.getText('where'),
              style: TextStylesX.captionButton,
            ),
          ),
          TransferPaymentCardItem(
            selectCardState: selectFromCardState,
            onTapToSelectCard: onTapFrom,
            warningText: warningText,
          ),
          Row(
            children: [
              const Expanded(
                child: Divider(
                  height: 4,
                  thickness: 1,
                  color: ColorNode.Background,
                ),
              ),
              if (isSelfTransfer)
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: ColorNode.Background,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: const Key(WidgetIds.transferScreenSwapCardsButton),
                    onTap: swapSenderWithReceiver,
                    child: Ink(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(Assets.swapCardsIcon),
                    ),
                  ),
                )
            ],
          ),
          Container(
            height: 24,
            alignment: Alignment.bottomLeft,
            child: Text(
              locale.getText('wheres'),
              style: TextStylesX.captionButton,
            ),
          ),
          TransferPaymentCardItem(
            selectCardState: selectToCardState,
            isSelfTransfer: isSelfTransfer,
            onTapToSelectCard: onTapTo,
            cardName: cardName,
            resultPan: resultPan,
            cardType: cardType,
            warningText: warningText,
          ),
        ],
      ),
    );
  }
}

