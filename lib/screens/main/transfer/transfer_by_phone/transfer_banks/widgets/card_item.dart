import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/const.dart';
import 'package:mobile_ultra/utils/u.dart';

class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.cardType,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final int? cardType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorNode.ContainerColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _backgroundColor(),
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1,
                    color: ColorNode.Background,
                    style: BorderStyle.solid,
                  ),
                ),
                child: SvgPicture.asset(_iconUrl()),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyles.textRegular,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _subtitle(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.caption1MainSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: ColorNode.MainSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _iconUrl() {
    switch (cardType) {
      case Const.UZCARD:
        return Assets.uzcardLogo;
      case Const.HUMO:
        return Assets.humoLogo;
      default:
        return Assets.creditCard;
    }
  }

  Color _backgroundColor() {
    switch (cardType) {
      case Const.UZCARD:
      case Const.HUMO:
        return ColorNode.ContainerColor;
      default:
        return ColorNode.accent;
    }
  }

  String _subtitle() {
    switch (cardType) {
      case Const.UZCARD:
      case Const.HUMO:
        return formatCardNumberSecondary(subtitle);
      default:
        return subtitle;
    }
  }
}
