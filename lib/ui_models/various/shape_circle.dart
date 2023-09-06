import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class CircleShape extends StatelessWidget {
  final double? size;
  final Color color;
  final EdgeInsets padding;
  final Widget child;
  final BoxConstraints? constraints;

  CircleShape({
    this.size = 32,
    required this.child,
    Color? color,
    this.constraints,
    this.padding = const EdgeInsets.all(8),
  }) : color = color ?? ColorNode.Icon;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        constraints: constraints,
        padding: padding,
        decoration: ShapeDecoration(shape: CircleBorder(), color: color),
        child: Center(child: child),
      );
}
