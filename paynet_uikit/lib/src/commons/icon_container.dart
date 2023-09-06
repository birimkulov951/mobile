import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class IconContainer extends StatelessWidget {
  const IconContainer({
    Key? key,
    required this.child,
    this.size = 32.0,
    this.color = ControlColors.accent,
  }) : super(key: key);

  final double size;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(child: child),
    );
  }
}
