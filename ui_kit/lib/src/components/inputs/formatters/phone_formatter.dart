import 'package:flutter/services.dart';

final nonDigitsRegex = RegExp(r'\D');

class PhoneFormatter extends TextInputFormatter {
  PhoneFormatter({required this.mask, required this.countryCode}) {
    _init();
  }

  final String mask;
  final String countryCode;
  late final String countryFullCode;
  late final int phoneFullLength;
  late final int phoneShortLength;

  void _init() {
    countryFullCode = mask.startsWith('+') ? '+ $countryCode' : countryCode;
    final cleanedMask = mask.replaceAll(nonDigitsRegex, '');
    phoneFullLength = cleanedMask.length;
    phoneShortLength = cleanedMask.length - countryCode.length;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    newValue = _formatPhone(oldValue, newValue);
    return _maskFormat(oldValue, newValue);
  }

  TextEditingValue _maskFormat(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final valueList = newValue.text.replaceAll(nonDigitsRegex, '').split('');

    var baseOffset = newValue.selection.baseOffset;

    final isAddSymbol = oldValue.text.length < newValue.text.length;
    final isRemoveSymbol = oldValue.text.length > newValue.text.length;

    final StringBuffer buffer = StringBuffer();

    for (var i = 0; i < mask.length; i++) {
      if (buffer.length == mask.length) {
        break;
      }
      final symbol = mask[i];
      if (symbol == ' ' && i == baseOffset - 1) {
        if (isRemoveSymbol) {
          baseOffset--;
        } else if (isAddSymbol) {
          baseOffset++;
        }
      }
      if (symbol != '0' && valueList.isNotEmpty) {
        buffer.write(symbol);
      } else {
        try {
          final removeAt = valueList.removeAt(0);
          buffer.write(removeAt);
        } on Object catch (_) {
          break;
        }
      }
    }

    final string = buffer.toString();

    if (baseOffset > string.length) {
      baseOffset = string.length;
    }

    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: baseOffset),
    );
  }

  TextEditingValue _formatPhone(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final oldStart = oldValue.selection.start;
    final oldEnd = oldValue.selection.end;
    final newStart = newValue.selection.start;
    final newEnd = newValue.selection.end;

    final isInitial =
        [oldStart, oldEnd, newStart, newEnd].every((e) => e == oldStart);

    if (newValue.text.isEmpty) {
      return _formatEmpty(newValue);
    }

    if (isInitial) {
      return _formatInitial(newValue);
    }

    final isTextRemove = newValue.text.length < oldValue.text.length;
    if (isTextRemove) {
      return _formatTextRemove(newValue, oldValue);
    }

    final String inputText = newValue.text.substring(oldStart, newEnd);

    final cleanedText = inputText.replaceAll('+', '').replaceAll(' ', '');
    if (cleanedText.startsWith(countryCode) &&
        cleanedText.length == phoneFullLength) {
      return _formatFullPhone(newValue, inputText);
    }
    if (cleanedText.length == phoneShortLength) {
      return _formatShortPhone(newValue, inputText);
    }

    final isTextReplacement = oldStart < oldEnd;
    if (isTextReplacement) {
      return _formatReplacement(oldValue, newValue);
    }

    return newValue;
  }

  TextEditingValue _formatInitial(TextEditingValue newValue) {
    final inputText = newValue.text;
    final cleanedText = inputText.replaceAll('+', '').replaceAll(' ', '');
    if (cleanedText.startsWith(countryCode) &&
        cleanedText.length == phoneFullLength) {
      return newValue.copyWith(
        text: inputText,
        selection: TextSelection.collapsed(offset: inputText.length + 2),
      );
    }
    return newValue.copyWith(
      text: countryFullCode + newValue.text,
      selection: TextSelection.collapsed(offset: countryFullCode.length),
    );
  }

  TextEditingValue _formatEmpty(TextEditingValue newValue) {
    return newValue.copyWith(
      text: countryFullCode,
      selection: TextSelection.collapsed(offset: countryFullCode.length),
    );
  }

  TextEditingValue _formatTextRemove(
    TextEditingValue newValue,
    TextEditingValue oldValue,
  ) {
    if (newValue.text.startsWith(countryFullCode)) {
      return newValue;
    } else {
      return oldValue.copyWith(
        text: oldValue.text,
        selection: TextSelection.collapsed(offset: oldValue.text.length),
      );
    }
  }

  TextEditingValue _formatFullPhone(
    TextEditingValue newValue,
    String inputText,
  ) {
    return newValue.copyWith(
      text: inputText,
      selection: TextSelection.collapsed(offset: inputText.length),
    );
  }

  TextEditingValue _formatShortPhone(
    TextEditingValue newValue,
    String inputText,
  ) {
    inputText = countryFullCode + inputText;
    return newValue.copyWith(
      text: inputText,
      selection: TextSelection.collapsed(offset: inputText.length),
    );
  }

  TextEditingValue _formatReplacement(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.text.startsWith(countryFullCode)) {
      return oldValue;
    }
    return newValue;
  }
}
