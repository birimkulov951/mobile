import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class TitleCell extends StatelessWidget {
  TitleCell({
    Key? key,
    required this.title,
    this.icon,
    this.action,
  }) : super(key: key);

  TitleCell.Chevron({required String title, Widget? icon})
      : this(
          title: title,
          icon: icon,
          action: ActionIcons.chevronRight16,
        );

  final Widget? icon;
  final String title;
  final Widget? action;

  Widget _getTitle() {
    return Text(
      title,
      style: Typographies.textRegular,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicCell(
      leading: icon,
      title: _getTitle(),
      trailing: action,
    );
  }
}
