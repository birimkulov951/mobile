import 'package:flutter/material.dart';

import 'package:mobile_ultra/resource/assets.dart';
import 'package:mobile_ultra/screens/main/home/widgets/my_accounts/widgets/row_icon.dart';

const _communalRightPosition = 28.0;
const _internetRightPosition = 56.0;
const _mobileRightPosition = 84.0;

class RowStackedIcons extends StatelessWidget {
  const RowStackedIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: const [
        Positioned(
          right: _mobileRightPosition,
          child: RowIcon(icon: Assets.mobileGts),
        ),
        Positioned(
          right: _internetRightPosition,
          child: RowIcon(icon: Assets.internet),
        ),
        Positioned(
          right: _communalRightPosition,
          child: RowIcon(icon: Assets.communal),
        ),
        RowIcon(icon: Assets.government),
      ],
    );
  }
}
