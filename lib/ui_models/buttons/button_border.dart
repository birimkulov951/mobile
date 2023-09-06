import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class RoundedButtonBorder extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const RoundedButtonBorder({
    required this.title,
    this.width = double.infinity,
    this.height = 48,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = ColorNode.MainSecondary,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: padding,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: backgroundColor)),
        child: RoundedButton(
          bg: Colors.transparent,
          child: TextLocale(
            title,
            style: TextStyles.captionButton,
          ),
          onPressed: onPressed,
        ),
      );
}
