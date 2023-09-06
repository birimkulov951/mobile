import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:ui_kit/ui_kit.dart';

class CardOrPhoneInput extends OrdinaryInput {
  CardOrPhoneInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    String? hintText,
    String? helperText,
    this.onGetContactTap,
    this.onScanCardTap,
    VoidCallback? onClearTap,
    final FormFieldValidator<String>? validator,
    Key? key,
  }) : super(
          key: key,
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          inputFormatters: [CardOrPhoneFormatter()],
          hintText: hintText,
          helperText: helperText,
          hintStyle: Typographies.textInputHint,
          validationModes: [ValidationMode.onChanged],
          validator: validator,
          onClearTap: onClearTap,
        );

  final GetContactCallback? onGetContactTap;
  final ScanCardCallback? onScanCardTap;

  @override
  State<StatefulWidget> createState() => CardOrPhoneInputState();
}

class CardOrPhoneInputState extends OrdinaryInputState<CardOrPhoneInput> {
  Widget _getSuffixActionsButton() {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final phone = await widget.onGetContactTap?.call();
              if (phone != null) {
                formatAndSetValue(phone);
                widget.focusNode.requestFocus();
              }
            },
            child: OperationIcons.contactsLine
                .copyWith(color: IconAndOtherColors.secondary),
          ),
          SizedBox(width: 12),
          GestureDetector(
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
        ],
      ),
    );
  }

  @override
  Widget? getSuffix(bool hasError) {
    if (controller.text.isEmpty) {
      return _getSuffixActionsButton();
    }
    return super.getSuffix(hasError);
  }

  @override
  Widget build(BuildContext context) => super.build(context);
}
