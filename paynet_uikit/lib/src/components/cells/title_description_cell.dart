import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';

class TitleDescriptionCell extends StatelessWidget {
  TitleDescriptionCell({
    Key? key,
    required this.title,
    required this.descriptor,
    this.icon,
    this.action,
  }) : super(key: key);

  TitleDescriptionCell.Chevron(
      {required String title, required String description, Widget? icon})
      : this(
          title: title,
          descriptor: description,
          icon: icon,
          action: ActionIcons.chevronRight16,
        );

  final Widget? icon;
  final String title;
  final String descriptor;
  final Widget? action;

  Widget _getTitle() {
    return Text(
      title,
      style: Typographies.textRegular,
    );
  }

  Widget _getDescription() {
    return Text(
      descriptor,
      style: Typographies.caption1Secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicCell(
      leading: icon,
      title: _getTitle(),
      subTitle: _getDescription(),
      trailing: action,
    );
  }
}
