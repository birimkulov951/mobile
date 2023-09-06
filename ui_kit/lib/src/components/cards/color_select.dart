import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

class ColorSelect extends StatelessWidget {
  final Color chosenColor;
  final Function(int) changeColor;

  const ColorSelect({
    Key? key,
    required this.chosenColor,
    required this.changeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (_, index) => GestureDetector(
          onTap: () => changeColor(index),
          child: Container(
            height: 48,
            width: 48,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: BackgroundColors.primary,
              border: isChosenColor(index)
                  ? Border.all(
                      width: 2,
                      color: ControlColors.primaryActive,
                    )
                  : const Border.fromBorderSide(BorderSide.none),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ColorUtils.colorSelect[index],
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: ColorUtils.colorSelect.keys.length,
      ),
    );
  }

  bool isChosenColor(int colorIndex) =>
      chosenColor.value == ColorUtils.colorSelect[colorIndex]!.value;
}
