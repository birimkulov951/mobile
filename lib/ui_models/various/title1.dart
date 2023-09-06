import 'package:flutter/material.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class Title1 extends StatelessWidget {
  final String text;
  final double size;
  final EdgeInsets padding;
  final Color? color;
  final FontWeight weight;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  Title1({
    required this.text,
    this.size = 20,
    this.color,
    this.padding = const EdgeInsets.only(left: 16),
    this.weight = FontWeight.w400,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: TextLocale(
          text,
          textAlign: textAlign,
          overflow: overflow,
          style: TextStyle(
            fontSize: size,
            color: color,
            fontWeight: weight,
          ),
        ),
      );
}
