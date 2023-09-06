import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_kit/ui_kit.dart';

enum ValidationMode {
  onChanged,
  onEditingComplete,
  onSubmitted,
  onFocus,
  onUnfocus,
}

class OrdinaryInput extends StatefulWidget {
  const OrdinaryInput({
    required this.focusNode,
    required this.controller,
    Key? key,
    this.label,
    this.initialValue,
    this.helperText,
    this.helper,
    this.suffix,
    this.inputFormatters,
    this.validator,
    this.validationModes = const [],
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.contentColor,
    this.inputFocusedStyle,
    this.inputUnfocusedStyle,
    this.inputErrorStyle,
    this.autofocus = false,
    this.margin = const EdgeInsets.all(12),
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.errorTextPadding,
    this.helperTextPadding,
    this.height,
    this.prefix,
    this.contentPadding =
        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    this.onClearTap,
  })  : assert(initialValue == null),
        super(key: key);

  final String? label;
  final String? initialValue;
  final FocusNode focusNode;
  final TextEditingController controller;
  final String? helperText;
  final Widget? helper;
  final Widget? suffix;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final List<ValidationMode> validationModes;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Color? contentColor;
  final TextStyle? inputFocusedStyle;
  final TextStyle? inputUnfocusedStyle;
  final TextStyle? inputErrorStyle;
  final EdgeInsetsGeometry margin;
  final bool autofocus;
  final EdgeInsets? helperTextPadding;
  final EdgeInsets? errorTextPadding;
  final EdgeInsets? contentPadding;
  final int? maxLength;
  final String? hintText;
  final TextStyle? hintStyle;
  final double? height;
  final VoidCallback? onClearTap;

  @override
  State<StatefulWidget> createState() => OrdinaryInputState();
}

class OrdinaryInputState<T extends OrdinaryInput> extends State<T> {
  FocusNode get focusNode => widget.focusNode;

  TextEditingController get controller => widget.controller;

  final _formFieldKey = GlobalKey<FormFieldState<String>>();

  @protected
  List<TextInputFormatter>? get inputFormatters => widget.inputFormatters;

  @override
  void initState() {
    _resetFocusListeners();
    super.initState();
  }

  void _resetFocusListeners() {
    focusNode.removeListener(_focusListener);
    focusNode.addListener(_focusListener);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    if (oldWidget.focusNode != widget.focusNode) {
      _resetFocusListeners();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void formatAndSetValue(String value) {
    final oldValue = controller.value;
    final newValue = oldValue.copyWith(text: value);
    var formattedValue = inputFormatters?.fold<TextEditingValue>(
          newValue,
          (TextEditingValue newValue, TextInputFormatter formatter) =>
              formatter.formatEditUpdate(oldValue, newValue),
        ) ??
        newValue;
    formattedValue = formattedValue.copyWith(
        selection: TextSelection.collapsed(offset: formattedValue.text.length));
    controller.value = formattedValue;
    onChanged(formattedValue.text);
  }

  @protected
  void onChanged(String value) {
    _setFormFieldValue(value);
    if (widget.validationModes.contains(ValidationMode.onChanged)) {
      validate();
    }
    setState(() {});
  }

  @protected
  void onSubmitted(String value) {
    _setFormFieldValue(value);
    if (widget.validationModes.contains(ValidationMode.onSubmitted)) {
      validate();
    }
  }

  @protected
  void onEditingComplete() {
    final value = controller.text;
    _setFormFieldValue(value);
    if (widget.validationModes.contains(ValidationMode.onEditingComplete)) {
      validate();
    }
    focusNode.unfocus();
  }

  bool validate() {
    return _formFieldKey.currentState!.validate();
  }

  void _focusListener() {
    if (focusNode.hasFocus) {
      if (widget.validationModes.contains(ValidationMode.onFocus)) {
        validate();
      }
    } else {
      if (widget.validationModes.contains(ValidationMode.onUnfocus)) {
        validate();
      }
    }
    setState(() {});
  }

  void _setFormFieldValue(String? value) {
    // ignore: invalid_use_of_protected_member
    _formFieldKey.currentState?.setValue(value);
  }

  void resetFormField() {
    _formFieldKey.currentState?.reset();
  }

  void onClearTap() {
    controller.clear();
    resetFormField();
    widget.onClearTap?.call();
  }

  TextStyle getInputStyle(String? errorText) {
    if (errorText != null) {
      return widget.inputErrorStyle ?? Typographies.textInputError;
    }
    if (focusNode.hasFocus) {
      return widget.inputFocusedStyle ?? Typographies.textInput;
    }
    return widget.inputUnfocusedStyle ?? Typographies.textInputSecondary;
  }

  TextStyle? getLabelStyle(String? errorText) {
    if (widget.label == null) {
      return null;
    }
    if (errorText != null) {
      return Typographies.textInputError;
    }
    return Typographies.textInputSecondary;
  }

  TextStyle? getHintStyle() {
    if (!focusNode.hasFocus) {
      return Typographies.textInputSecondary;
    }
    return widget.hintStyle ?? Typographies.textInputHint;
  }

  String? getHintText() {
    final hintText = widget.hintText;
    if (hintText != null) {
      return ' ${hintText}';
    }
    return null;
  }

  InputBorder getInputBorder(String? errorText) {
    return widget.label == null
        ? OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          );
  }

  InputDecoration _getFieldDecoration(String? errorText) {
    return InputDecoration(
      border: getInputBorder(errorText),
      focusedBorder: getInputBorder(errorText),
      enabledBorder: getInputBorder(errorText),
      labelText: widget.label,
      labelStyle: getLabelStyle(errorText),
      floatingLabelStyle: getLabelStyle(errorText),
      hintText: getHintText(),
      hintStyle: getHintStyle(),
      contentPadding: widget.contentPadding,
      suffixIconConstraints: const BoxConstraints(),
      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 12),
        child: getSuffix(errorText != null),
      ),
      fillColor: widget.contentColor ?? ControlColors.input,
      filled: true,
      // isDense: true,
      // isCollapsed: true,
      counterText: '',
      prefixIcon: getPrefix(errorText),
      prefixIconConstraints: const BoxConstraints(),
    );
  }

  Widget getFooter(String? errorText) {
    if (errorText != null) {
      return Padding(
        padding:
            widget.errorTextPadding ?? const EdgeInsets.only(top: 8, left: 12),
        child: Text(
          errorText,
          style: Typographies.caption1Error,
          maxLines: 2,
        ),
      );
    } else if (widget.helperText != null) {
      return Padding(
        padding:
            widget.helperTextPadding ?? const EdgeInsets.only(top: 8, left: 12),
        child: widget.helper ??
            Text(
              widget.helperText!,
              style: Typographies.caption1Secondary,
              maxLines: 2,
            ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget getClearIconButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClearTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 4,
            height: 24,
          ),
          OperationIcons.statusDelete
        ],
      ),
    );
  }

  Widget get warningIcon {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: OperationIcons.statusWarning
          .copyWith(color: IconAndOtherColors.error),
    );
  }

  Widget? getSuffix(bool hasError) {
    if (widget.suffix != null) {
      return widget.suffix!;
    }
    if (hasError) {
      if (controller.text.isNotEmpty) {
        return getClearIconButton();
      }
      return warningIcon;
    }
    if (focusNode.hasFocus && controller.text.isNotEmpty) {
      return getClearIconButton();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: _formFieldKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (FormFieldState<String> field) {
        var errorText = field.errorText;
        return Container(
          margin: widget.margin,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: widget.height ?? 58,
                decoration: BoxDecoration(
                  color: widget.contentColor ?? ControlColors.input,
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: widget.autofocus,
                  inputFormatters: inputFormatters,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  cursorWidth: 2,
                  cursorHeight: 20,
                  maxLines: 1,
                  maxLength: widget.maxLength,
                  cursorColor: IconAndOtherColors.accent,
                  style: getInputStyle(errorText),
                  decoration: _getFieldDecoration(errorText),
                  onChanged: onChanged,
                  onEditingComplete: onEditingComplete,
                  onSubmitted: onSubmitted,
                ),
              ),
              getFooter(errorText)
            ],
          ),
        );
      },
    );
  }

  Widget? getPrefix(String? errorText) {
    if (widget.prefix != null) {
      return Padding(
        padding: EdgeInsets.only(left: 12, right: 8),
        child: widget.prefix,
      );
    }
  }
}
