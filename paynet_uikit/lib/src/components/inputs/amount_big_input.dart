import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

import 'formatters/amount_big_formatter.dart';

class AmountBigController extends TextEditingController {
  AmountBigController({
    required this.symbol,
    required this.focusNode,
    this.hintText,
    String? text = '',
  }) : super(text: text);

  final String symbol;
  final FocusNode focusNode;
  final String? hintText;

  @override
  void clear() {
    value = const TextEditingValue(
        text: '', selection: TextSelection.collapsed(offset: 0));
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];

    final symbolTextSpan = TextSpan(text: symbol, style: style);

    if (text.isEmpty) {
      if (focusNode.hasFocus) {
        children.insert(
          0,
          TextSpan(
            text: hintText,
            style: Typographies.title2Hint,
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

class AmountBigInput extends OrdinaryInput {
  AmountBigInput({
    Key? key,
    required this.amountController,
    required FocusNode focusNode,
    bool autofocus = false,
    FormFieldValidator<String>? validator,
    int? maxLength,
  }) : super(
          key: key,
          controller: amountController,
          keyboardType: TextInputType.number,
          focusNode: focusNode,
          inputFocusedStyle: Typographies.title2,
          inputUnfocusedStyle: Typographies.title2,
          inputErrorStyle: Typographies.title2Error,
          contentColor: BackgroundColors.modal,
          inputFormatters: [AmountBigFormatter()],
          validationModes: [
            ValidationMode.onUnfocus,
            ValidationMode.onChanged,
          ],
          autofocus: autofocus,
          validator: validator,
          maxLength: maxLength,
        );

  final AmountBigController amountController;

  @override
  State<StatefulWidget> createState() => AmountInputState();
}

class AmountInputState extends OrdinaryInputState<AmountBigInput> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
