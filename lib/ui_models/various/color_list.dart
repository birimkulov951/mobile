import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

/// Горизонтальный список с для выбора цветов заливки
///
class HorizontalColorList extends StatefulWidget {
  final int? selectedColorId;
  final EdgeInsets padding;
  final ValueChanged<int> onSelect;

  HorizontalColorList({
    this.selectedColorId,
    this.padding = EdgeInsets.zero,
    required this.onSelect,
  });

  @override
  State<StatefulWidget> createState() => HorizontalColorListState();
}

class HorizontalColorListState extends State<HorizontalColorList> {
  final ValueNotifier<int> valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    valueNotifier.value = widget.selectedColorId ?? 0;
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: widget.padding,
      child: Container(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 16, right: 6),
          itemCount: ColorUtils.colorSelect.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return SizedBox(width: 10);

            final index = position ~/ 2;

            return ItemColor(
              index: index,
              valueNotifier: valueNotifier,
              onTap: onSelectColor,
            );
          },
        ),
      ));

  void onSelectColor(int index) {
    valueNotifier.value = index;
    widget.onSelect(index);
  }
}

class ItemColor extends StatelessWidget {
  final int index;
  final ValueNotifier<int> valueNotifier;
  final Function(int) onTap;

  ItemColor({
    required this.index,
    required this.valueNotifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (BuildContext context, int value, Widget? child) {
        final double width = index == value ? 32 : 40;
        final double height = width;

        return GestureDetector(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color:
                        index == value ? ColorNode.Green : Colors.transparent,
                    width: 1.5),
                color: Colors.transparent),
            child: Center(
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: ColorUtils.colorSelect[index],
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          onTap: () => onTap(index),
        );
      });
}
