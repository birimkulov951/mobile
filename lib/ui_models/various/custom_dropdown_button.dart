import 'package:flutter/material.dart';


import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  @override
  final GlobalKey<CustomDropdownButtonState>? key;
  final String title;
  final String subTitle;
  final T? value;
  final List<CustomDropdownItem<T>> items;
  final Function? onLoadObjects;
  final ValueChanged<T> onChanged;

  CustomDropdownButton({
    this.key,
    this.title = '',
    this.subTitle = '',
    this.value,
    this.items = const [],
    this.onLoadObjects,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => CustomDropdownButtonState<T>();
}

class CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>> {
  CustomDropdownItem? _selected;
  final textFieldCtrl = TextEditingController();

  @override
  void dispose() {
    textFieldCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
        child: InkWell(
          child: TextField(
            controller: textFieldCtrl,
            enabled: false,
            style: TextStyle(
              fontSize: 18,
            ),
            decoration: InputDecoration(
              labelText: widget.title,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            ),
          ),
          onTap: () {
            if (widget.items.isEmpty) {
              widget.onLoadObjects?.call();
              return;
            }
            Future.delayed(
              const Duration(milliseconds: 200),
              () => showObjectList(),
            );
          },
        ),
      );

  Future showObjectList() async {
    final CustomDropdownItem? result =
        await viewModalSheet<CustomDropdownItem?>(
      context: context,
      compact: true,
      child: Stack(
        children: [
          Title1(
            text: widget.title,
            size: 22,
            weight: FontWeight.w700,
            padding: const EdgeInsets.only(left: 16, top: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 54),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom + 16,
              ),
              child: Column(
                children: List.generate(
                  widget.items.length,
                  (position) {
                    final item = widget.items[position];

                    return ListTile(
                      dense: true,
                      title: item,
                      selected: _selected != null
                          ? _selected?.value == item.value
                          : false,
                      onTap: () {
                        final CustomDropdownItem item = widget.items[position];

                        widget.onChanged(item.value);
                        Navigator.pop(context, item);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (result != null) {
      _selected = result;
      textFieldCtrl.text = _selected?.stringValue ?? "";
    }
  }
}

class CustomDropdownItem<T> extends StatelessWidget {
  final Widget label;
  final T value;
  final String? stringValue;

  CustomDropdownItem({
    required this.label,
    required this.value,
    this.stringValue,
  });

  @override
  Widget build(BuildContext context) => label;
}
