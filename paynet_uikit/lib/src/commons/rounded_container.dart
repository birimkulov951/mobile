import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    required this.child,
    this.title,
    this.color = BackgroundColors.primary,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 16),
  }) : super(key: key);

  final Widget? title;
  final Widget child;
  final Color? color;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets titlePadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: titlePadding,
            child: title,
          ),
          child,
        ],
      ),
    );
  }
}
