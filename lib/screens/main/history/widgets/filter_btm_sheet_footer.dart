import 'package:flutter/material.dart';
import 'package:mobile_ultra/ui_models/buttons/button.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class FilterBtmSheetFooter extends StatefulWidget {
  final Function() showOnTap;
  final Function() resetOnTap;

  const FilterBtmSheetFooter({
    Key? key,
    required this.showOnTap,
    required this.resetOnTap,
  }) : super(key: key);

  @override
  _FilterBtmSheetFooterState createState() => _FilterBtmSheetFooterState();
}

class _FilterBtmSheetFooterState extends State<FilterBtmSheetFooter> {
  @override
  Widget build(context) {
    final bottomHeight = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      height: 72 + bottomHeight,
      padding: EdgeInsets.only(
          right: 16, top: 16, left: 16, bottom: bottomHeight + 16),
      decoration: BoxDecoration(
        color: ColorNode.Background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: RoundedButton(
              bg: ColorNode.Background,
              color: ColorNode.Dark1,
              borderSide: BorderSide(
                color: ColorNode.Dark1,
              ),
              title: 'reset',
              onPressed: widget.resetOnTap,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: RoundedButton(
              bg: ColorNode.Green,
              title: 'show',
              onPressed: widget.showOnTap,
            ),
          ),
        ],
      ),
    );
  }
}
