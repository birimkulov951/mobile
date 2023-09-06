import 'package:flutter/material.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/widgets/text_field/amount/amount_manager.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_text_field.dart';

class AmountTextField extends StatelessWidget {
  final GlobalKey? fromFieldKey;
  final AmountFieldManager amountFieldManager;
  final bool? isObscureText;
  final String? labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final InputBorder? border;
  final String? currencyName;
  final bool? isAutofocus;
  final ValidatorCallback? validate;
  final bool? isShowErrorText;

  const AmountTextField({
    required this.amountFieldManager,
    this.fromFieldKey,
    this.isObscureText,
    this.labelText,
    this.hintText,
    this.labelStyle,
    this.textStyle,
    this.textInputAction,
    this.maxLength,
    this.onChanged,
    this.suffixIcon,
    this.border,
    this.currencyName,
    this.isAutofocus,
    this.validate,
    this.isShowErrorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PostfixTextField(
      key: fromFieldKey,
      postFixFieldManager: amountFieldManager,
      isObscureText: isObscureText,
      labelText: labelText,
      hintText: hintText,
      labelStyle: labelStyle,
      textStyle: textStyle,
      textInputAction: textInputAction,
      maxLength: maxLength,
      onChanged: onChanged,
      suffixIcon: suffixIcon,
      border: border,
      postfixText: currencyName,
      isAutofocus: isAutofocus,
      inputFormatters: [
        AmountFormatter.instance,
      ],
      validate: validate,
      isShowErrorText: isShowErrorText,
    );
  }
}
