import 'package:flutter/services.dart';

class CardFormatter extends TextInputFormatter {
  final _onlyDigist = RegExp(r'\d+');
  final _cardMask = '#### #### #### ####';

  int _offset = 0;
  String value = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    _offset = newValue.selection.base.offset;

    String _input = '';

    _onlyDigist.allMatches(newValue.text).toList().forEach((element) {
      _input += element.group(0) ?? '';
    });

    value = _formatInputs(_input);

    if (_offset == newValue.text.length) _offset = value.length;

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: _offset),
    );
  }

  String _formatInputs(String input) {
    String _result = '';

    if (input.length > 16) input = input.substring(0, 16);
    _result = _formatMask(input, _cardMask);

    return _result;
  }

  String _formatMask(String value, String mask) {
    var offset = 0;
    String result = '';

    for (int i = 0; i < value.length; i++) {
      if (mask[i + offset] == '#') {
        result += value[i];
      } else {
        offset++;
        result += ' ${value[i]}';
      }
    }

    return result;
  }
}
