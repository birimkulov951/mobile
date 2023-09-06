import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

abstract class BaseItemContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  Widget get child;

  BaseItemContainer({
    this.width,
    this.height = 64,
    this.backgroundColor = ColorNode.Background,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: InkWell(
          child: child,
          onTap: onTap,
        ),
      );
}
