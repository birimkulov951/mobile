import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class SelectLanguageButton extends StatelessWidget {
  final Widget icon;
  final String title;
  final double width, height;
  final Color backgroundColor;
  final EdgeInsets padding;
  final CrossAxisAlignment alignment;
  final TextStyle textStyle;
  final bool isSelected;
  final VoidCallback? onClick;

  SelectLanguageButton({
    required this.icon,
    this.title = '',
    this.width = 160,
    this.height = 112,
    this.backgroundColor = ColorNode.Background,
    this.padding = const EdgeInsets.all(12),
    this.alignment = CrossAxisAlignment.start,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    this.isSelected = false,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: isSelected
              ? Border.all(color: ColorNode.Green, width: 1.5)
              : null,
          color: backgroundColor,
        ),
        child: InkWell(
          child: Column(
            crossAxisAlignment: alignment,
            children: [
              icon,
              Spacer(),
              Text(
                title,
                style: textStyle,
              ),
            ],
          ),
          onTap: () => onClick?.call(),
        ),
      );
}
