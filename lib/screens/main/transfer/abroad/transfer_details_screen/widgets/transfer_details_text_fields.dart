import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/widgets/text_field/amount/amount_manager.dart';
import 'package:mobile_ultra/widgets/text_field/amount/amount_text_field.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_manager.dart';
import 'package:mobile_ultra/widgets/text_field/postfix/postfix_text_field.dart';

class TransferDetailsTextField extends StatefulWidget {
  final String label;
  final String currencyName;
  final GlobalKey? fromFieldKey;
  final AmountFieldManager fieldManager;
  final String description;
  final String? errorText;
  final String? countryName;
  final String? countryFlagUri;
  final bool? isAutofocus;
  final ValidatorCallback? amountValidate;

  const TransferDetailsTextField({
    required this.label,
    required this.currencyName,
    required this.fieldManager,
    required this.description,
    this.fromFieldKey,
    this.countryName,
    this.countryFlagUri,
    this.errorText,
    this.isAutofocus,
    this.amountValidate,
    super.key,
  });

  @override
  State<TransferDetailsTextField> createState() =>
      _TransferDetailsTextFieldState();
}

class _TransferDetailsTextFieldState extends State<TransferDetailsTextField> {
  bool _isShowClose = false;

  AmountFieldManager get _fieldManager => widget.fieldManager;

  PostfixTextEditingController get _controller => _fieldManager.controller;

  String get _rawText => _controller.rawTextWithoutPostfix;

  @override
  void initState() {
    _controller.addListener(_listenText);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_listenText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: ColorNode.Main,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AmountTextField(
                    fromFieldKey: widget.fromFieldKey,
                    labelText: widget.label,
                    currencyName: widget.currencyName,
                    amountFieldManager: _fieldManager,
                    isAutofocus: widget.isAutofocus,
                    validate: widget.amountValidate,
                    isShowErrorText: false,
                  ),
                ),
              ),
              _Clear(
                isShow: _isShowClose,
                onPress: _onPressClear,
              ),
              _Country(
                countryFlagUri: widget.countryFlagUri,
                countryName: widget.countryName,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 12,
          ),
          child: widget.errorText == null
              ? Text(
                  widget.description,
                  style: TextStyles.caption1MainSecondary,
                )
              : Text(
                  widget.errorText!,
                  style: TextStyles.caption1Red,
                ),
        ),
      ],
    );
  }

  void _onPressClear() {
    _controller.clearWithoutPostfix();
  }

  void _listenText() {
    if (_isShowClose == _rawText.isNotEmpty) {
      return;
    }
    setState(() {
      _isShowClose = _rawText.isNotEmpty;
    });
  }
}

class _Clear extends StatelessWidget {
  final bool isShow;
  final VoidCallback onPress;

  const _Clear({
    required this.isShow,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: isShow
              ? SvgPicture.asset(
                  Assets.searchClear,
                  width: 16,
                  height: 16,
                )
              : const SizedBox(
                  width: 16,
                  height: 16,
                ),
        ),
      ),
    );
  }
}

class _Country extends StatelessWidget {
  final String? countryFlagUri;
  final String? countryName;

  const _Country({
    this.countryFlagUri,
    this.countryName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1,
            color: ColorNode.Background,
          ),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            if (countryFlagUri != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SvgPicture.asset(
                  countryFlagUri!,
                  width: 24,
                  height: 24,
                ),
              ),
            if (countryName != null)
              Text(
                countryName!,
                style: TextStyles.caption1MainSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
