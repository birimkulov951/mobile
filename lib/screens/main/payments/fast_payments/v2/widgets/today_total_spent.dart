import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:sprintf/sprintf.dart';

class TodayTotalSpent extends StatelessWidget {
  final double totalSpentAmount;
  final VoidCallback onTapResetTotalAmount;

  const TodayTotalSpent({
    Key? key,
    required this.totalSpentAmount,
    required this.onTapResetTotalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorNode.ContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale.getText('spent_today'),
            style: TextStyles.caption2,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          if (!_isSpentAmountZero) ...[
            SizedBox(height: 16),
            Text(
              sprintf(locale.getText('sum_with_amount'),
                  [formatAmount(totalSpentAmount)]),
              style: TextStyles.textMedium,
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            SizedBox(height: 2),
          ] else ...[
            SizedBox(height: 34),
          ],
          _buttonOrTextWidget,
        ],
      ),
    );
  }

  bool get _isSpentAmountZero {
    return totalSpentAmount == 0;
  }

  Widget get _buttonOrTextWidget {
    if (_isSpentAmountZero) {
      return Text(
        sprintf(locale.getText('sum_with_amount'), ['0']),
        style: TextStyles.textMedium,
      );
    }
    return GestureDetector(
      onTap: onTapResetTotalAmount,
      child: Text(
        locale.getText('reset_expenditure'),
        style: TextStyles.caption2.copyWith(color: ColorNode.Green),
      ),
    );
  }
}
