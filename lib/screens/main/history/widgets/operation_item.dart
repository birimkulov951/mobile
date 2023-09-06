import 'package:flutter/material.dart';
import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/main/history/widgets/history_button.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

class OperationItem extends StatelessWidget {
  final VoidCallback chargeOnTap;
  final VoidCallback withdrawOnTap;
  final bool chargeIsPressed;
  final bool withdrawIsPressed;

  const OperationItem({
    Key? key,
    required this.chargeOnTap,
    required this.withdrawOnTap,
    required this.chargeIsPressed,
    required this.withdrawIsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextLocale(
            'operations',
            style: TextStylesX.headline,
          ),
          SizedBox(height: 24),
          Row(
            children: [
              HistoryButton(
                title: locale.getText('charge'),
                onTap: chargeOnTap,
                isPressed: chargeIsPressed,
              ),
              HistoryButton(
                title: locale.getText('withdraw'),
                onTap: withdrawOnTap,
                isPressed: withdrawIsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
