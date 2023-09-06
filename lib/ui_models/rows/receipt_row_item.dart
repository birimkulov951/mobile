import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class ReceiptItem extends StatelessWidget {
  final String? label;
  final String? value;
  final Color? color;
  final Color? bg;
  final EdgeInsets padding;
  final FontWeight? labelWeight, valueWeight;
  final double labelSize, valueSize;
  final Function(String?)? onCopied;

  ReceiptItem({
    this.label,
    this.value,
    this.color,
    this.bg,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.labelWeight,
    this.labelSize = 14,
    this.valueSize = 16,
    this.valueWeight,
    this.onCopied,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: bg,
        padding: padding,
        height: 36,
        child: Row(
          children: <Widget>[
            TextLocale(
              label ?? '',
              style: TextStyle(
                color: color ?? ColorNode.MainSecondary,
                fontWeight: labelWeight,
                fontSize: labelSize,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                child: TextLocale(
                  value ?? '',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: color,
                    fontWeight: valueWeight,
                    fontSize: valueSize,
                  ),
                ),
                onLongPress: () async {
                  await Clipboard.setData(ClipboardData(text: value));
                  onCopied?.call(value);
                },
              ),
            ),
          ],
        ),
      );
}
