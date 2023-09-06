import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class ProviderBonusLayout extends StatelessWidget {
  final String value;
  final double fontSize;
  final FontWeight fontWeight;

  const ProviderBonusLayout({
    required this.value,
    this.fontSize = 10,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: ColorNode.Green,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleShape(
              size: 12,
              padding: EdgeInsets.zero,
              color: Colors.white,
              child: SvgPicture.asset(Assets.bonus),
            ),
            SizedBox(width: 5),
            Text(
              value,
              style: TextStyles.caption1.copyWith(
                fontSize: fontSize,
                height: (16 / 14),
                fontWeight: fontWeight,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
}
