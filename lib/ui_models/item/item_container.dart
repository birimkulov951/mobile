import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  @override
  final Key? key;
  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? backgroundColor;
  final Widget child;

  const ItemContainer({
    this.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white, borderRadius: borderRadius),
        child: child,
      );
}
