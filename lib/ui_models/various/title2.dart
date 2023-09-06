import 'package:flutter/material.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class Title2 extends StatelessWidget {
  final String text;
  final Color? color;
  final double size;
  final EdgeInsets padding;

  Title2({
    required this.text,
    this.color,
    this.size = 24,
    this.padding = const EdgeInsets.only(left: 16),
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding,
        child: TextLocale(
          text,
          style: TextStyle(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.bold,
              letterSpacing: -.2),
        ),
      );
}
