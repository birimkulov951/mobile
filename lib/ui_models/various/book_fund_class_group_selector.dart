import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show appTheme, locale;
import 'package:mobile_ultra/ui_models/item/item_container.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class BookFundClassGroupSelector extends StatefulWidget {
  final String? value;
  final Function(String?) onSelect;

  BookFundClassGroupSelector({
    this.value,
    required this.onSelect,
  });

  @override
  State<StatefulWidget> createState() => BookFundClassGroupSelectorState();
}

class BookFundClassGroupSelectorState
    extends State<BookFundClassGroupSelector> {
  int _dropDownPeriodValue = 0;
  String? _group;

  final textFieldCtrl = TextEditingController();

  @override
  void didUpdateWidget(covariant BookFundClassGroupSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    _group = _group ?? widget.value;
  }

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
                  labelText: locale.getText('clazz_group'),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black,
                  )),
            ),
            onTap: _selectClassGroup),
      );

  void _selectClassGroup() {
    viewModalSheet(
      context: context,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Container(
          height: 350,
          child: Stack(
            children: <Widget>[
              Title1(
                text: 'select_clazz_group',
                size: 22,
                weight: FontWeight.w700,
                padding: const EdgeInsets.only(left: 16, top: 16),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, top: 60, right: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ItemContainer(
                          width: 56,
                          height: 32,
                          backgroundColor: _dropDownPeriodValue == 1
                              ? ColorNode.Icon
                              : ColorNode.Background,
                          child: InkWell(
                            child: Center(
                              child: Text(
                                'Рус',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _dropDownPeriodValue == 1
                                        ? Colors.white
                                        : null),
                              ),
                            ),
                            onTap: () =>
                                setState(() => _dropDownPeriodValue = 1),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        ItemContainer(
                          width: 56,
                          height: 32,
                          backgroundColor: _dropDownPeriodValue == 0
                              ? ColorNode.Icon
                              : ColorNode.Background,
                          child: InkWell(
                            child: Center(
                              child: Text(
                                'Eng',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _dropDownPeriodValue == 0
                                        ? Colors.white
                                        : null),
                              ),
                            ),
                            onTap: () =>
                                setState(() => _dropDownPeriodValue = 0),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Builder(builder: (context) {
                      final List<String> _groups = [];

                      if (_dropDownPeriodValue == 0) {
                        for (int i = "a".codeUnitAt(0);
                            i <= "z".codeUnitAt(0);
                            i++) _groups.add(String.fromCharCode(i));
                      } else {
                        for (int i = "а".codeUnitAt(0);
                            i <= "я".codeUnitAt(0);
                            i++) _groups.add(String.fromCharCode(i));
                      }

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 15,
                        crossAxisCount: 7,
                        children: List<Widget>.generate(
                            _groups.length,
                            (index) => Center(
                                  child: GestureDetector(
                                    child: CircleShape(
                                      size: 38,
                                      color: _groups[index] == _group
                                          ? ColorNode.Green
                                          : Colors.transparent,
                                      child: Label(
                                        text: _groups[index],
                                        size: 15,
                                        weight: FontWeight.w500,
                                        color: _groups[index] == _group
                                            ? Colors.white
                                            : appTheme
                                                .textTheme.bodyText2?.color,
                                      ),
                                    ),
                                    onTap: () => setState(() {
                                      _group = _groups[index];
                                      textFieldCtrl.text = _group ?? '';

                                      Future.delayed(
                                          Duration(milliseconds: 250), () {
                                        widget.onSelect(_group);
                                        Navigator.pop(context);
                                      });
                                    }),
                                  ),
                                )),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
