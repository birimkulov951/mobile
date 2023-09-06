import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:sprintf/sprintf.dart';

class AmountField extends StatefulWidget {
  @override
  final GlobalKey<AmountFieldState>? key;
  final String label;
  final String defaultValue;
  final TextEditingController? controller;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final VoidCallback? onComplete;
  final Function(String)? onChanged;
  final TextInputAction action;
  final bool enable;
  final double? bonus;
  final Function() onBlockButton;
  final bool cashbackExists;

  AmountField(
    this.label, {
    required this.onBlockButton,
    required this.cashbackExists,
    this.key,
    this.defaultValue = '',
    this.controller,
    this.focus,
    this.nextFocus,
    this.onComplete,
    this.onChanged,
    this.action = TextInputAction.next,
    this.enable = true,
    this.bonus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AmountFieldState();
}

class AmountFieldState extends State<AmountField> {
  late final TextEditingController amountController =
      widget.controller ?? TextEditingController();

  String? error, hint;
  bool? enabled;
  int? maxLength;

  @override
  void initState() {
    super.initState();
    enabled = widget.enable;
    amountController.text = widget.defaultValue;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      amountController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: amountController,
        focusNode: widget.focus,
        keyboardType: TextInputType.number,
        textInputAction: widget.action,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        style: TextStyles.textInput.copyWith(
          color: error != null ? ColorNode.Red : ColorNode.Dark1,
        ),
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              (error != null || _onCashbackCalculate() != null ? 120 : 100),
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: error,
          hintText: hint,
          helperText: _onCashbackCalculate(),
          floatingLabelStyle: TextStyles.caption1.copyWith(
            color: error != null ? ColorNode.Red : ColorNode.MainSecondary,
          ),
          errorStyle: TextStyles.caption1.copyWith(color: ColorNode.Red),
          helperStyle: TextStyles.caption1.copyWith(color: ColorNode.Green),
          suffixIcon: Visibility(
            visible: amountController.text.isNotEmpty,
            child: IconButton(
              icon: SvgPicture.asset(
                error != null ? Assets.alert : Assets.clear,
              ),
              onPressed: _onClear,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          AmountFormatter(
            isCurrencyShown: true,
          ),
        ],
        onChanged: (value) {
          if (error != null) {
            error = null;
          }
          if (widget.onChanged != null) widget.onChanged?.call(value);
          setState(() {});
        },
        onEditingComplete: widget.onComplete,
        onSubmitted: (value) {
          widget.focus?.unfocus();
          widget.nextFocus?.requestFocus();
        },
      );

  void updateHint(String hint) => setState(() {
        this.hint = hint;
      });

  void blockState({bool block = true}) => setState(() {
        enabled = !block;
      });

  bool get invalidate {
    if (amountController.text.isEmpty) {
      setState(() {
        error = locale.getText('amount_is_empty');
      });
      return true;
    }
    return false;
  }

  String get amount => amountController.text.replaceAll(' ', '');

  get insufficientFunds {
    error = locale.getText('insufficient_funds');
    if (error != null) {
      setState(() {});
    }
  }

  get sufficientFunds {
    error = null;
    setState(() {});
  }

  void clear() => amountController.clear();

  void setError({String? error}) => setState(() {
        this.error = error;
      });

  void setValue(String value) => setState(() {
        amountController.text = value;
      });

  void setMaxLength(int? length) {
    maxLength = length;
  }

  void _onClear() {
    widget.onBlockButton.call();

    if (error != null) return;
    setState(() {
      amountController.clear();
    });
  }

  String? _onCashbackCalculate() {
    if (widget.cashbackExists &&
        widget.bonus != null &&
        widget.bonus != 0 &&
        amountController.text.isNotEmpty) {
      var bonus = widget.bonus;
      var amount = double.parse(amountController.text
          .replaceAll(locale.getText('sum'), '')
          .replaceAll(' ', ''));

      if (bonus == 0 || amount == 0) {
        return null;
      }
      return sprintf(locale.getText('cashback_amount_format'),
          [calculatePercentage(bonus!, amount)]);
    }
    return null;
  }
}
