import 'package:flutter/material.dart';


import 'package:mobile_ultra/utils/color_scheme.dart';

class PayinfoFieldItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? labelWeight;
  final FontWeight? valueWeight;

  const PayinfoFieldItem({
    required this.label,
    required this.value,
    this.valueColor,
    this.labelWeight,
    this.valueWeight,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                height: (16 / 14),
                color: ColorNode.MainSecondary,
                fontWeight: labelWeight ?? FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18.0,
                  height: 22 / 18,
                  color: valueColor ?? ColorNode.Dark1,
                  fontWeight: labelWeight ?? FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );
}
