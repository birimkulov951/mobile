import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardFormatter extends TextInputFormatter {
  final _onlyDigist = RegExp(r'\d+');
  final _cardMask = '#### #### #### ####';

  int _offset = 0;
  String value = '';

  Function(String)? _onTapReceiverEnd;
  Function()? _onClear;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      value = '';
      _onClear?.call();
      return newValue;
    }

    _offset = newValue.selection.base.offset;

    String _input = '';

    _onlyDigist.allMatches(newValue.text).toList().forEach((element) {
      _input += element.group(0) ?? '';
    });

    this.value = _formatInputs(_input);

    if (_offset == newValue.text.length) _offset = this.value.length;

    return TextEditingValue(
        text: this.value, selection: TextSelection.collapsed(offset: _offset));
  }

  String _formatInputs(String input, {bool notif = true}) {
    String _result = '';

    if (input.length > 16) input = input.substring(0, 16);
    _result = _formatMask(input, _cardMask);

    if (_result.length == 19 && notif) _onTapReceiverEnd?.call(_result);

    return _result;
  }

  String _formatMask(String value, String mask) {
    var offset = 0;
    String result = '';

    for (int i = 0; i < value.length; i++) {
      if (mask[i + offset] == '#')
        result += value[i];
      else {
        offset++;
        result += ' ${value[i]}';
      }
    }

    return result;
  }

  void setOnTapEndEvent({Function(String)? onTapEnd, VoidCallback? onClear}) {
    _onTapReceiverEnd = onTapEnd;
    _onClear = onClear;
  }

  void setNewValue(String value, {bool notif = false}) =>
      this.value = _formatInputs(value, notif: notif);
}
