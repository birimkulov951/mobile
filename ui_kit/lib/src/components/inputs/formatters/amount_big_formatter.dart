import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AmountBigFormatter extends TextInputFormatter {
  final digitsFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  final numberFormatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cleanValue = digitsFormatter.formatEditUpdate(oldValue, newValue);
    oldValue = newValue;
    newValue = cleanValue;

    var cleanText = newValue.text;

    if (cleanText.startsWith('0')) {
      cleanText = cleanText.substring(1);
    }

    if (cleanText.isNotEmpty) {
      cleanText =
          numberFormatter.format(double.parse(cleanText)).replaceAll(',', ' ');
    }
    var copyWith = newValue.copyWith(
        text: cleanText,
        selection: TextSelection.collapsed(offset: cleanText.length));

    return copyWith;
  }
}
