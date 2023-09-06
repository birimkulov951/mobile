import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart' as uiKit;

class AmountInfo extends StatelessWidget {
  final String title;
  final String trailing;

  const AmountInfo({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: uiKit.Typographies.textRegular,
          ),
          const SizedBox(width: 4),
          Text(
            trailing,
            style: uiKit.Typographies.textBold,
          ),
        ],
      ),
    );
  }
}
