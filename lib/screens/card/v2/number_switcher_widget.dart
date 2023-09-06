import 'package:flutter/material.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';

class NumberSwitcherWidget extends StatefulWidget {
  final int number;
  final ValueChanged<int> onIncrease;
  final ValueChanged<int> onDecrease;

  const NumberSwitcherWidget(
      {required this.number,
      required this.onIncrease,
      required this.onDecrease});

  @override
  State<StatefulWidget> createState() => NumberSwitcherWidgetState();
}

class NumberSwitcherWidgetState extends State<NumberSwitcherWidget> {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            icon: Icon(Icons.keyboard_arrow_left),
            onTap: () => widget.onDecrease(-1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: field(),
          ),
          button(
            icon: Icon(Icons.keyboard_arrow_right),
            onTap: () => widget.onIncrease(1),
          ),
        ],
      );

  Widget button({
    Widget? icon,
    VoidCallback? onTap,
  }) =>
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: ColorNode.Background)),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Center(child: icon),
          onTap: onTap,
        ),
      );

  Widget field() => Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ColorNode.Main,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
            child: Text(
          '${widget.number}',
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
      );
}
