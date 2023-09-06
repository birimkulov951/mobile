import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';

class CarouselListItem extends StatelessWidget {
  final bool isTransferToSelfItem;
  final String itemName;
  final int? cardType;
  final Function() onItemTap;

  const CarouselListItem({
    required this.itemName,
    required this.onItemTap,
    this.isTransferToSelfItem = false,
    this.cardType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: InkWell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _correctColorOfItem,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color:
                      isTransferToSelfItem ? ColorNode.accent : ColorNode.Hint,
                ),
              ),
              child: _listImage,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                itemName,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: TextStyles.caption2SemiBold,
              ),
            ),
          ],
        ),
        onTap: () => onItemTap(),
      ),
    );
  }

  Widget get _transferCardLogo {
    String asset = '';
    switch (cardType) {
      case Const.HUMO:
        asset = Assets.humoLogo;
        break;
      case Const.UZCARD:
        asset = Assets.uzcardLogo;
        break;
      default:
        asset = Assets.transfer;
        break;
    }
    return SvgPicture.asset(asset);
  }

  Widget get _listImage {
    return isTransferToSelfItem
        ? SvgPicture.asset(
            Assets.transferToSelf,
            color: ColorNode.ContainerColor,
          )
        : _transferCardLogo;
  }

  Color get _correctColorOfItem =>
      isTransferToSelfItem ? ColorNode.accent : ColorNode.ContainerColor;
}
