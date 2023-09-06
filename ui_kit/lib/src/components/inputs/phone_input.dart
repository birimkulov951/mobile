import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ui_kit/ui_kit.dart';

const _uzCountryCode = '998';
const _uzPhoneFormat = '+ 000 00 000 00 00';

class PhoneInput extends OrdinaryInput {
  const PhoneInput({
    Key? key,
    required TextEditingController controller,
    required FocusNode focusNode,
    this.mask = _uzPhoneFormat,
    this.countryCode = _uzCountryCode,
    this.onGetContactTap,
    FormFieldValidator<String>? validator,
    List<ValidationMode> validationModes = const [
      ValidationMode.onUnfocus,
      ValidationMode.onChanged,
    ],
    Color? contentColor,
    TextStyle? inputFocusedStyle,
    TextStyle? inputUnfocusedStyle,
  }) : super(
          key: key,
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.phone,
          validationModes: validationModes,
          validator: validator,
          contentColor: contentColor,
          inputFocusedStyle: inputFocusedStyle,
          inputUnfocusedStyle: inputUnfocusedStyle,
        );

  final String mask;
  final String countryCode;
  final GetContactCallback? onGetContactTap;

  @override
  State<StatefulWidget> createState() => PhoneInputState();
}

class PhoneInputState extends OrdinaryInputState<PhoneInput> {
  @override
  late final List<TextInputFormatter> inputFormatters = [
    PhoneFormatter(mask: widget.mask, countryCode: widget.countryCode)
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      formatAndSetValue(controller.text);
    });
  }

  @override
  Widget? getSuffix(bool hasError) {
    if (controller.text.replaceAll(' ', '').replaceAll('+', '').length ==
        widget.countryCode.length) {
      return _getContactsButton();
    }
    return getClearIconButton();
  }

  @override
  Widget getClearIconButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        formatAndSetValue('');
      },
      child: Padding(
        padding: EdgeInsets.only(left: 4),
        child: OperationIcons.statusDelete,
      ),
    );
  }

  Widget _getContactsButton() {
    if (widget.onGetContactTap == null) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final phone = await widget.onGetContactTap!.call();
        if (phone != null) {
          formatAndSetValue(phone);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 4),
        child: OperationIcons.contacts,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
