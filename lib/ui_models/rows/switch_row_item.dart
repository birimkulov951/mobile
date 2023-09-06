import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_ultra/main.dart';
import 'package:mobile_ultra/resource/assets.dart';

import 'package:mobile_ultra/ui_models/various/shape_circle.dart';
import 'package:mobile_ultra/ui_models/various/title1.dart';
import 'package:mobile_ultra/utils/color_scheme.dart';

class SwitchRowItem extends StatelessWidget {
  final bool isBiometricsEnabled;
  final VoidCallback onTap;

  SwitchRowItem({
    Key? key,
    required this.isBiometricsEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleShape(
          size: 40,
          child: SvgPicture.asset(Assets.fingerPrint),
          color: ColorNode.MainIcon,
        ),
        title: Title1(
          text: locale.getText('biometric_auth'),
          size: 16,
          padding: const EdgeInsets.all(0),
        ),
        trailing: Switch(
          value: isBiometricsEnabled,
          activeColor: ColorNode.Green,
          onChanged: (_) => onTap(),
        ),
        onTap: onTap,
      );
}
