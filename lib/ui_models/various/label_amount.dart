import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show pref;
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';

class LabelAmount extends StatelessWidget {
  final double amount;
  final double fontSize1, fontSize2, fontSize3;
  final Color? color;
  final FontWeight weight;
  final bool showResonance;

  LabelAmount({
    this.amount = 0,
    this.color = Colors.black,
    this.fontSize1 = 25,
    this.fontSize2 = 15,
    this.fontSize3 = 18,
    this.weight = FontWeight.normal,
    this.showResonance = false,
  });

  String get _resonance {
    return showResonance
        ? amount > 0
            ? '+ '
            : ''
        : '';
  }

  @override
  Widget build(BuildContext context) {
    String balance = amount.toStringAsFixed(2);
    final indexOf = balance.indexOf('.');

    if (indexOf != -1) balance = balance.substring(indexOf, balance.length);

    return LocaleBuilder(
      builder: (_, locale) => RichText(
        overflow: TextOverflow.ellipsis,
        textScaleFactor: (pref?.isAcceptPhoneScaleFactore ?? false)
            ? MediaQuery.of(context).textScaleFactor
            : 1.0,
        text: TextSpan(
            text: '${_resonance}${formatAmount(amount.truncateToDouble())}',
            style: TextStyle(
                color: color, fontSize: fontSize1, fontWeight: weight),
            children: [
              TextSpan(
                  text: '$balance ',
                  style: TextStyle(
                      color: color, fontSize: fontSize2, fontWeight: weight),
                  children: [
                    TextSpan(
                        text: locale.getText('sum'),
                        style:
                            TextStyle(fontSize: fontSize3, fontWeight: weight))
                  ]),
            ]),
      ),
    );
  }
}
