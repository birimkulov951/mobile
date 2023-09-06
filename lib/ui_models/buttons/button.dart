import 'package:flutter/material.dart';
import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class RoundedButton extends StatelessWidget {
  @override
  final Key? key;
  final double? width;
  final double height;
  final Widget? icon;
  final Widget? child;
  final String title;
  final Color? bg;
  final Color? disabledBgColor;
  final double elevation;
  final Color? color;
  final EdgeInsets margin;
  final bool loading;
  final Function? onPressed;
  final BorderSide borderSide;
  final EdgeInsets? padding;

  RoundedButton({
    this.key,
    this.width = double.infinity,
    this.height = 48,
    this.icon,
    this.elevation = 0,
    this.title = '',
    this.bg = ColorNode.Green,
    this.disabledBgColor,
    this.color = Colors.white,
    this.margin = const EdgeInsets.all(0),
    this.loading = false,
    this.onPressed,
    this.borderSide = BorderSide.none,
    this.child,
    this.padding,
  }) : super(key: key);

  static const _disabledOpacity = 0.3;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        margin: margin,
        child: TextButton(
          child: loading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color!),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: 10),
                    ],
                    child == null
                        ? TextLocale(
                            title,
                            style: TextStyles.captionButton.copyWith(
                              color: color,
                            ),
                          )
                        : Flexible(child: child!),
                  ],
                ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                side: borderSide,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              onPressed == null
                  ? disabledBgColor ?? bg?.withOpacity(_disabledOpacity)
                  : bg,
            ),
            elevation: MaterialStateProperty.all(elevation),
            overlayColor: MaterialStateProperty.all(Colors.black12),
            padding: MaterialStateProperty.all(padding),
          ),
          onPressed: onPressed == null
              ? null
              : () {
                  if (!loading) {
                    onPressed?.call();
                  }
                },
        ),
      );
}
