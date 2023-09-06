import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';

const _offset = 10;

class ExpirationDateFormatter extends TextInputFormatter {
  final cardFormatter = MaskedInputFormatter('00/00');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text.replaceAll(' ', '');

    return cardFormatter.formatEditUpdate(
      oldValue,
      newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length + _offset)),
    );
  }
}
