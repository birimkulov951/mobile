import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    required this.amount,
    required this.amountTextStyle,
    required this.suffixTextStyle,
    this.spaceBetween = 4.0,
    this.showDecimals = false,
    this.hideBalance = false,
    super.key,
  });

  factory BalanceWidget.big({
    required double amount,
    required bool hideBalance,
  }) =>
      BalanceWidget(
        amount: amount,
        showDecimals: false,
        hideBalance: hideBalance,
        amountTextStyle: Typographies.title3,
        suffixTextStyle: Typographies.title3Hint,
        spaceBetween: 8.0,
      );

  factory BalanceWidget.medium({
    required double amount,
    required bool hideBalance,
  }) =>
      BalanceWidget(
        amount: amount,
        showDecimals: true,
        hideBalance: hideBalance,
        amountTextStyle: Typographies.headlineSemiBold,
        suffixTextStyle: Typographies.headlineSemiBoldHint,
      );

  factory BalanceWidget.small({
    required double amount,
    required bool hideBalance,
  }) =>
      BalanceWidget(
        amount: amount,
        showDecimals: false,
        hideBalance: hideBalance,
        amountTextStyle: Typographies.cashbackTextMediumConstant,
        suffixTextStyle: Typographies.cashbackTextMediumConstant,
      );

  final double amount;
  final bool showDecimals;
  final bool hideBalance;
  final TextStyle amountTextStyle;
  final TextStyle suffixTextStyle;
  final double spaceBetween;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          hideBalance
              ? '• •••'
              : formatAmount(
                  amount,
                  withDecimals: showDecimals,
                ),
          style: amountTextStyle,
        ),
        SizedBox(width: spaceBetween),
        TextLocale(
          'sum',
          style: suffixTextStyle,
        ),
      ],
    );
  }
}
