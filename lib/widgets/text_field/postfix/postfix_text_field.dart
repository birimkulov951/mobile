import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/locale_helper.dart';
import 'package:mobile_ultra/widgets/locale/locale_builder.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_manager.dart';

typedef ValidatorCallback = String? Function(String?);

/// Текстовое поле с постфиксом
class PostfixTextField extends StatefulWidget {
  final PostFixFieldManager postFixFieldManager;
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
  final String? postfixText;
  final bool? isAutofocus;
  final List<TextInputFormatter>? inputFormatters;
  final ValidatorCallback? validate;
  final bool? isShowErrorText;

  const PostfixTextField({
    required this.postFixFieldManager,
    this.isObscureText,
    this.labelText,
    this.hintText,
    this.textStyle,
    this.labelStyle,
    this.textInputAction,
    this.maxLength,
    this.onChanged,
    this.suffixIcon,
    this.border,
    this.postfixText,
    this.inputFormatters,
    this.isAutofocus,
    this.validate,
    this.isShowErrorText,
    super.key,
  });

  @override
  State<PostfixTextField> createState() => PostfixTextFieldState();
}

class PostfixTextFieldState extends State<PostfixTextField> {
  String? _errorText;

  PostFixFieldManager get _postFixFieldManager => widget.postFixFieldManager;

  PostfixTextEditingController get _controller =>
      _postFixFieldManager.controller;

  FocusNode get _focusNode => _postFixFieldManager.focusNode;

  PostFixFormatter get _postFixFormatter =>
      _postFixFieldManager.postFixFormatter;

  String? get _postfixText => _postFixFieldManager.postfixText;

  int get _separatorLength => _postFixFormatter.separatorLength;

  TextStyle get textStyle {
    return widget.textStyle ?? TextStyles.textInputBold;
  }

  TextStyle get textStyleError {
    return widget.textStyle?.copyWith(color: ColorNode.Red) ??
        TextStyles.textInputBoldRed;
  }

  TextStyle get _labelStyle {
    return widget.labelStyle ?? TextStyles.textInputMainSecondary;
  }

  TextStyle get _labelStyleError {
    return widget.labelStyle?.copyWith(color: ColorNode.Red) ??
        TextStyles.textInputRed;
  }

  bool get _isError => _errorText != null && _errorText!.isNotEmpty;

  @override
  void initState() {
    _postFixFieldManager.update(postfixText: widget.postfixText);
    _controller.init();
    _controller.addListener(_listenText);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PostfixTextField oldWidget) {
    if (oldWidget.postfixText != widget.postfixText) {
      _postFixFieldManager.update(postfixText: widget.postfixText);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.removeListener(_listenText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(builder: (_, LocaleHelper locale) {
      return TextField(
        obscureText: widget.isObscureText ?? false,
        onTap: _onTap,
        focusNode: _focusNode,
        controller: _controller,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          border: widget.border ??
              const UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
          labelText: widget.labelText == null
              ? null
              : locale.getText(widget.labelText!),
          labelStyle: _isError ? _labelStyleError : _labelStyle,
          errorText: (widget.isShowErrorText ?? true) ? _errorText : null,
          hintText:
              widget.hintText == null ? null : locale.getText(widget.hintText!),
          suffixIcon: widget.suffixIcon,
          counterText: '',
        ),
        style: _isError ? textStyleError : textStyle,
        cursorColor: ColorNode.Green,
        keyboardType: TextInputType.number,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        autofocus: widget.isAutofocus ?? false,
        inputFormatters: [
          ...?widget.inputFormatters,
          _postFixFormatter,
        ],
        onChanged: widget.onChanged,
      );
    });
  }

  void _onTap() {
    /// По нажатию, если postfix текст есть, то:
    /// - нажали на введенный текст - смещать курсор не нужно
    /// - Если нажали на postfix - курсор устанавливается перед постфиксом
    /// и разделителем введенного текста и постфикса
    if (_postfixText?.isNotEmpty ?? false) {
      final _postfixPosition =
          _controller.text.indexOf(_postfixText!) - _separatorLength;

      final offset = _controller.value.selection.baseOffset;

      if (offset >= _postfixPosition) {
        _controller.value = _controller.value.copyWith(
          selection: TextSelection.collapsed(
            offset: _postfixPosition,
          ),
        );
      }
    }
  }

  void _listenText() => validate();

  void validate() {
    final errorText = widget.validate?.call(_controller.text);

    if (_errorText != errorText) {
      setState(() => _errorText = errorText);
    }
  }
}
