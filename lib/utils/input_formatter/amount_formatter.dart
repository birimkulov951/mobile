import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/utils/input_formatter/input_formatters_utils.dart';
import 'package:mobile_ultra/utils/reg_exp_utils.dart';

class AmountFormatter extends TextInputFormatter {
  static late final instance = AmountFormatter();
  static late final instanceDecimal = AmountFormatter(isDecimal: true);
  static late final instanceCurrency =
      AmountFormatter(isDecimal: false, isCurrencyShown: true);
  static late final instanceDecimalCurrency =
      AmountFormatter(isDecimal: true, isCurrencyShown: true);

  static late final formatter = NumberFormat('#,###');

  final bool isDecimal;
  final bool isCurrencyShown;

  AmountFormatter({
    bool? isDecimal,
    bool? isCurrencyShown,
  })  : isDecimal = isDecimal ?? false,
        isCurrencyShown = isCurrencyShown ?? false;

  static String formatNum(
    num value, {
    bool isDecimal = false,
  }) {
    final f = isDecimal ? instanceDecimal : instance;
    return f
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: value.toString(),
          ),
        )
        .text;
  }

  static String formatNumWithCurrency(
    num value, {
    bool isDecimal = false,
  }) {
    final f = isDecimal ? instanceDecimalCurrency : instanceCurrency;
    return f
        .formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(
            text: value.toString(),
          ),
        )
        .text;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) return newValue;

    if (newValue.text.length > 20) return oldValue;

    return isDecimal
        ? _formatDecimal(oldValue, newValue)
        : _formatNumber(oldValue, newValue);
  }

  TextEditingValue _formatNumber(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// Убираю все не числа
    newValue = numberFormatter.formatEditUpdate(oldValue, newValue);

    /// Убираю запятую которая вставлятеся intl форматтером
    final newText = _format(newValue.text);

    return newValue.copyWith(
      text: isCurrencyShown ? '$newText ${locale.getText('sum')}' : newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  TextEditingValue _formatDecimal(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    /// Отделяю целую и дробную часть
    final list = newText.split('.');

    /// Есть ли введенная точка
    final bool isExistDecimal = list.length > 1;

    /// В целой части оставляю только числа
    String numPart = list[0].replaceAll(noNumberFormatterRegExp, '');

    /// Форматирую к нужному виду целую часть
    numPart = _format(numPart);

    /// Часть после точки
    String? decimalPart;

    /// Если точка присутствует
    if (isExistDecimal) {
      /// Оставляю после запятой только числа
      decimalPart = list[1].replaceAll(noNumberFormatterRegExp, '');

      if (decimalPart.length > 1) {
        /// Если за точкой больше 1 символа
        /// То срезаю лишние k
        decimalPart = decimalPart.substring(0, 2);
      }

      /// Иначе там будет пустая строка либо число из 1 символа
    }

    final resultText = '$numPart'
        '${isExistDecimal ? '.$decimalPart' : ''}';

    return newValue.copyWith(
      text: isCurrencyShown ? '$newText ${locale.getText('sum')}' : newText,
      selection: TextSelection.collapsed(offset: resultText.length),
    );
  }

  String _format(String text) {
    return formatter.format(double.parse(text)).replaceAll(',', ' ');
  }
}
