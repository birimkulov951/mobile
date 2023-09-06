import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _defaultPostfix = '';
const _defaultSeparator = ' ';

class PostFixFieldManager {
  String _postfixText = _defaultPostfix;
  String _separator = _defaultSeparator;

  late final PostfixTextEditingController controller;
  late final focusNode = FocusNode();
  late final PostFixFormatter _postFixFormatter;

  String get postfixText => _postfixText;

  String get separator => _separator;

  String get rawTextWithoutPostfix => controller.rawTextWithoutPostfix;

  PostFixFormatter get postFixFormatter => _postFixFormatter;

  void set postfixText(newValue) {
    _postfixText = newValue;
    controller._postfixText = newValue;
    _postFixFormatter._postfixText = newValue;
  }

  PostFixFieldManager(
    RegExp regExp, {
    String? postfixText,
    String? separator,
  }) {
    controller = PostfixTextEditingController();
    _postFixFormatter = PostFixFormatter(regExp);

    this.postfixText = postfixText ?? _defaultPostfix;
    this.separator = separator ?? _defaultSeparator;

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        return;
      }

      final baseOffset = controller.value.selection.baseOffset;

      if (baseOffset < 0) {
        Future.delayed(const Duration(milliseconds: 100)).then((value) {
          controller.rawValue = controller.value.copyWith(
            selection: controller.value.selection.copyWith(
              baseOffset: 0,
              extentOffset: 0,
            ),
          );
        });
      }
    });
  }

  void set separator(newValue) {
    _separator = newValue;
    controller._separator = newValue;
    _postFixFormatter._separator = newValue;
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }

  void update({
    String? postfixText,
    String? separator,
  }) {
    this.postfixText = postfixText ?? this.postfixText;
    this.separator = separator ?? this.separator;
  }
}

/// Контроллер для поля с постфиксом
class PostfixTextEditingController extends TextEditingController {
  late String _postfixText = _defaultPostfix;
  late String _separator = _defaultSeparator;

  @override
  set value(TextEditingValue newValue) {
    if (newValue.text.contains(_postfixText)) {
      super.value = newValue;
      return;
    }

    super.value =
        newValue.copyWith(text: '${newValue.text}$_separator$_postfixText');
  }

  void set rawValue(TextEditingValue newValue) {
    super.value = newValue;
  }

  String get rawTextWithoutPostfix => text
      .substring(0, text.lastIndexOf('$_separator$_postfixText'))
      .replaceAll(' ', '');

  void init() {
    text = '';
  }

  void clearWithoutPostfix() {
    value = TextEditingValue(
      text: '$_separator$_postfixText',
      selection: TextSelection.collapsed(offset: 0),
    );
  }
}

/// Форматтер для жобавления постфикса к тексту в поле ввода
class PostFixFormatter extends TextInputFormatter {
  final RegExp _regExp;

  String _postfixText = _defaultPostfix;
  String _separator = _defaultSeparator;

  int get separatorLength => _separator.length;

  int get postfixLength => _separator.length;

  PostFixFormatter(this._regExp);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
        text: ''
            '${newValue.text.replaceAll(_regExp, '').trim()}'
            '$_separator'
            '$_postfixText');
  }
}
