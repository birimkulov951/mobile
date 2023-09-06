import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show appTheme;
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class Label extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final double letterSpacing;
  final TextAlign? align;
  final FontWeight? weight;
  final EdgeInsets padding;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;

  Label({
    this.text = '',
    this.color,
    this.size = 14,
    this.letterSpacing = -.2,
    this.align,
    this.weight,
    this.padding = EdgeInsets.zero,
    this.fontStyle,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: TextLocale(
          text,
          textAlign: align,
          overflow: overflow,
          style: TextStyle(
              fontSize: size,
              fontWeight: weight,
              color: color ?? appTheme.textTheme.bodyText1?.color,
              letterSpacing: letterSpacing,
              fontStyle: fontStyle),
        ),
      );
}
