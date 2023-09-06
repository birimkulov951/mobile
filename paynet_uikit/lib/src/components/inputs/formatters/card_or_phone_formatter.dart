import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

const _countryCode = '998';
const _humoStartNumber = '986';
const _phoneStartNumber = '+99';
const _lengthForCheck = 3;
const _phoneShortNUmber = 9;
const _offset = 10;

class CardOrPhoneFormatter extends TextInputFormatter {
  final phoneFormatter = MaskedInputFormatter('+000 00 000 00 00');

  final cardFormatter = MaskedInputFormatter('0000 0000 0000 0000');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text.replaceAll(' ', '');

    if (newText.startsWith('+')) {
      if (newText.length == 1) {
        if (newValue.text.length < oldValue.text.length) {
          newText = '';
        } else {
          newText = newText = _countryCode;
          return phoneFormatter.formatEditUpdate(
            oldValue,
            newValue.copyWith(
              text: newText,
              selection: TextSelection.collapsed(
                offset: newText.length + _offset,
              ),
            ),
          );
        }
      } else if (newText == _phoneStartNumber &&
          newValue.text.length < oldValue.text.length) {
        return newValue.copyWith(
          text: '',
          selection: TextSelection.collapsed(offset: 0),
        );
      } else if (newValue.text.length < oldValue.text.length) {
        return phoneFormatter.formatEditUpdate(oldValue, newValue);
      } else {
        return phoneFormatter.formatEditUpdate(
          oldValue,
          newValue,
        );
      }
      return newValue.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }

    if (newText.startsWith(_countryCode)) {
      return phoneFormatter.formatEditUpdate(
          oldValue,
          newValue.copyWith(
            text: newText,
            selection:
                TextSelection.collapsed(offset: newText.length + _offset),
          ));
    }

    if (newText.startsWith(_humoStartNumber)) {
      return cardFormatter.formatEditUpdate(
        oldValue,
        newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length + _offset),
        ),
      );
    }

    if (newText.length == _lengthForCheck ||
        newText.length == _phoneShortNUmber) {
      final providerCode = getPhoneProviderCode(
        newText,
        customStartIndex: 0,
        customEndIndex: 2,
      );
      if (providerCode != null && hasPhoneProvider(providerCode)) {
        newText = _countryCode + newText;
        return phoneFormatter.formatEditUpdate(
          oldValue,
          newValue.copyWith(
            text: newText,
            selection:
                TextSelection.collapsed(offset: newText.length + _offset),
          ),
        );
      }
    }
    if (newValue.text.length < oldValue.text.length) {
      return cardFormatter.formatEditUpdate(oldValue, newValue);
    }

    return cardFormatter.formatEditUpdate(
      oldValue,
      newValue,
    );
  }
}
