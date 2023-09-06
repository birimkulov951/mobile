import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:paynet_uikit/paynet_uikit.dart';
import 'package:sprintf/sprintf.dart';

class AmountInputWidget extends StatelessWidget {
  final double commission;
  final double? commissionAmount;
  final AmountBigControllerV2 amountBigController;
  final String? Function(String?) validator;

  const AmountInputWidget({
    Key? key,
    required this.commission,
    required this.commissionAmount,
    required this.amountBigController,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          alignment: Alignment.bottomLeft,
          child: Text(
            locale.getText('you_transfer'),
            style: TextStyles.captionButton,
          ),
        ),
        AmountBigInputV2(
          key: const Key(WidgetIds.amountInput),
          validator: validator,
          fieldTextStyle: TextStylesX.title2,
          errorTextStyle: TextStylesX.title2.copyWith(color: ColorNode.Red),
          maxLength: 10,
          height: 56,
          contentColor: Colors.transparent,
          autofocus: true,
          helperText: _commissionText,
          contentPadding: EdgeInsets.only(bottom: 12),
          errorTextPadding: EdgeInsets.only(
            top: 8,
            bottom: 12,
          ),
          helperTextPadding: EdgeInsets.only(
            top: 8,
            bottom: 12,
          ),
          amountController: amountBigController,
        ),
      ],
    );
  }

  String get _commissionText {
    String result = '${locale.getText('commission')} $commission%';
    if (commissionAmount != null && commissionAmount != 0) {
      result = result +
          ' - ${sprintf(locale.getText('sum_with_amount'), [
                formatAmount(commissionAmount)
              ])}';
    }
    return result;
  }
}
