import 'package:flutter/material.dart';
import 'package:paynet_uikit/src/components/cells/vender_cell.dart';
import 'package:paynet_uikit/src/tokens/colors.dart';
import 'package:paynet_uikit/src/utils/phone_utils.dart';

final _iconSize = 46.0;

class PhoneCell extends StatelessWidget {
  const PhoneCell({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  final String phoneNumber;

  Widget _getIcon() {
    return getPhoneProviderIcon(phoneNumber, size: _iconSize) ??
        Container(
          width: _iconSize,
          height: _iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: IconAndOtherColors.divider)
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return VenderCell(icon: _getIcon(), title: phoneNumber);
  }
}
