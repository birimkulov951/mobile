import 'package:flutter/widgets.dart';
import 'package:ui_kit/ui_kit.dart';

class ExpirationInput extends OrdinaryInput {
  ExpirationInput({
    required super.controller,
    required super.focusNode,
    super.key,
    super.hintText,
    super.margin,
    super.validator,
    this.onScanCardTap,
  }) : super(
          keyboardType: TextInputType.number,
          inputFormatters: [ExpirationDateFormatter()],
          hintStyle: Typographies.textInputHint,
          validationModes: [ValidationMode.onChanged],
        );

  final ScanCardCallback? onScanCardTap;

  @override
  State<StatefulWidget> createState() => CardInputState();
}

class CardInputState extends OrdinaryInputState<ExpirationInput> {
  @override
  Widget? getSuffix(bool hasError) {
    if (hasError) {
      return warningIcon;
    }
    return super.getSuffix(hasError);
  }

  @override
  Widget getFooter(String? errorText) => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) => super.build(context);
}
