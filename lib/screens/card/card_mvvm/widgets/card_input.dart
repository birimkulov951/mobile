import 'package:flutter/widgets.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class CardInput extends OrdinaryInput {
  CardInput({
    required super.controller,
    required super.focusNode,
    super.key,
    super.hintText,
    super.margin,
    super.autofocus,
    super.validator,
    this.onScanCardTap,
  }) : super(
          keyboardType: TextInputType.phone,
          inputFormatters: [CardFormatter()],
          hintStyle: Typographies.textInputHint,
          validationModes: [ValidationMode.onChanged],
        );

  final ScanCardCallback? onScanCardTap;

  @override
  State<StatefulWidget> createState() => CardInputState();
}

class CardInputState extends OrdinaryInputState<CardInput> {
  @override
  Widget? getSuffix(bool hasError) {
    if (hasError) {
      return warningIcon;
    }
    if (controller.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            final cardNumber = await widget.onScanCardTap?.call();
            if (cardNumber != null) {
              formatAndSetValue(cardNumber);
              widget.focusNode.requestFocus();
            }
          },
          child: ActionIcons.scanCard
              .copyWith(color: IconAndOtherColors.secondary),
        ),
      );
    }
    return super.getSuffix(hasError);
  }

  @override
  Widget getFooter(String? errorText) => const SizedBox.shrink();

  @override
  Widget build(BuildContext context) => super.build(context);
}
