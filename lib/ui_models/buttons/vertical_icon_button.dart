import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

const _buttonSize = 56.0;

class VerticalIconButton extends StatelessWidget {
  final Widget child;
  final String title;
  final double size;
  final Color childBackgroundColor;
  final Color? textColor;
  final VoidCallback onTap;

  VerticalIconButton({
    Key? key,
    required this.child,
    required this.title,
    this.size = _buttonSize,
    this.childBackgroundColor = ColorNode.Icon,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(
          minWidth: 96,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              child: child,
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: CircleBorder(),
                fixedSize: Size(size, size),
                primary: childBackgroundColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextLocale(
                title,
                style: TextStyles.caption1.copyWith(
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
}
