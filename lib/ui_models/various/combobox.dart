import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/text_styles.dart';

import 'package:mobile_ultra/utils/u.dart';
import 'package:mobile_ultra/model/payment/merchant_fields.dart';
import 'package:mobile_ultra/ui_models/item/dropdown_item.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/utils/widget_ids.dart';
import 'package:mobile_ultra/widgets/locale/text_locale.dart';

// ignore: must_be_immutable
class ComboBox extends StatefulWidget {
  @override
  final GlobalKey<ComboBoxState>? key;
  final String? title;
  final MerchantField? field;
  final Color? backgroundColor;
  final bool forceBlock;
  final Function(int, String)? onChanged;
  final ValueNotifier<MerchantFieldValue?> valueNotifierFire =
      ValueNotifier(null);
  final ValueNotifier<MerchantFieldValue?> valueNotifierListener;

  MerchantFieldValue? value;

  ComboBox({
    this.key,
    this.title,
    this.field,
    this.backgroundColor,
    this.forceBlock = false,
    this.onChanged,
    required this.valueNotifierListener,
    this.value,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ComboBoxState();
}

class ComboBoxState extends State<ComboBox> {
  final List<MerchantFieldValue> items = [];
  final textFieldCtrl = TextEditingController();

  bool enabled = true;
  int? parentId;

  @override
  void initState() {
    super.initState();
    enabled = !(widget.field?.readOnly ?? false);
    if (widget.forceBlock) {
      enabled = false;
    }
  }

  @override
  void dispose() {
    textFieldCtrl.dispose();
    items.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Visibility(
        visible: !(widget.field?.isHidden ?? false),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: 16,
            right: 16,
            bottom: 12,
          ),
          child: ValueListenableBuilder<MerchantFieldValue?>(
            valueListenable: widget.valueNotifierListener,
            builder: (BuildContext context, value, child) {
              buildItems(value);

              return InkWell(
                child: TextField(
                  key: const Key(WidgetIds.basePaymentComboBoxInput),
                  controller: textFieldCtrl,
                  enabled: false,
                  style: TextStyles.textInput,
                  decoration: InputDecoration(
                    fillColor: widget.backgroundColor,
                    labelText: widget.field?.label,
                    suffixIcon: widget.forceBlock
                        ? null
                        : Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                  ),
                ),
                onTap: enabled ? () => viewItems() : null,
              );
            },
          ),
        ),
      );

  void buildItems(MerchantFieldValue? forValue) {
    printLog('${widget.title}: ${forValue?.id} | $parentId');

    parentId ??= forValue?.id;

    if (parentId != forValue?.id) {
      parentId = forValue?.id;
      widget.value = null;
      items.clear();
    }

    if (items.isEmpty) {
      widget.field?.values
          ?.where((whereItem) =>
              whereItem?.parentId == '${forValue?.id}' ||
              whereItem?.parentId == forValue?.parentId)
          .forEach((item) {
        if (item != null) {
          items.add(item);
        }
      });

      if (items.isNotEmpty) {
        widget.value ??= items.first;
        textFieldCtrl.text = widget.value?.label ?? '';

        Future.delayed(
          const Duration(milliseconds: 100),
          () => widget.valueNotifierFire.value = widget.value,
        );
      }
    }
  }

  Future<void> viewItems() async {
    items.sort((a, b) {
      final _a = a.label.replaceAll(RegExp('[0-9]'), '');
      final _b = b.label.replaceAll(RegExp('[0-9]'), '');
      return _a.compareTo(_b);
    });
    final result = await viewModalSheet<MerchantFieldValue>(
      context: context,
      compact: true,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 16,
            ),
            child: TextLocale(
              widget.field?.label ?? '',
              style: TextStyles.title4,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 54,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: Column(
                children: List.generate(
                  items.length,
                  (index) => DropdownItem<MerchantFieldValue>(
                    key: Key('${WidgetIds.basePaymentComboBoxItemsList}_$index'),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Text(
                        items[index].label,
                        style: TextStyles.textInput,
                      ),
                    ),
                    value: items[index],
                    onPressed: (value) => Navigator.pop(context, value),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      textFieldCtrl.text = result.label;

      widget.value = result;
      widget.valueNotifierFire.value = result;
      if (widget.onChanged != null)
        widget.onChanged!(result.id, result.prefix ?? '');
    }
  }

  void changeEnable() => setState(() => this.enabled = !enabled);
}
