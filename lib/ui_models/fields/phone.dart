import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:mobile_ultra/main.dart' show locale, pref, suggestionList;

TextInputFormatter _customPhoneNumberFormatter() {
  const _phoneNumberWithCodeLength = 9;
  return TextInputFormatter.withFunction((oldValue, newValue) {
    final rawText = newValue.text.replaceAll(' ', '');

    //обрезаем все что выше 9 символов
    //длина мобильных номеров в Узбекистане равна 9 без кода страны
    if (rawText.length > _phoneNumberWithCodeLength) {
      final phoneNumber = rawText.substring(
        rawText.length - _phoneNumberWithCodeLength,
      );
      return newValue.copyWith(text: phoneNumber);
    } else {
      return newValue;
    }
  });
}

class PhoneField extends StatefulWidget {
  @override
  final GlobalKey<PhoneFieldState>? key;
  final String label;
  final String? defaultValue;
  final String prefix;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final Widget? suffixIcon;
  final VoidCallback? onComplete;
  final TextInputAction action;
  final bool enable;
  final Function(String)? onChanged;

  PhoneField(
    this.label, {
    this.key,
    this.defaultValue,
    this.prefix = '+ 998 ',
    this.focus,
    this.nextFocus,
    this.suffixIcon,
    this.onComplete,
    this.action = TextInputAction.next,
    this.enable = true,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PhoneFieldState();
}

class PhoneFieldState extends State<PhoneField> {
  final TextEditingController phoneController = TextEditingController();
  final MaskTextInputFormatter phoneMask = MaskTextInputFormatter(
      mask: '## ### ## ##', filter: {'#': RegExp(r'[0-9]')});

  OverlayEntry? _suggestionList;
  LayerLink _link = LayerLink();
  List<String> _sortedSuggestionList = [];

  String? error;
  bool? enabled;

  @override
  void initState() {
    super.initState();

    enabled = widget.enable;

    widget.focus?.addListener(_focusListener);
  }

  @override
  void dispose() {
    phoneController.dispose();

    _sortedSuggestionList.clear();
    pref?.saveSuggestions(suggestionList);
    widget.focus?.removeListener(_focusListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _link,
        child: TextField(
          enabled: enabled,
          controller: phoneController,
          focusNode: widget.focus,
          keyboardType: TextInputType.phone,
          textInputAction: widget.action,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            labelText: widget.label,
            prefixText: widget.prefix,
            suffixIcon: widget.suffixIcon,
            prefixStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            errorText: error,
          ),
          inputFormatters: [
            _customPhoneNumberFormatter(),
            phoneMask,
          ],
          onChanged: (value) {
            if (error != null) setState(() => error = null);

            if (value.length == 12) onChangeFocus();

            _updateSuggestions(text: value);
            widget.onChanged?.call(value);
          },
          onEditingComplete: widget.onComplete,
          onSubmitted: (value) => onChangeFocus(),
        ),
      );

  void _focusListener() {
    if (!(widget.focus?.hasFocus ?? true)) {
      _updateSuggestions();

      if (phoneController.text.isNotEmpty &&
          !suggestionList.contains(phoneController.text))
        suggestionList.add(phoneController.text);
    }
  }

  void _updateSuggestions({String text = ''}) {
    if (_suggestionList == null) {
      final width = (context.findRenderObject() as RenderBox).size.width * .8;

      _suggestionList = OverlayEntry(
          builder: (context) => Positioned(
                width: width,
                child: CompositedTransformFollower(
                  link: _link,
                  showWhenUnlinked: false,
                  offset: Offset(0, 45),
                  child: Card(
                    child: Column(
                      children:
                          List.generate(_sortedSuggestionList.length, (index) {
                        final item = _sortedSuggestionList[index];

                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            phoneController.value = phoneMask.formatEditUpdate(
                                TextEditingValue(),
                                TextEditingValue(
                                    text: item.replaceAll(' ', '')));
                            widget.onChanged?.call(item);
                            _updateSuggestions();
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ));

      Overlay.of(context)?.insert(_suggestionList!);
    }

    if (text.isEmpty)
      _sortedSuggestionList = [];
    else
      _sortedSuggestionList = suggestionList
          .where(
              (element) => element.toLowerCase().contains(text.toLowerCase()))
          .toList();

    _suggestionList?.markNeedsBuild();
  }

  void onChangeFocus() {
    widget.focus?.unfocus();
    widget.nextFocus?.requestFocus();
  }

  void setValue(String phone) => phoneController.value = phoneMask
      .formatEditUpdate(TextEditingValue(), TextEditingValue(text: phone));

  void clear() {
    var oldValue = phoneController.value;
    phoneController.clear();
    phoneMask.formatEditUpdate(oldValue, phoneController.value);
  }

  bool get invalidate {
    if (phoneMask.isFill())
      return false;
    else {
      setState(() => error = locale.getText('phone_is_empty'));
      return true;
    }
  }

  void blockState() => setState(() => enabled = !(enabled ?? false));

  String get value => phoneMask.getUnmaskedText();

  String get fullValue =>
      '${widget.prefix.replaceAll('+', '').trim()}${phoneMask.getUnmaskedText()}';

  String get unMaskedFullValue =>
      '${widget.prefix}${phoneMask.getMaskedText()}';
}
