import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show appTheme;

class RowLabel extends StatelessWidget {
  final EdgeInsets padding;
  final String leftTitle, rightTitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  RowLabel({
    required this.leftTitle,
    required this.rightTitle,
    this.trailing,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            leftTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(rightTitle,
                    style: appTheme.textTheme.bodyText1
                        ?.copyWith(fontWeight: FontWeight.w500)),
                trailing == null ? const SizedBox.shrink() : trailing!,
              ],
            ),
            radius: 5,
            onTap: this.onTap == null
                ? null
                : () => Future.delayed(
                    Duration(milliseconds: 200), () => onTap?.call()),
          ),
        ],
      ));
}
