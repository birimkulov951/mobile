import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class CardColorContainer extends StatelessWidget {
  const CardColorContainer({
    Key? key,
    required this.isSelected,
    required this.color,
    required this.margin,
    required this.onSelect,
  }) : super(key: key);

  final bool isSelected;
  final Color color;
  final EdgeInsets margin;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        height: 48,
        width: 48,
        margin: margin,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? CardsColors.green : BackgroundColors.primary,
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: BackgroundColors.primary,
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
