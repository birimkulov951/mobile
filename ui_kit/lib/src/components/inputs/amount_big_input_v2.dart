import 'package:flutter/material.dart';

import 'package:ui_kit/ui_kit.dart';

import 'formatters/amount_big_formatter.dart';

class AmountBigControllerV2 extends TextEditingController {
  AmountBigControllerV2({
    required this.symbol,
    required this.focusNode,
    this.includeSymbolInHint = true,
    this.hintText,
    String? text = '',
  }) : super(text: text);

  final String symbol;
  final FocusNode focusNode;
  final String? hintText;
  final bool includeSymbolInHint;

  @override
  void clear() {
    value = const TextEditingValue(
        text: '', selection: TextSelection.collapsed(offset: 0));
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> children = [];
    final isHintShown = focusNode.hasFocus && value.text.isEmpty;

    final textStyle = isHintShown
        ? Typographies.title2Hint.copyWith(
            fontSize: 28,
            height: 32 / 28,
          )
        : style;

    late final symbolTextSpan;
    if (isHintShown) {
      if (includeSymbolInHint) {
        symbolTextSpan = TextSpan(
          text: symbol,
          style: textStyle,
        );
      } else {
        symbolTextSpan = TextSpan(
          text: '',
          style: textStyle,
        );
      }
    } else {
      symbolTextSpan = TextSpan(
        text: symbol,
        style: textStyle,
      );
    }

    if (text.isEmpty) {
      if (focusNode.hasFocus) {
        children.insert(
          0,
          TextSpan(
            text: hintText,
            style: Typographies.title2Hint.copyWith(
              fontSize: 28,
              height: 32 / 28,
            ),
          ),
        );
      } else {
        children.insert(
          0,
          TextSpan(
            text: '0',
            style: style,
          ),
        );
      }
    } else {
      children.add(TextSpan(style: style, text: text));
    }

    children.insert(children.length, symbolTextSpan);
    return TextSpan(children: children);
  }
}

class AmountBigInputV2 extends OrdinaryInput {
  AmountBigInputV2({
    Key? key,
    required this.amountController,
    bool autofocus = false,
    FormFieldValidator<String>? validator,
    int? maxLength,
    Color? contentColor,
    String? helperText,
    EdgeInsets? errorTextPadding,
    EdgeInsets? helperTextPadding,
    EdgeInsets? margin,
    EdgeInsets? contentPadding,
    double? height,
    TextStyle? errorTextStyle,
    TextStyle? fieldTextStyle,
  }) : super(
          key: key,
          controller: amountController,
          keyboardType: TextInputType.number,
          focusNode: amountController.focusNode,
          inputFocusedStyle: fieldTextStyle,
          inputUnfocusedStyle: fieldTextStyle,
          inputErrorStyle: errorTextStyle,
          contentColor: contentColor,
          inputFormatters: [AmountBigFormatter()],
          validationModes: [
            ValidationMode.onUnfocus,
            ValidationMode.onChanged,
          ],
          autofocus: autofocus,
          margin: margin ?? EdgeInsets.zero,
          validator: validator,
          maxLength: maxLength,
          helperText: helperText,
          errorTextPadding: errorTextPadding,
          helperTextPadding: helperTextPadding,
          height: height,
          contentPadding: contentPadding,
        );

  final AmountBigControllerV2 amountController;

  @override
  State<StatefulWidget> createState() => AmountInputStateV2();
}

class AmountInputStateV2 extends OrdinaryInputState<AmountBigInputV2> {
  @override
  InputBorder getInputBorder(String? errorText) {
    if (errorText != null) {
      return UnderlineInputBorder(
          borderSide: BorderSide(color: TextColors.error, width: 2));
    } else if (widget.focusNode.hasFocus) {
      return UnderlineInputBorder(
          borderSide: BorderSide(color: TextColors.accent, width: 2));
    } else {
      return UnderlineInputBorder(
          borderSide:
              BorderSide(color: ControlColors.secondaryActiveV2, width: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
