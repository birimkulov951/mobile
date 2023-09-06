import 'package:flutter/widgets.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class RoundedRectangle extends StatelessWidget {
  final double width, height;
  final Color color;
  final EdgeInsets? margin;
  final Widget? child;
  final VoidCallback? onTap;

  RoundedRectangle({
    this.width = 42,
    this.height = 36,
    this.color = ColorNode.Box,
    this.margin,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: Container(
          width: width,
          height: height,
          margin: margin,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)), color: color),
          child: child,
        ),
        onTap: onTap,
      );
}
