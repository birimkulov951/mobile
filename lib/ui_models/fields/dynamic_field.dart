import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile_ultra/domain/payment/merchant_entity.dart';
import 'package:mobile_ultra/domain/permission/permission_entity.dart';
import 'package:mobile_ultra/main.dart' show locale, pref, suggestionList;
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/resource/text_styles.dart';
import 'package:mobile_ultra/screens/base/mwwm/system/widgets/open_app_settings_bottom_sheet.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/various/contact_selector.dart';
import 'package:mobile_ultra/ui_models/various/svg_graphics.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';
import 'package:mobile_ultra/utils/input_formatter/amount_formatter.dart';
import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sprintf/sprintf.dart';

// ignore: must_be_immutable
class DynamicField extends StatefulWidget {
  final textController = TextEditingController();
  @override
  final GlobalKey<DynamicFieldState>? key;
  final MerchantEntity? merchant;
  final MerchantField? fieldInfo;
  final TextInputAction? action;
  final FocusNode? focus, nextFocus;
  final String? defaultValue;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final bool forceBlock;
  final Function(String? typeField, String? value, {bool isAmountWidget})?
      onTap;
  final String? prefix;
  final int? maxLength;
  final Function()? onCalculateFreeSpace;
  final int focusNodeLength;
  final int focusedWidgetId;
  final Function(
      {bool hasPrev,
      bool hasNext,
      bool showButton,
      bool showSwitchers})? updateSwitcherContainer;

  String? phonePrefix;
  bool cashbackExists;

  DynamicField({
    this.key,
    this.merchant,
    this.fieldInfo,
    this.action,
    this.focus,
    this.nextFocus,
    this.defaultValue,
    this.padding = const EdgeInsets.only(
      left: 16,
      top: 12,
      right: 16,
      bottom: 10,
    ),
    this.backgroundColor,
    this.forceBlock = false,
    this.prefix = "+ 998 ",
    this.onTap,
    this.maxLength,
    this.onCalculateFreeSpace,
    this.focusNodeLength = 1,
    this.focusedWidgetId = 1,
    this.updateSwitcherContainer,
    this.cashbackExists = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DynamicFieldState();

  String get value {
    if (fieldInfo?.controlType == 'MONEY' || fieldInfo?.controlType == 'PHONE')
      return textController.text.replaceAll(' ', '');
    else {
      return textController.text.trim();
    }
  }
}

class DynamicFieldState extends State<DynamicField> {
  String? error;
  bool enabled = true;
  MaskTextInputFormatter? _inputMask;

  OverlayEntry? _suggestionList;
  LayerLink _link = LayerLink();
  List<String> _sortedSuggestionList = [];

  bool isOnTapPadding = false;

  @override
  void initState() {
    super.initState();
    enabled = !(widget.fieldInfo?.readOnly ?? false);

    if (widget.forceBlock) {
      enabled = false;
    }

    widget.focus?.addListener(_focusListener);

    switch (widget.fieldInfo?.controlType) {
      case 'PHONE':
        _inputMask = MaskTextInputFormatter(
          mask: widget.fieldInfo?.controlTypeInfo == '9DIGIT'
              ? '## ### ## ##'
              : '### ## ##',
          filter: {'#': RegExp(r'[0-9]')},
        );

        widget.textController.value = _inputMask!.formatEditUpdate(
          TextEditingValue(),
          TextEditingValue(text: widget.defaultValue ?? ''),
        );

        break;
      case 'MONEY':
        if (widget.defaultValue != null) {
          widget.textController.text =
              formatAmount(double.parse(widget.defaultValue!));
          widget.textController.text =
              '${widget.textController.text} ${locale.getText('sum')}';
        }
        break;
      default:
        _initControlAndVariousMask();
        break;
    }
  }

  @override
  void dispose() {
    _sortedSuggestionList.clear();

    pref?.saveSuggestions(suggestionList);

    widget.focus?.dispose();
    widget.textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.fieldInfo?.controlType) {
      case 'PHONE':
        return phoneTF;
      case 'MONEY':
        return moneyTF;
      default:
        return simpleTF;
    }
  }

  Widget get phoneTF => Visibility(
        visible: !(widget.fieldInfo?.isHidden ?? false),
        child: Padding(
          padding: widget.padding,
          child: CompositedTransformTarget(
            link: _link,
            child: TextField(
              key: const Key(WidgetIds.basePaymentPhoneInput),
              enabled: enabled,
              maxLength: widget.maxLength,
              controller: widget.textController,
              keyboardType: TextInputType.phone,
              textInputAction: widget.action,
              focusNode: widget.focus,
              style: TextStyles.textInput,
              decoration: InputDecoration(
                fillColor: widget.backgroundColor,
                labelText: widget.fieldInfo?.label,
                prefix: Text(
                  widget.fieldInfo?.id == 7056 ? widget.prefix ?? '' : '',
                ),
                prefixStyle: TextStyles.textInput,
                errorText: error,
                suffixIcon: enabled
                    ? IconButton(
                        key: const Key(WidgetIds.basePaymentContactsButton),
                        icon: SvgPicture.asset(Assets.contact),
                        onPressed: () async {
                          if (!await Permission.contacts.isGranted) {
                            final permissionStatus =
                                await Permission.contacts.request();

                            if (permissionStatus.isPermanentlyDenied) {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                isDismissible: false,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                builder: (context) =>
                                    OpenAppSettingsBottomSheet(
                                  request: PermissionRequest.contacts(),
                                  onPressed: openAppSettings,
                                ),
                              );
                            }

                            if (!permissionStatus.isGranted) {
                              return;
                            }
                          }
                          FocusScope.of(context).unfocus();

                          if (!await Permission.contacts.isGranted) {
                            if (!await Permission.contacts
                                .request()
                                .isGranted) {
                              return;
                            }
                          }

                          FocusScope.of(context).unfocus();
                          final result = await viewModalSheet(
                            context: context,
                            child: ContactSelector(
                              prefix: widget.phonePrefix,
                            ),
                          );

                          if (result != null &&
                              result.isNotEmpty &&
                              _inputMask != null) {
                            widget.textController.value =
                                _inputMask!.formatEditUpdate(
                              TextEditingValue(),
                              TextEditingValue(
                                text: widget.fieldInfo?.controlTypeInfo ==
                                        '9DIGIT'
                                    ? result
                                    : result.substring(2),
                              ),
                            );
                          }
                        },
                      )
                    : SizedBox(),
              ),
              inputFormatters: _inputMask == null ? null : [_inputMask!],
              onChanged: (value) {
                if (error != null) setState(() => error = null);

                _updateSuggestions(text: value);
                widget.onTap?.call(widget.fieldInfo?.typeName, value,
                    isAmountWidget: true);

                if (widget.fieldInfo?.controlTypeInfo == '9DIGIT') {
                  if (value.length == 12) {
                    onChangeFocus();
                  }
                } else if (value.length == 9) {
                  onChangeFocus();
                }
              },
              onSubmitted: (_) => onChangeFocus(),
            ),
          ),
        ),
      );

  Widget get moneyTF => Visibility(
        visible: !(widget.fieldInfo?.isHidden ?? false),
        child: Padding(
          padding: widget.padding,
          child: TextField(
            key: const Key(WidgetIds.basePaymentMoneyInput),
            controller: widget.textController,
            focusNode: widget.focus,
            keyboardType: TextInputType.number,
            textInputAction: widget.action,
            style: TextStyles.textInput.copyWith(
              color: error != null ? ColorNode.Red : ColorNode.Dark1,
            ),
            scrollPadding: EdgeInsets.only(
              bottom: _getScrollPadding(),
            ),
            decoration: InputDecoration(
              fillColor: widget.backgroundColor,
              labelText: widget.fieldInfo?.label,
              errorText: error,
              helperText: _onCashbackCalculate(),
              hintText: _amountTfHintText(),
              floatingLabelStyle: TextStyles.caption1.copyWith(
                color: error != null ? ColorNode.Red : ColorNode.MainSecondary,
              ),
              helperStyle: TextStyles.caption1.copyWith(color: ColorNode.Green),
              errorStyle: TextStyles.caption1.copyWith(color: ColorNode.Red),
              suffixIcon: Visibility(
                visible: widget.textController.text.isNotEmpty,
                child: IconButton(
                  icon: SvgPicture.asset(
                    error != null ? Assets.alert : Assets.clear,
                  ),
                  onPressed: _onClear,
                ),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              AmountFormatter(
                isCurrencyShown: true,
              ),
            ],
            onChanged: (value) {
              if (error != null) {
                error = null;
              }
              _onCalculateFreeSpace();
              widget.onTap?.call(widget.fieldInfo?.typeName, value,
                  isAmountWidget: true);
              setState(() {});
            },
            onSubmitted: (_) => onChangeFocus(),
            onTap: () {
              isOnTapPadding = true;
              Future.delayed(const Duration(milliseconds: 600), () {
                isOnTapPadding = false;
              });
              _onCalculateFreeSpace();
            },
          ),
        ),
      );

  Widget get simpleTF => Visibility(
        visible: !(widget.fieldInfo?.isHidden ?? false),
        child: Padding(
          padding: widget.padding,
          child: CompositedTransformTarget(
            link: _link,
            child: TextField(
              key: const Key(WidgetIds.basePaymentSimpleInput),
              enabled: enabled,
              maxLength: widget.maxLength,
              controller: widget.textController,
              focusNode: widget.focus,
              textInputAction: widget.action,
              style: TextStyles.textInput,
              keyboardType: _getKeyboardType,
              decoration: InputDecoration(
                fillColor: widget.backgroundColor,
                labelText: widget.fieldInfo?.label,
                errorText: error,
                suffixIcon: enabled ? getTrailingWidget : SizedBox.shrink(),
              ),
              onChanged: (value) {
                if (error != null) {
                  error = null;
                }
                _updateSuggestions(text: value);
                widget.onTap?.call(widget.fieldInfo?.typeName, value,
                    isAmountWidget: true);
                setState(() {});
              },
              onSubmitted: (value) => onChangeFocus(),
              inputFormatters: _inputMask != null ? [_inputMask!] : null,
            ),
          ),
        ),
      );

  TextInputType get _getKeyboardType {
    switch (widget.fieldInfo?.controlType) {
      case 'NUMBER':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  void _initControlAndVariousMask() {
    widget.textController.text = widget.defaultValue ?? '';

    if (widget.merchant?.id != 5209) {
      widget.focus?.addListener(_focusListener);
    }
    if (widget.fieldInfo?.controlTypeInfo == null) {
      return;
    } else {
      if (widget.merchant?.id == 5209) {
        //Ravnaq Bank погашение кредитов, маска для ввода даты yyyy-mm-dd
        _inputMask = MaskTextInputFormatter(
          mask: '####-##-##',
          filter: {'#': RegExp(r'[0-9]')},
        );

        widget.textController.value = _inputMask!.formatEditUpdate(
          TextEditingValue(),
          TextEditingValue(text: widget.defaultValue ?? ''),
        );
      }
    }
  }

  Widget get getTrailingWidget {
    if (widget.merchant?.id == 5209 &&
        _inputMask != null &&
        widget.fieldInfo?.id == 5900) {
      return IconButton(
        key: const Key(WidgetIds.basePaymentCalendarButton),
        icon: SvGraphics.icon('calendar'),
        onPressed: () async {
          FocusScope.of(context).unfocus();

          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );

          if (date != null) {
            widget.textController.value = _inputMask!.formatEditUpdate(
              TextEditingValue(),
              TextEditingValue(
                text: DateFormat('yyyy-MM-dd', locale.prefix).format(date),
              ),
            );
          }
        },
      );
    } else if (widget.textController.text.isNotEmpty) {
      return IconButton(
        icon: SvgPicture.asset(error != null ? Assets.alert : Assets.clear),
        onPressed: _onClear,
      );
    }
    return SizedBox.shrink();
  }

  bool get invalidate {
    if (!(widget.fieldInfo?.isRequired ?? true)) {
      return false;
    }

    switch (widget.fieldInfo?.controlType) {
      case "PHONE":
        if (!(_inputMask?.isFill() ?? true)) {
          setState(() => error = locale.getText('phone_is_empty'));
          return true;
        }
        return false;
      case "MONEY":
        double amount = 0;
        if (widget.textController.text.isNotEmpty) {
          amount = double.parse(widget.textController.text
              .replaceAll(locale.getText('sum'), '')
              .replaceAll(' ', ''));
        }

        final minAmount = widget.merchant?.minAmount;
        final maxAmount = widget.merchant?.maxAmount;

        if (widget.textController.text.isEmpty) {
          error = locale.getText('amount_is_empty');
        } else if (minAmount != null && minAmount > amount) {
          error = sprintf(
              locale.getText('min_amount_error'), [formatAmount(minAmount)]);
        } else if (maxAmount != null && maxAmount < amount) {
          error = sprintf(
              locale.getText('max_amount_error'), [formatAmount(maxAmount)]);
        }

        if (error != null) {
          setState(() {});
          return true;
        }
        return false;
      default:
        if (widget.textController.text.isEmpty)
          error = locale.getText('field_is_empty');
        else if (widget.fieldInfo?.controlType == 'REGEXBOX' &&
            widget.fieldInfo?.controlTypeInfo != null) {
          final regex = RegExp(widget.fieldInfo!.controlTypeInfo!);

          if (!regex.hasMatch(widget.textController.text))
            error = locale.getText('invalid_data');
        }

        if (error != null) {
          setState(() {});
          return true;
        }
        return false;
    }
  }

  get insufficientFunds {
    if (widget.fieldInfo?.controlType == "MONEY") {
      setState(() => error = locale.getText('insufficient_funds'));
    }
  }

  get sufficientFunds {
    error = null;
    setState(() {});
  }

  void onChangeFocus() {
    widget.focus?.unfocus();
    widget.nextFocus?.requestFocus();
  }

  void setEnabledState() {
    if (widget.fieldInfo?.type != 'Q') setState(() => this.enabled = !enabled);
  }

  void _focusListener() {
    _onUpdateSwitcherContainer();

    if (!(widget.focus?.hasFocus ?? true)) {
      _updateSuggestions();

      if (widget.textController.text.isNotEmpty &&
          !suggestionList.contains(widget.textController.text)) {
        suggestionList.add(widget.textController.text);
      }
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
                children: List.generate(_sortedSuggestionList.length, (index) {
                  final item = _sortedSuggestionList[index];

                  return ListTile(
                    key: Key('${WidgetIds.basePaymentSuggestionsList}_$index'),
                    title: Text(
                      item,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      if (widget.fieldInfo?.controlType == 'PHONE') {
                        var phone =
                            item.replaceAll(' ', '').replaceAll('-', '');

                        if (widget.fieldInfo?.controlTypeInfo != '9DIGIT' &&
                            phone.length == 9) phone = phone.substring(2);

                        widget.textController.value =
                            _inputMask?.formatEditUpdate(TextEditingValue(),
                                    TextEditingValue(text: phone)) ??
                                TextEditingValue();
                      } else {
                        widget.textController.value = TextEditingValue(
                          text: item,
                          selection:
                              TextSelection.collapsed(offset: item.length),
                        );
                      }

                      _updateSuggestions();
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      );

      Overlay.of(context)?.insert(_suggestionList!);
    }

    if (text.isEmpty) {
      _sortedSuggestionList = [];
    } else {
      _sortedSuggestionList = suggestionList
          .where(
              (element) => element.toLowerCase().contains(text.toLowerCase()))
          .toList();
    }

    _suggestionList?.markNeedsBuild();
  }

  void _onClear() {
    _onCalculateFreeSpace();
    widget.onTap?.call(widget.fieldInfo?.typeName, '', isAmountWidget: true);
    if (error != null) return;
    setState(() => widget.textController.clear());
  }

  String? _onCashbackCalculate() {
    if (widget.cashbackExists &&
        widget.merchant != null &&
        widget.merchant?.bonus != 0 &&
        widget.textController.text.isNotEmpty) {
      var bonus = widget.merchant?.bonus;
      var amount = double.parse(widget.textController.text
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

  String? _amountTfHintText() {
    return widget.merchant?.maxAmount != null
        ? '${formatAmount(widget.merchant?.minAmount ?? 0)}'
            ' - ${formatAmount(widget.merchant?.maxAmount ?? 0)}'
        : null;
  }

  void _onCalculateFreeSpace() {
    if (widget.onCalculateFreeSpace != null) {
      widget.onCalculateFreeSpace!.call();
    }
  }

  void _onUpdateSwitcherContainer() {
    final focusLength = widget.focusNodeLength;
    final focusedWidgetId = widget.focusedWidgetId;

    if (focusLength != 1) {
      if (focusedWidgetId > 1 &&
          focusedWidgetId < focusLength &&
          widget.fieldInfo?.controlType != 'MONEY') {
        widget.updateSwitcherContainer?.call(
            hasNext: true,
            hasPrev: true,
            showButton: true,
            showSwitchers: focusLength > 2);
      } else if (focusedWidgetId > 1) {
        widget.updateSwitcherContainer?.call(
            hasNext: false,
            hasPrev: true,
            showButton: true,
            showSwitchers: focusLength > 2);
      } else if (focusedWidgetId < focusLength) {
        widget.updateSwitcherContainer?.call(
            hasNext: true,
            hasPrev: false,
            showButton: true,
            showSwitchers: focusLength > 2);
      }
    }
  }

  double _getScrollPadding() {
    return isOnTapPadding
        ? MediaQuery.of(context).viewInsets.bottom +
            (error != null || _onCashbackCalculate() != null ? 120 : 100)
        : MediaQuery.of(context).viewInsets.bottom +
            (error != null || _onCashbackCalculate() != null ? 75 : 50);
  }
}
