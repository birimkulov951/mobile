import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_ultra/main.dart' show locale;

class CustomTextField extends StatefulWidget {
  @override
  final GlobalKey<CustomTextFieldState>? key;
  final String label;
  final String? error;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final Widget? suffixIcon;
  final VoidCallback? onComplete;
  final Function(String)? onChanged;
  final TextInputAction action;
  final TextInputType inputType;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final bool enable;
  final bool hideText;
  final String? regEx;
  final Color? textColor;
  final String defaultValue;
  final bool counterText;

  CustomTextField(
    this.label, {
    this.key,
    this.error,
    this.focus,
    this.nextFocus,
    this.suffixIcon,
    this.onComplete,
    this.onChanged,
    this.action = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = 120,
    this.enable = true,
    this.hideText = false,
    this.regEx,
    this.defaultValue = '',
    this.textColor,
    this.counterText = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  String? error;
  bool? enabled;
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    enabled = widget.enable;
    textController.text = widget.defaultValue;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
        controller: textController,
        focusNode: widget.focus,
        obscureText: widget.hideText,
        keyboardType: widget.inputType,
        textInputAction: widget.action,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        enabled: enabled,
        style: TextStyle(
            fontSize: 17, color: widget.textColor, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            labelText: widget.label,
            suffixIcon: widget.suffixIcon,
            errorText: error,
            isDense: widget.counterText,
            counterText: widget.counterText ? null : ''),
        onEditingComplete: widget.onComplete,
        onSubmitted: (value) {
          widget.focus?.unfocus();
          widget.nextFocus?.requestFocus();
        },
        onChanged: (value) {
          if (error != null) {
            setState(() {
              error = null;
            });
          }
          widget.onChanged?.call(value);
        },
        inputFormatters: widget.regEx != null
            ? [
                FilteringTextInputFormatter.allow(RegExp(widget.regEx ?? '')),
              ]
            : null,
      );

  void blockState({bool block = true}) => setState(() {
        enabled = !block;
      });

  bool get invalidate {
    if (textController.text.isEmpty) {
      setState(() {
        error = widget.error ?? locale.getText('field_is_empty');
      });
      return true;
    }
    return false;
  }

  String get text => textController.text.trim();

  void setValue(String value) => setState(() {
        error = null;
        textController.text = value;
      });

  void clear() => textController.clear();
}
