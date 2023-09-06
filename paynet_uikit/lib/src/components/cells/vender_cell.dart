import 'package:flutter/material.dart';
import 'package:paynet_uikit/paynet_uikit.dart';
import 'package:paynet_uikit/src/components/cells/basic_cell.dart';

class VenderCell extends StatelessWidget {
  const VenderCell({
    required this.icon,
    required this.title,
    Key? key,
    this.descriptor,
    this.atom,
    this.atomSmall,
  })  : assert(atom == null || atomSmall == null),
        super(key: key);

  final Widget icon;
  final String title;
  final String? descriptor;
  final String? atom;
  final String? atomSmall;

  Widget? _getDescriptor() {
    if (descriptor == null) {
      return null;
    }
    return Text(
      descriptor!,
      style: Typographies.caption1Secondary,
    );
  }

  Widget? _getAtom() {
    Widget child;
    if (atom != null) {
      child = Text(
        atom!,
        style: Typographies.caption1Constant,
      );
    } else if (atomSmall != null) {
      child = Text(
        atomSmall!,
        style: Typographies.menuTitleConstant,
      );
    } else {
      return null;
    }

    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: IconAndOtherColors.accent,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: IconAndOtherColors.constant,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: OperationIcons.cashback.copyWith(
              color: IconAndOtherColors.accent,
              height: 12,
              width: 12,
            ),
          ),
          SizedBox(width: 4),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicCell(
      leading: icon,
      title: Text(
        title,
        style: Typographies.textInput,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
      subTitle: _getDescriptor(),
      trailing: _getAtom(),
      isTrailingInTitle: atom != null || atomSmall != null,
    );
  }
}
