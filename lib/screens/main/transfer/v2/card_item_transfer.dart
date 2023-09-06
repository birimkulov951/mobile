import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class CardItemTransfer extends StatelessWidget {
  CardItemTransfer.fromBrandLogo({
    Key? key,
    required this.title,
    required this.text,
    required this.color,
    required this.image,
    this.padding,
    this.onTap,
  })  : cardIcon = Container(
          width: 56,
          height: 40,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: ColorNode.cardBrandBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(image),
        ),
        super(key: key);

  //todo Abdurahmon: this is legacy,must be removed later
  CardItemTransfer.fromSvg({
    Key? key,
    required this.title,
    required this.text,
    required this.image,
    required this.color,
    this.padding,
    this.onTap,
  })  : cardIcon = SvgPicture.asset(
          image,
          width: 56,
          height: 40,
        ),
        super(key: key);

  final String title;
  final String text;
  final String image;
  final Color color;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Widget cardIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ItemContainer(
        backgroundColor: color,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cardIcon,
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                      style: TextStylesX.textRegularSecondary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStylesX.title5,
                    ),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
