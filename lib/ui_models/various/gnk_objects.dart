import 'package:flutter/material.dart';

import 'package:mobile_ultra/main.dart' show locale;
import 'package:mobile_ultra/ui_models/various/label.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/ui_models/modal_sheet/view_modal_sheet.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class GNKObjectsWidget extends StatefulWidget {
  @override
  final GlobalKey<GNKObjectsWidgetState>? key;
  final Function onGetObjects;
  final Function onDropObjects;
  final String? defaultObjectValue;
  final String? title;

  GNKObjectsWidget({
    this.key,
    this.title,
    required this.onGetObjects,
    required this.onDropObjects,
    this.defaultObjectValue,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => GNKObjectsWidgetState();
}

class GNKObjectsWidgetState extends State<GNKObjectsWidget> {
  final List<dynamic> _options = [];
  String _title = '';
  int _selected = 0;
  String? _owner = '';

  String currentInn = '';

  final textFieldCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = widget.title ?? locale.getText('object');

    if (widget.defaultObjectValue != null) {
      Future.delayed(Duration(milliseconds: 300), () => widget.onGetObjects());
    }
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
                labelText: _title,
                suffixIcon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                )),
          ),
          onTap: () {
            FocusScope.of(context).focusedChild?.unfocus();

            if (_options.isEmpty)
              widget.onGetObjects();
            else
              Future.delayed(
                  Duration(milliseconds: 200), () => _onShowOptionList());
          },
        ),
      );

  Future _onShowOptionList() async {
    final result = await viewModalSheet<int>(
        context: context,
        child: Container(
          height: MediaQuery.of(context).size.height * .7,
          child: Stack(children: [
            Title1(
              text: _title,
              size: 22,
              weight: FontWeight.w700,
              padding: const EdgeInsets.only(left: 16, top: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 54),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  primary: false,
                  itemCount: _options.length,
                  itemBuilder: (context, index) => ListTile(
                        title: Title1(
                          text: _options[index]['name'],
                          padding: const EdgeInsets.all(0),
                          size: 18,
                          color: index == _selected
                              ? ColorNode.Green
                              : Colors.black,
                        ),
                        subtitle: _owner == null
                            ? null
                            : Label(
                                text: _owner ?? '',
                                size: 15,
                                weight: FontWeight.w500,
                                color: Colors.grey,
                                padding: const EdgeInsets.only(top: 7),
                              ),
                        onTap: () => Navigator.pop(context, index),
                      )),
            ),
          ]),
        ));

    if (result != null) {
      setState(() {
        _selected = result;
        textFieldCtrl.text = _options[_selected]['name'];
      });
    }
  }

  void onSetOptionList(List<dynamic>? items, String? fio) {
    if (items != null && items.isNotEmpty) {
      _options.addAll(items);
      _owner = fio;

      if (widget.defaultObjectValue != null) {
        _selected = _options.indexWhere(
            (element) => element['value'] == widget.defaultObjectValue);

        if (_selected == -1) _selected = 0;
      }

      setState(() {
        textFieldCtrl.text = _options[_selected]['name'];
        if (_options.length > 1)
          Future.delayed(
              Duration(milliseconds: 250), () => _onShowOptionList());
      });
    }
  }

  void onInputINN(String? value) {
    if (_options.isNotEmpty) {
      if (currentInn != value) {
        _selected = 0;
        _options.clear();
        widget.onDropObjects();
        setState(() {
          _title = locale.getText('object');
        });
      }
    }
  }

  String get selectedObjectValue =>
      _options.isEmpty ? '' : _options[_selected]['value'];
}
